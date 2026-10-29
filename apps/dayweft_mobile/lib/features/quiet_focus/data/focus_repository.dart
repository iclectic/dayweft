import 'dart:convert';

import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/quiet_focus/domain/focus_time.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

enum FocusMode { countdown, countUp }

class FocusSnapshot {
  const FocusSnapshot({
    required this.session,
    required this.mode,
    required this.elapsedMilliseconds,
    required this.version,
  });
  final FocusSession session;
  final FocusMode mode;
  final int elapsedMilliseconds;
  final int version;
  int get displayedSeconds => mode == FocusMode.countUp
      ? elapsedMilliseconds ~/ 1000
      : (session.plannedMinutes * 60 - elapsedMilliseconds ~/ 1000).clamp(
          0,
          session.plannedMinutes * 60,
        );
}

typedef _StoredFocus = ({FocusSession session, FocusSessionState timing});

class FocusRepository {
  FocusRepository(this._db, this._time, {Uuid uuid = const Uuid()})
    : _uuid = uuid;
  final DayweftDatabase _db;
  final FocusTimeSource _time;
  final Uuid _uuid;

  Future<FocusSnapshot?> loadActive() => _db.transaction(() async {
    final stored = await _active();
    if (stored == null) return null;
    final reading = await _time.read();
    final projected = _project(stored, reading);
    if (projected.session.status != stored.session.status) {
      return _persist(stored, projected, reading);
    }
    return projected;
  });

  Future<FocusSnapshot> start({
    required String title,
    required FocusMode mode,
    int plannedMinutes = 25,
    String? taskId,
  }) => _db.transaction(() async {
    if (title.trim().isEmpty ||
        title.length > 500 ||
        plannedMinutes < 1 ||
        plannedMinutes > 1440) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Use a title and between 1 and 1440 minutes.',
      );
    }
    if (await _active() != null) {
      throw const PlanningFailure(
        PlanningFailureCode.constraintViolation,
        'Finish or abandon the current session before starting another.',
      );
    }
    Task? task;
    if (taskId != null) {
      task =
          await (_db.select(
                _db.tasks,
              )..where((row) => row.id.equals(taskId) & row.deletedAt.isNull()))
              .getSingleOrNull();
      if (task == null || task.status == 'completed') {
        throw const PlanningFailure(
          PlanningFailureCode.notFound,
          'Choose an available unfinished task.',
        );
      }
    }
    final reading = await _time.read();
    final id = _uuid.v4();
    await _db
        .into(_db.focusSessions)
        .insert(
          FocusSessionsCompanion.insert(
            id: id,
            taskId: Value(taskId),
            title: title.trim(),
            startedAt: reading.wallTime,
            plannedMinutes: plannedMinutes,
            status: 'running',
            createdAt: reading.wallTime,
          ),
        );
    await _db
        .into(_db.focusSessionStates)
        .insert(
          FocusSessionStatesCompanion.insert(
            sessionId: id,
            mode: mode.name,
            anchorMilliseconds: Value(reading.monotonicMilliseconds),
            bootToken: Value(reading.bootToken),
            estimateAtStart: Value(task?.estimatedMinutes),
          ),
        );
    final stored = (await _active())!;
    return _project(stored, reading);
  });

  Future<FocusSnapshot> pause(String id, int version) =>
      _change(id, version, 'pause');
  Future<FocusSnapshot> resume(String id, int version) =>
      _change(id, version, 'resume');
  Future<FocusSnapshot> interrupt(String id, int version) =>
      _change(id, version, 'interrupt');

  Future<FocusSnapshot> restart(String id, int version) =>
      _db.transaction(() async {
        final stored = await _require(id, version);
        await finish(id, version, abandoned: true);
        return start(
          title: stored.session.title,
          mode: FocusMode.values.byName(stored.timing.mode),
          plannedMinutes: stored.session.plannedMinutes,
          taskId: stored.session.taskId,
        );
      });

  Future<FocusSnapshot?> checkpoint() => _db.transaction(() async {
    final stored = await _active();
    if (stored == null) return null;
    final reading = await _time.read();
    final projected = _project(stored, reading);
    if (projected.elapsedMilliseconds == stored.timing.elapsedMilliseconds &&
        projected.session.status == stored.session.status) {
      return projected;
    }
    return _persist(stored, projected, reading);
  });

  Future<FocusSnapshot> _change(String id, int version, String action) =>
      _db.transaction(() async {
        final stored = await _require(id, version);
        final reading = await _time.read();
        final current = _project(stored, reading);
        var status = current.session.status;
        if (action == 'pause' && status == 'running') status = 'paused';
        if (action == 'resume') {
          if (!['paused', 'needsReview'].contains(status)) {
            throw const PlanningFailure(
              PlanningFailureCode.invalidInput,
              'Only a paused session can resume.',
            );
          }
          status = 'running';
        }
        final next = FocusSnapshot(
          session: current.session.copyWith(
            status: status,
            interruptionCount:
                current.session.interruptionCount +
                (action == 'interrupt' ? 1 : 0),
          ),
          mode: current.mode,
          elapsedMilliseconds: current.elapsedMilliseconds,
          version: current.version,
        );
        return _persist(stored, next, reading);
      });

  Future<void> finish(
    String id,
    int version, {
    bool abandoned = false,
    bool completeTask = false,
  }) => _db.transaction(() async {
    final stored = await _require(id, version);
    final reading = await _time.read();
    final current = _project(stored, reading);
    final status = abandoned ? 'abandoned' : 'completed';
    await _persist(
      stored,
      FocusSnapshot(
        session: current.session.copyWith(
          status: status,
          endedAt: Value(reading.wallTime),
          actualMinutes: Value(current.elapsedMilliseconds ~/ 60000),
        ),
        mode: current.mode,
        elapsedMilliseconds: current.elapsedMilliseconds,
        version: current.version,
      ),
      reading,
      active: false,
    );
    if (!abandoned && completeTask && current.session.taskId != null) {
      await _completeTask(current.session.taskId!, reading.wallTime);
    }
  });

  Future<void> _completeTask(String taskId, DateTime now) async {
    final task =
        await (_db.select(_db.tasks)
              ..where((row) => row.id.equals(taskId) & row.deletedAt.isNull()))
            .getSingleOrNull();
    if (task == null) {
      throw const PlanningFailure(
        PlanningFailureCode.notFound,
        'The linked task is no longer available. Finish without changing the task.',
      );
    }
    final previousEvidence = await (_db.select(
      _db.estimationRecords,
    )..where((row) => row.id.equals('focus:$taskId'))).getSingleOrNull();
    final localPlanning = LocalPlanningRepository(_db, now: () => now);
    final plan = task.dayPlanId == null
        ? (await localPlanning.loadToday()).plan
        : await (_db.select(
            _db.dayPlans,
          )..where((row) => row.id.equals(task.dayPlanId!))).getSingle();
    final measurements =
        await (_db.select(_db.focusSessionStates).join([
              innerJoin(
                _db.focusSessions,
                _db.focusSessions.id.equalsExp(
                  _db.focusSessionStates.sessionId,
                ),
              ),
            ])..where(
              _db.focusSessions.taskId.equals(taskId) &
                  _db.focusSessions.status.equals('completed'),
            ))
            .get();
    final milliseconds = measurements.fold<int>(
      0,
      (total, row) =>
          total + row.readTable(_db.focusSessionStates).elapsedMilliseconds,
    );
    final minutes = milliseconds ~/ 60000;
    final estimates = measurements
        .map((row) => row.readTable(_db.focusSessionStates).estimateAtStart)
        .toSet();
    await (_db.update(_db.tasks)..where((row) => row.id.equals(taskId))).write(
      TasksCompanion(
        status: const Value('completed'),
        actualMinutes: Value(minutes),
        updatedAt: Value(now),
        localVersion: Value(task.localVersion + 1),
      ),
    );
    await _db
        .into(_db.scheduleRevisions)
        .insert(
          ScheduleRevisionsCompanion.insert(
            id: _uuid.v4(),
            dayPlanId: plan.id,
            revisionNumber: plan.revision + 1,
            reason: 'Completed a task using measured focus time.',
            createdAt: now,
            reversibleChangeSetJson: jsonEncode({
              'undo': 'restore_focus_task',
              'taskId': taskId,
              'status': task.status,
              'actualMinutes': task.actualMinutes,
              'previousMeasurement': previousEvidence?.toJson(),
            }),
          ),
        );
    await (_db.update(
      _db.dayPlans,
    )..where((row) => row.id.equals(plan.id))).write(
      DayPlansCompanion(
        revision: Value(plan.revision + 1),
        localVersion: Value(plan.localVersion + 1),
        updatedAt: Value(now),
      ),
    );
    // Sub-minute time remains in session records; never round it into evidence.
    if (minutes == 0) return;
    await _db
        .into(_db.estimationRecords)
        .insertOnConflictUpdate(
          EstimationRecordsCompanion.insert(
            id: 'focus:$taskId',
            taskId: Value(taskId),
            category: Value(task.category),
            estimatedMinutes: estimates.first ?? task.estimatedMinutes,
            actualMinutes: minutes,
            measurementSource: const Value('focus'),
            timeOfDay: now.hour < 12
                ? 'morning'
                : now.hour < 17
                ? 'afternoon'
                : 'evening',
            dayOfWeek: now.weekday,
            interruptionCount: Value(
              measurements.fold<int>(
                0,
                (total, row) =>
                    total + row.readTable(_db.focusSessions).interruptionCount,
              ),
            ),
            excluded: Value(estimates.length != 1 || estimates.contains(null)),
            createdAt: now,
          ),
        );
  }

  Future<_StoredFocus?> _active() async {
    final timing = await (_db.select(
      _db.focusSessionStates,
    )..where((row) => row.active.equals(true))).getSingleOrNull();
    if (timing == null) return null;
    final session = await (_db.select(
      _db.focusSessions,
    )..where((row) => row.id.equals(timing.sessionId))).getSingle();
    return (session: session, timing: timing);
  }

  Future<_StoredFocus> _require(String id, int version) async {
    final stored = await _active();
    if (stored == null ||
        stored.session.id != id ||
        stored.timing.version != version) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'The session changed. Refresh before trying again.',
      );
    }
    return stored;
  }

  FocusSnapshot _project(_StoredFocus stored, FocusTimeReading reading) {
    var elapsed = stored.timing.elapsedMilliseconds;
    var status = stored.session.status;
    if (status == 'running') {
      final anchor = stored.timing.anchorMilliseconds;
      if (anchor == null ||
          stored.timing.bootToken != reading.bootToken ||
          reading.monotonicMilliseconds < anchor) {
        status = 'needsReview';
      } else {
        elapsed += reading.monotonicMilliseconds - anchor;
        final limit = stored.timing.mode == FocusMode.countdown.name
            ? stored.session.plannedMinutes * 60000
            : 1440 * 60000;
        if (elapsed >= limit) {
          elapsed = limit;
          status = 'ready';
        }
      }
    }
    return FocusSnapshot(
      session: stored.session.copyWith(status: status),
      mode: FocusMode.values.byName(stored.timing.mode),
      elapsedMilliseconds: elapsed,
      version: stored.timing.version,
    );
  }

  Future<FocusSnapshot> _persist(
    _StoredFocus stored,
    FocusSnapshot current,
    FocusTimeReading reading, {
    bool active = true,
  }) async {
    await (_db.update(
      _db.focusSessions,
    )..where((row) => row.id.equals(stored.session.id))).write(
      FocusSessionsCompanion(
        status: Value(current.session.status),
        endedAt: Value(current.session.endedAt),
        actualMinutes: Value(current.session.actualMinutes),
        interruptionCount: Value(current.session.interruptionCount),
      ),
    );
    final version = stored.timing.version + 1;
    await (_db.update(
      _db.focusSessionStates,
    )..where((row) => row.sessionId.equals(stored.session.id))).write(
      FocusSessionStatesCompanion(
        elapsedMilliseconds: Value(current.elapsedMilliseconds),
        anchorMilliseconds: Value(
          current.session.status == 'running'
              ? reading.monotonicMilliseconds
              : null,
        ),
        bootToken: Value(
          current.session.status == 'running' ? reading.bootToken : null,
        ),
        active: Value(active),
        version: Value(version),
      ),
    );
    return FocusSnapshot(
      session: current.session,
      mode: current.mode,
      elapsedMilliseconds: current.elapsedMilliseconds,
      version: version,
    );
  }
}
