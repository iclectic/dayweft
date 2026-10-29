import 'dart:convert';
import 'dart:isolate';

import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/data_management/domain/day_import.dart';
import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
import 'package:dayweft_mobile/features/templates/data/custom_template_repository.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

export 'package:dayweft_domain/dayweft_domain.dart'
    show DayTemplate, TemplateBlock, TemplatePreview;
export 'package:dayweft_mobile/features/templates/data/starter_templates.dart';

List<String> taskDependencyIds(Task task) {
  final Object? decoded = jsonDecode(task.dependencyIdsJson);
  if (decoded is! List<Object?> || decoded.any((id) => id is! String)) {
    throw const PlanningFailure(
      PlanningFailureCode.invalidInput,
      'Stored task dependencies could not be read. Restore a valid local backup.',
    );
  }
  return decoded.cast<String>();
}

domain.TaskDetails taskDetailsFor(Task task) => domain.TaskDetails(
  title: task.title,
  estimatedMinutes: task.estimatedMinutes,
  priority: domain.TaskPriority.values.byName(task.priority),
  category: task.category,
  notes: task.notes,
  deadline: task.deadline,
  energyRequired: task.energyRequired == null
      ? null
      : domain.EnergyLevel.values.byName(task.energyRequired!),
  cognitiveLoad: task.cognitiveLoad == null
      ? null
      : domain.CognitiveLoad.values.byName(task.cognitiveLoad!),
  canSplit: task.canSplit,
  minimumUsefulMinutes: task.minimumUsefulMinutes,
  dependencyIds: taskDependencyIds(task),
);

class LocalDaySnapshot {
  const LocalDaySnapshot({
    required this.plan,
    required this.blocks,
    required this.tasks,
    required this.inboxTasks,
    required this.revisions,
    required this.preferences,
    this.undoneRevisionIds = const {},
  });

  final DayPlan plan;
  final List<TimeBlock> blocks;
  final List<Task> tasks;
  final List<Task> inboxTasks;
  final List<ScheduleRevision> revisions;
  final UserPreference preferences;
  final Set<String> undoneRevisionIds;

  List<Task> tasksForBlock(String blockId) {
    return tasks.where((task) => task.blockId == blockId).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}

class ParsedCapture {
  const ParsedCapture({
    required this.title,
    required this.estimatedMinutes,
    this.startTime,
    this.endTime,
    this.priority = 'medium',
    this.category,
    this.energyRequired,
    this.plannedDate,
    this.deadline,
    this.approximateTime = false,
    this.warnings = const [],
  });

  final String title;
  final int estimatedMinutes;
  final String? startTime;
  final String? endTime;
  final String priority;
  final String? category;
  final String? energyRequired;
  final DateTime? plannedDate;
  final DateTime? deadline;
  final bool approximateTime;
  final List<String> warnings;

  bool get hasSchedule => startTime != null && endTime != null;
}

class RhythmSummary {
  const RhythmSummary({
    required this.estimationSampleSize,
    required this.medianEstimateFactor,
    required this.deferredTaskCount,
    required this.successfulReweaves,
    required this.focusSessionCount,
    required this.totalFocusMinutes,
    required this.latestEnergyLevel,
    required this.insufficientDataWarning,
    this.estimateLowerQuartile,
    this.estimateUpperQuartile,
  });

  final int estimationSampleSize;
  final double? medianEstimateFactor;
  final int deferredTaskCount;
  final int successfulReweaves;
  final int focusSessionCount;
  final int totalFocusMinutes;
  final String? latestEnergyLevel;
  final String? insufficientDataWarning;
  final double? estimateLowerQuartile;
  final double? estimateUpperQuartile;
}

class LocalShareSummary {
  const LocalShareSummary({
    required this.tokenHash,
    required this.shareType,
    required this.expiresAt,
  });

  final String tokenHash;
  final String shareType;
  final DateTime expiresAt;
}

class LocalPlanningRepository {
  LocalPlanningRepository(
    this._database, {
    Uuid? uuid,
    DateTime Function()? now,
    this.planningDate,
  }) : _uuid = uuid ?? const Uuid(),
       _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final DateTime? planningDate;

  DateTime get _planningDay => _dateOnly(planningDate ?? _now());

  static const _preferencesId = 'local-user';

  final DayweftDatabase _database;
  final Uuid _uuid;

  Future<UserPreference> ensurePreferences() async {
    final existing = await (_database.select(
      _database.userPreferences,
    )..where((row) => row.id.equals(_preferencesId))).getSingleOrNull();
    if (existing != null) {
      return existing;
    }
    final now = _now();
    final companion = UserPreferencesCompanion.insert(
      id: _preferencesId,
      createdAt: now,
      updatedAt: now,
    );
    await _database
        .into(_database.userPreferences)
        .insert(companion, mode: InsertMode.insertOrIgnore);
    return (_database.select(
      _database.userPreferences,
    )..where((row) => row.id.equals(_preferencesId))).getSingle();
  }

  Future<void> completeOnboarding({
    required bool includeSampleData,
    OnboardingPreferences choices = const OnboardingPreferences(),
  }) async {
    choices.validate();
    final now = _now();
    await _database.transaction(() async {
      final preferences = await ensurePreferences();
      if (preferences.onboardingCompleted) {
        return;
      }
      await (_database.update(
        _database.userPreferences,
      )..where((row) => row.id.equals(preferences.id))).write(
        UserPreferencesCompanion(
          onboardingCompleted: const Value(true),
          sampleDataEnabled: Value(includeSampleData),
          workingPattern: Value(choices.workingPattern.name),
          calendarPreference: Value(choices.calendarPreference.name),
          wakeTime: Value(choices.wakeTime),
          windDownTime: Value(choices.windDownTime),
          workStartTime: Value(choices.workStartTime),
          workEndTime: Value(choices.workEndTime),
          planningStyle: Value(choices.planningStyle.name),
          updatedAt: Value(now),
        ),
      );
      if (includeSampleData) {
        await _installSampleData(_now());
      }
    });
  }

  Future<void> updatePlanningPreferences(OnboardingPreferences choices) async {
    choices.validate();
    final preferences = await ensurePreferences();
    await (_database.update(
      _database.userPreferences,
    )..where((row) => row.id.equals(preferences.id))).write(
      UserPreferencesCompanion(
        workingPattern: Value(choices.workingPattern.name),
        calendarPreference: Value(choices.calendarPreference.name),
        wakeTime: Value(choices.wakeTime),
        windDownTime: Value(choices.windDownTime),
        workStartTime: Value(choices.workStartTime),
        workEndTime: Value(choices.workEndTime),
        planningStyle: Value(choices.planningStyle.name),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> removeSampleData() async {
    final snapshot = await loadSelectedDay();
    final allSampleBlocks =
        await (_database.select(_database.timeBlocks)..where(
              (row) =>
                  row.sourceId.equals('sample-data') & row.deletedAt.isNull(),
            ))
            .get();
    final sampleBlocks = allSampleBlocks.map((block) => block.id).toSet();
    final now = _now();
    final allTasks = await (_database.select(
      _database.tasks,
    )..where((row) => row.deletedAt.isNull())).get();
    final affectedTasks = allTasks
        .where(
          (task) =>
              task.sourceId == 'sample-data' ||
              sampleBlocks.contains(task.blockId),
        )
        .toList();
    if (allSampleBlocks.isEmpty &&
        affectedTasks.isEmpty &&
        !snapshot.preferences.sampleDataEnabled) {
      return;
    }
    await _database.transaction(() async {
      for (final task in allTasks) {
        if (task.sourceId == 'sample-data') {
          await _writeTask(
            task.id,
            TasksCompanion(
              status: const Value('deleted'),
              deletedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
        } else if (sampleBlocks.contains(task.blockId)) {
          // Personal tasks survive removal of the sample container.
          await _writeTask(
            task.id,
            TasksCompanion(
              blockId: const Value(null),
              dayPlanId: const Value(null),
              status: Value(task.status == 'completed' ? 'completed' : 'inbox'),
              updatedAt: Value(now),
            ),
          );
        }
      }
      for (final block in allSampleBlocks) {
        await _writeBlock(
          block.id,
          TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
      await (_database.update(
        _database.userPreferences,
      )..where((row) => row.id.equals(_preferencesId))).write(
        UserPreferencesCompanion(
          sampleDataEnabled: const Value(false),
          updatedAt: Value(now),
        ),
      );
      await _recordRevision(snapshot.plan, 'Removed sample data.', {
        'undo': 'restore_samples',
        'tasks': affectedTasks.map(_taskPlacementJson).toList(),
        'blocks': allSampleBlocks.map(_blockWindowJson).toList(),
        'sampleDataEnabled': snapshot.preferences.sampleDataEnabled,
      });
    });
  }

  Future<void> updatePlanningBuffers({
    required int preferredBreakMinutes,
    required int contingencyMinutes,
    required int transitionMinutes,
  }) async {
    final preferences = await ensurePreferences();
    final now = _now();
    await (_database.update(
      _database.userPreferences,
    )..where((row) => row.id.equals(preferences.id))).write(
      UserPreferencesCompanion(
        preferredBreakMinutes: Value(preferredBreakMinutes.clamp(5, 120)),
        contingencyMinutes: Value(contingencyMinutes.clamp(0, 240)),
        transitionMinutes: Value(transitionMinutes.clamp(0, 60)),
        updatedAt: Value(now),
      ),
    );
  }

  Future<LocalDaySnapshot> loadToday() => loadDay(_now());

  Future<LocalDaySnapshot> loadSelectedDay() => loadDay(_planningDay);

  Future<LocalDaySnapshot> loadDay(DateTime day) async {
    final preferences = await ensurePreferences();
    final today = _dateOnly(day);
    final plan = await _database.transaction(
      () => _ensurePlan(today, preferences),
    );
    final blocks =
        await (_database.select(_database.timeBlocks)
              ..where(
                (row) => row.dayPlanId.equals(plan.id) & row.deletedAt.isNull(),
              )
              ..orderBy([
                (row) => OrderingTerm(expression: row.sortOrder),
                (row) => OrderingTerm(expression: row.startsAt),
              ]))
            .get();
    final tasks =
        await (_database.select(_database.tasks)
              ..where(
                (row) =>
                    row.dayPlanId.equals(plan.id) &
                    row.deletedAt.isNull() &
                    row.status.isNotValue('inbox'),
              )
              ..orderBy([(row) => OrderingTerm(expression: row.sortOrder)]))
            .get();
    final inboxTasks =
        await (_database.select(_database.tasks)
              ..where(
                (row) =>
                    (row.status.equals('inbox') |
                        (row.status.equals('completed') &
                            row.blockId.isNull())) &
                    row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]))
            .get();
    final revisions =
        await (_database.select(_database.scheduleRevisions)
              ..where((row) => row.dayPlanId.equals(plan.id))
              ..orderBy([
                (row) => OrderingTerm(
                  expression: row.revisionNumber,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    final undos =
        await (_database.select(_database.revisionUndos)..where(
              (row) =>
                  row.revisionId.isIn(revisions.map((revision) => revision.id)),
            ))
            .get();
    return LocalDaySnapshot(
      plan: plan,
      blocks: blocks,
      tasks: tasks,
      inboxTasks: inboxTasks,
      revisions: revisions,
      preferences: preferences,
      undoneRevisionIds: undos.map((undo) => undo.revisionId).toSet(),
    );
  }

  Future<void> addBlock({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
    String? category,
    String? sourceId,
    int travelBufferMinutes = 0,
    int preparationBufferMinutes = 0,
    int transitionBufferMinutes = 0,
    int recoveryBufferMinutes = 0,
  }) async {
    _validateBlock(title, startsAt, endsAt, blockType, [
      travelBufferMinutes,
      preparationBufferMinutes,
      transitionBufferMinutes,
      recoveryBufferMinutes,
    ]);
    final snapshot = await loadSelectedDay();
    if (_dateOnly(startsAt) != snapshot.plan.day) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'The block belongs to a different day. Return to that day before saving.',
      );
    }
    final now = _now();
    await _database.transaction(() async {
      final blockId = _uuid.v4();
      await _database
          .into(_database.timeBlocks)
          .insert(
            TimeBlocksCompanion.insert(
              id: blockId,
              dayPlanId: snapshot.plan.id,
              title: title,
              startsAt: startsAt,
              endsAt: endsAt,
              blockType: blockType,
              category: Value(category),
              sourceId: Value(sourceId),
              travelBufferMinutes: Value(travelBufferMinutes),
              preparationBufferMinutes: Value(preparationBufferMinutes),
              transitionBufferMinutes: Value(transitionBufferMinutes),
              recoveryBufferMinutes: Value(recoveryBufferMinutes),
              sortOrder: snapshot.blocks.length,
              syncState: SyncState.localOnly,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _recordRevision(
        snapshot.plan,
        'Created block "$title".',
        <String, Object?>{'undo': 'delete_block', 'blockId': blockId},
      );
    });
  }

  Future<void> deleteBlock(String blockId) async {
    final snapshot = await loadSelectedDay();
    final block = snapshot.blocks.firstWhere(
      (candidate) => candidate.id == blockId,
    );
    final blockTasks = snapshot.tasksForBlock(blockId);
    final now = _now();
    await _database.transaction(() async {
      await _writeBlock(
        blockId,
        TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      for (final task in blockTasks) {
        await _writeTask(
          task.id,
          TasksCompanion(
            status: Value(task.status == 'completed' ? 'completed' : 'inbox'),
            dayPlanId: const Value(null),
            blockId: const Value(null),
            updatedAt: Value(now),
          ),
        );
      }
      await _recordRevision(
        snapshot.plan,
        'Deleted block "${block.title}" and returned its tasks to Inbox.',
        <String, Object?>{
          'undo': 'restore_block',
          'block': _blockJson(block),
          'tasks': blockTasks.map(_taskPlacementJson).toList(),
        },
      );
    });
  }

  Future<void> updateBlock({
    required String blockId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
    int? expectedVersion,
    String? category,
    int? travelBufferMinutes,
    int? preparationBufferMinutes,
    int? transitionBufferMinutes,
    int? recoveryBufferMinutes,
  }) async {
    final snapshot = await loadSelectedDay();
    final block = snapshot.blocks.firstWhere(
      (candidate) => candidate.id == blockId,
    );
    if (expectedVersion != null && block.localVersion != expectedVersion) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'This block changed. Close the editor and review the latest version.',
      );
    }
    _validateBlock(title, startsAt, endsAt, blockType, [
      travelBufferMinutes ?? block.travelBufferMinutes,
      preparationBufferMinutes ?? block.preparationBufferMinutes,
      transitionBufferMinutes ?? block.transitionBufferMinutes,
      recoveryBufferMinutes ?? block.recoveryBufferMinutes,
    ]);
    final now = _now();
    await _database.transaction(() async {
      await _writeBlock(
        blockId,
        TimeBlocksCompanion(
          title: Value(title),
          startsAt: Value(startsAt),
          endsAt: Value(endsAt),
          blockType: Value(blockType),
          category: Value(_optionalText(category ?? block.category)),
          travelBufferMinutes: Value(
            travelBufferMinutes ?? block.travelBufferMinutes,
          ),
          preparationBufferMinutes: Value(
            preparationBufferMinutes ?? block.preparationBufferMinutes,
          ),
          transitionBufferMinutes: Value(
            transitionBufferMinutes ?? block.transitionBufferMinutes,
          ),
          recoveryBufferMinutes: Value(
            recoveryBufferMinutes ?? block.recoveryBufferMinutes,
          ),
          updatedAt: Value(now),
        ),
      );
      await _recordRevision(
        snapshot.plan,
        'Edited block "${block.title}".',
        <String, Object?>{
          'undo': 'update_block',
          'block': _blockJson(block),
          'after': _blockJson(
            await (_database.select(
              _database.timeBlocks,
            )..where((row) => row.id.equals(blockId))).getSingle(),
          ),
        },
      );
    });
  }

  Future<void> moveBlock({
    required String blockId,
    required int direction,
  }) async {
    final snapshot = await loadSelectedDay();
    final currentIndex = snapshot.blocks.indexWhere(
      (block) => block.id == blockId,
    );
    if (currentIndex < 0) {
      return;
    }
    await reorderBlockToIndex(
      blockId: blockId,
      newIndex: currentIndex + direction,
    );
  }

  Future<void> reorderBlockToIndex({
    required String blockId,
    required int newIndex,
  }) async {
    final snapshot = await loadSelectedDay();
    final blocks = [...snapshot.blocks];
    final currentIndex = blocks.indexWhere((block) => block.id == blockId);
    if (currentIndex < 0 || newIndex < 0 || newIndex >= blocks.length) {
      return;
    }
    if (currentIndex == newIndex) {
      return;
    }
    final previousOrder = blocks
        .map(
          (block) => <String, Object?>{
            'id': block.id,
            'sortOrder': block.sortOrder,
          },
        )
        .toList();
    final moved = blocks.removeAt(currentIndex);
    blocks.insert(newIndex, moved);
    final now = _now();
    await _database.transaction(() async {
      for (var index = 0; index < blocks.length; index += 1) {
        await _writeBlock(
          blocks[index].id,
          TimeBlocksCompanion(sortOrder: Value(index), updatedAt: Value(now)),
        );
      }
      await _recordRevision(
        snapshot.plan,
        'Reordered "${moved.title}".',
        <String, Object?>{
          'undo': 'reorder_blocks',
          'previousOrder': previousOrder,
        },
      );
    });
  }

  Future<void> addTaskToBlock({
    required String blockId,
    required String title,
    required int estimatedMinutes,
    String priority = 'medium',
    String? category,
    DateTime? deadline,
  }) async {
    _validateTask(title, estimatedMinutes, priority);
    final snapshot = await loadSelectedDay();
    _requireBlock(snapshot, blockId);
    final sortOrder = snapshot.tasksForBlock(blockId).length;
    final now = _now();
    final taskId = _uuid.v4();
    await _database.transaction(() async {
      await _database
          .into(_database.tasks)
          .insert(
            TasksCompanion.insert(
              id: taskId,
              dayPlanId: Value(snapshot.plan.id),
              blockId: Value(blockId),
              title: title,
              estimatedMinutes: estimatedMinutes,
              priority: priority,
              status: 'planned',
              category: Value(category),
              deadline: Value(deadline),
              sortOrder: sortOrder,
              syncState: SyncState.localOnly,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _recordRevision(
        snapshot.plan,
        'Added task "$title".',
        <String, Object?>{'undo': 'delete_task', 'taskId': taskId},
      );
    });
  }

  Future<void> addInboxTask({
    required String title,
    int estimatedMinutes = 30,
    String priority = 'medium',
    String? category,
    String? sourceId,
  }) => _saveCaptures([
    ParsedCapture(
      title: title,
      estimatedMinutes: estimatedMinutes,
      priority: priority,
      category: category,
    ),
  ], sourceId: sourceId);

  Future<void> updateTask({
    required String taskId,
    required int expectedVersion,
    required domain.TaskDetails details,
  }) async {
    final issue = details.validationMessage;
    if (issue != null) {
      throw PlanningFailure(PlanningFailureCode.invalidInput, issue);
    }
    final snapshot = await loadSelectedDay();
    await _database.transaction(() async {
      final task = await _requireTask(taskId, expectedVersion: expectedVersion);
      final allTasks = await (_database.select(
        _database.tasks,
      )..where((row) => row.deletedAt.isNull())).get();
      final dependencyIssue = domain.taskDependencyIssue(
        taskId,
        details.dependencyIds,
        {for (final row in allTasks) row.id: taskDependencyIds(row)},
      );
      if (dependencyIssue != null) {
        throw PlanningFailure(
          PlanningFailureCode.constraintViolation,
          dependencyIssue,
        );
      }
      await _writeTask(
        taskId,
        TasksCompanion(
          title: Value(details.title.trim()),
          estimatedMinutes: Value(details.estimatedMinutes),
          priority: Value(details.priority.name),
          category: Value(_optionalText(details.category)),
          notes: Value(_optionalText(details.notes)),
          deadline: Value(details.deadline),
          energyRequired: Value(details.energyRequired?.name),
          cognitiveLoad: Value(details.cognitiveLoad?.name),
          dependencyIdsJson: Value(jsonEncode(details.dependencyIds)),
          canSplit: Value(details.canSplit),
          minimumUsefulMinutes: Value(details.minimumUsefulMinutes),
        ),
      );
      final after = await _requireTask(taskId);
      await _recordRevision(snapshot.plan, 'Edited task "${task.title}".', {
        'undo': 'restore_task_details',
        'task': _taskJson(task),
        'after': _taskJson(after),
      });
    });
  }

  Future<List<Task>> loadTaskCandidates() =>
      (_database.select(_database.tasks)
            ..where((row) => row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm(expression: row.createdAt)]))
          .get();

  Future<String> deleteTask(
    String taskId, {
    required int expectedVersion,
  }) async {
    final snapshot = await loadSelectedDay();
    return _database.transaction(() async {
      final task = await _requireTask(taskId, expectedVersion: expectedVersion);
      final dependents =
          await (_database.select(_database.tasks)..where(
                (row) =>
                    row.deletedAt.isNull() & row.status.isNotValue('completed'),
              ))
              .get();
      if (dependents.any((row) => taskDependencyIds(row).contains(taskId))) {
        throw const PlanningFailure(
          PlanningFailureCode.constraintViolation,
          'Another task needs this predecessor. Remove that dependency before deleting it.',
        );
      }
      await _writeTask(
        taskId,
        TasksCompanion(
          status: const Value('deleted'),
          deletedAt: Value(_now()),
        ),
      );
      return _recordRevision(snapshot.plan, 'Deleted task "${task.title}".', {
        'undo': 'restore_task_details',
        'task': _taskJson(task),
      });
    });
  }

  Future<void> returnTaskToInbox(
    String taskId, {
    required int expectedVersion,
  }) async {
    final snapshot = await loadSelectedDay();
    await _database.transaction(() async {
      final task = await _requireTask(taskId, expectedVersion: expectedVersion);
      if (task.blockId == null && task.status == 'inbox') return;
      await _writeTask(
        taskId,
        TasksCompanion(
          dayPlanId: const Value(null),
          blockId: const Value(null),
          status: Value(task.status == 'completed' ? 'completed' : 'inbox'),
          sortOrder: Value(snapshot.inboxTasks.length),
        ),
      );
      await _recordRevision(
        snapshot.plan,
        'Returned "${task.title}" to Inbox.',
        {
          'undo': 'restore_tasks',
          'tasks': [_taskPlacementJson(task)],
        },
      );
    });
  }

  Future<Task> _requireTask(String id, {int? expectedVersion}) async {
    final task =
        await (_database.select(_database.tasks)
              ..where((row) => row.id.equals(id) & row.deletedAt.isNull()))
            .getSingleOrNull();
    if (task == null) {
      throw const PlanningFailure(
        PlanningFailureCode.notFound,
        'This task is no longer available.',
      );
    }
    if (expectedVersion != null && task.localVersion != expectedVersion) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'This task changed. Close the editor and review the latest version.',
      );
    }
    return task;
  }

  Future<void> _writeTask(String id, TasksCompanion changes) async {
    final current = await (_database.select(
      _database.tasks,
    )..where((row) => row.id.equals(id))).getSingle();
    await (_database.update(
      _database.tasks,
    )..where((row) => row.id.equals(id))).write(
      changes.copyWith(
        localVersion: Value(current.localVersion + 1),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> _writeBlock(String id, TimeBlocksCompanion changes) async {
    final current = await (_database.select(
      _database.timeBlocks,
    )..where((row) => row.id.equals(id))).getSingle();
    await (_database.update(
      _database.timeBlocks,
    )..where((row) => row.id.equals(id))).write(
      changes.copyWith(
        localVersion: Value(current.localVersion + 1),
        updatedAt: Value(_now()),
      ),
    );
  }

  String? _optionalText(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();

  Future<void> addInboxTasks(List<String> titles) => addConfirmedCaptures(
    titles
        .where((title) => title.trim().isNotEmpty)
        .map(
          (title) => ParsedCapture(title: title.trim(), estimatedMinutes: 30),
        )
        .toList(),
  );

  Future<void> addConfirmedCapture(ParsedCapture capture) =>
      addConfirmedCaptures([capture]);

  Future<void> addConfirmedCaptures(
    List<ParsedCapture> captures, {
    String? blockId,
  }) => _saveCaptures(captures, blockId: blockId);

  Future<void> _saveCaptures(
    List<ParsedCapture> captures, {
    String? sourceId,
    String? blockId,
  }) async {
    if (captures.isEmpty || captures.length > 200) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Confirm between 1 and 200 tasks at a time.',
      );
    }
    final time = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
    for (final capture in captures) {
      _validateTask(capture.title, capture.estimatedMinutes, capture.priority);
      if ((capture.energyRequired != null &&
              !['low', 'steady', 'high'].contains(capture.energyRequired)) ||
          [
            capture.startTime,
            capture.endTime,
          ].whereType<String>().any((value) => !time.hasMatch(value))) {
        throw const PlanningFailure(
          PlanningFailureCode.invalidInput,
          'Review the captured energy and time values.',
        );
      }
    }
    final snapshot = await loadSelectedDay();
    if (blockId != null) {
      _requireBlock(snapshot, blockId);
    }
    final now = _now();
    final ids = <String>[];
    await _database.transaction(() async {
      for (final capture in captures) {
        final id = _uuid.v4();
        ids.add(id);
        final date = capture.plannedDate;
        await _database
            .into(_database.tasks)
            .insert(
              TasksCompanion.insert(
                id: id,
                dayPlanId: Value(blockId == null ? null : snapshot.plan.id),
                blockId: Value(blockId),
                title: capture.title.trim(),
                estimatedMinutes: capture.estimatedMinutes,
                priority: capture.priority,
                status: blockId == null ? 'inbox' : 'planned',
                category: Value(capture.category),
                sourceId: Value(sourceId),
                energyRequired: Value(capture.energyRequired),
                requestedDay: Value(
                  date == null
                      ? null
                      : '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                ),
                requestedStartTime: Value(capture.startTime),
                requestedEndTime: Value(capture.endTime),
                approximateTime: Value(capture.approximateTime),
                deadline: Value(capture.deadline),
                sortOrder: snapshot.inboxTasks.length + ids.length - 1,
                syncState: SyncState.localOnly,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      await _recordRevision(snapshot.plan, 'Captured ${ids.length} task(s).', {
        'undo': 'delete_tasks',
        'taskIds': ids,
      });
    });
  }

  Future<void> moveInboxTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    final snapshot = await loadSelectedDay();
    _requireBlock(snapshot, blockId);
    final task = await _requireTask(taskId);
    final now = _now();
    await _database.transaction(() async {
      await _writeTask(
        taskId,
        TasksCompanion(
          dayPlanId: Value(snapshot.plan.id),
          blockId: Value(blockId),
          status: Value(task.status == 'completed' ? 'completed' : 'planned'),
          sortOrder: Value(snapshot.tasksForBlock(blockId).length),
          updatedAt: Value(now),
        ),
      );
      await _recordRevision(
        snapshot.plan,
        'Moved "${task.title}" from Inbox to Today Timeline.',
        <String, Object?>{
          'undo': 'restore_tasks',
          'tasks': [_taskPlacementJson(task)],
        },
      );
    });
  }

  Future<void> movePlannedTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    final snapshot = await loadSelectedDay();
    _requireBlock(snapshot, blockId);
    final task = snapshot.tasks.firstWhere(
      (candidate) => candidate.id == taskId,
    );
    final now = _now();
    await _database.transaction(() async {
      await _writeTask(
        taskId,
        TasksCompanion(
          blockId: Value(blockId),
          sortOrder: Value(snapshot.tasksForBlock(blockId).length),
          updatedAt: Value(now),
        ),
      );
      await _recordRevision(
        snapshot.plan,
        'Moved "${task.title}" between blocks.',
        <String, Object?>{
          'undo': 'restore_tasks',
          'tasks': [_taskPlacementJson(task)],
        },
      );
    });
  }

  Future<void> toggleTask(String taskId) async {
    final snapshot = await loadSelectedDay();
    final task = [
      ...snapshot.tasks,
      ...snapshot.inboxTasks,
    ].firstWhere((candidate) => candidate.id == taskId);
    final nextStatus = task.status == 'completed'
        ? (task.blockId == null ? 'inbox' : 'planned')
        : 'completed';
    final now = _now();
    await _database.transaction(() async {
      await _writeTask(
        taskId,
        TasksCompanion(status: Value(nextStatus), updatedAt: Value(now)),
      );
      await _recordRevision(
        snapshot.plan,
        nextStatus == 'completed' ? 'Completed a task.' : 'Reopened a task.',
        {
          'undo': 'restore_tasks',
          'tasks': [_taskPlacementJson(task)],
        },
      );
    });
    // Completion alone says nothing about actual duration.
  }

  Future<domain.TemplatePreview> previewTemplate(
    domain.DayTemplate template,
  ) async => _templatePreview(
    await loadSelectedDay(),
    await _resolveTemplate(template),
  );

  Future<domain.DayTemplate> _resolveTemplate(
    domain.DayTemplate template,
  ) async {
    if (!template.id.startsWith('user:')) return template;
    final stored = await CustomTemplateRepository(_database).get(template.id);
    if (stored.version != template.version) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'This template changed. Open a fresh preview before applying it.',
      );
    }
    return stored;
  }

  domain.TemplatePreview _templatePreview(
    LocalDaySnapshot snapshot,
    domain.DayTemplate template,
  ) {
    try {
      return domain.reconcileTemplate(
        template: template,
        planId: snapshot.plan.id,
        revision: snapshot.plan.revision,
        workingWindow: _workingWindow(snapshot.preferences, snapshot.plan.day),
        transition: Duration(minutes: snapshot.preferences.transitionMinutes),
        existing: [
          for (final block in snapshot.blocks)
            domain.TemplateReservation(
              sourceId: block.sourceId,
              window: domain.TimeWindow(
                start: block.startsAt,
                end: block.endsAt,
              ),
            ),
        ],
      );
    } on ArgumentError {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'This template has invalid blocks or times.',
      );
    }
  }

  Future<void> applyTemplate(domain.DayTemplate template) async =>
      applyTemplatePreview(await previewTemplate(template));

  Future<void> applyTemplatePreview(
    domain.TemplatePreview preview, {
    Set<int>? selectedIndices,
  }) async {
    await _database.transaction(() async {
      final snapshot = await loadSelectedDay();
      final current = _templatePreview(
        snapshot,
        await _resolveTemplate(preview.template),
      );
      if (current.planId != preview.planId ||
          current.baseRevision != preview.baseRevision ||
          _templateSignature(current) != _templateSignature(preview)) {
        throw const PlanningFailure(
          PlanningFailureCode.staleProposal,
          'The plan or planning preferences changed. Review a new template preview.',
        );
      }
      final chosen =
          selectedIndices ??
          preview.placements.map((item) => item.index).toSet();
      if (chosen.isEmpty ||
          chosen.any(
            (index) => !current.placements.any((item) => item.index == index),
          )) {
        throw const PlanningFailure(
          PlanningFailureCode.invalidInput,
          'Select at least one available block from the template preview.',
        );
      }
      final blockIds = <String>[];
      final now = _now();
      for (final placement in current.placements.where(
        (item) => chosen.contains(item.index),
      )) {
        final blockId = _uuid.v4();
        blockIds.add(blockId);
        await _database
            .into(_database.timeBlocks)
            .insert(
              TimeBlocksCompanion.insert(
                id: blockId,
                dayPlanId: snapshot.plan.id,
                title: placement.block.title,
                startsAt: placement.window.start,
                endsAt: placement.window.end,
                blockType: placement.block.blockType,
                category: Value(placement.block.category),
                sourceId: Value(placement.sourceId),
                travelBufferMinutes: Value(placement.block.travelBufferMinutes),
                preparationBufferMinutes: Value(
                  placement.block.preparationBufferMinutes,
                ),
                transitionBufferMinutes: Value(
                  placement.block.transitionBufferMinutes,
                ),
                recoveryBufferMinutes: Value(
                  placement.block.recoveryBufferMinutes,
                ),
                sortOrder: snapshot.blocks.length + blockIds.length - 1,
                syncState: SyncState.localOnly,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      await _recordRevision(
        snapshot.plan,
        'Applied ${preview.template.name} template.',
        {'undo': 'delete_blocks', 'blockIds': blockIds},
      );
    });
  }

  String _templateSignature(domain.TemplatePreview preview) => jsonEncode([
    for (final item in preview.placements)
      {
        'index': item.index,
        'title': item.block.title,
        'type': item.block.blockType,
        'category': item.block.category,
        'sourceId': item.sourceId,
        'buffers': [
          item.block.travelBufferMinutes,
          item.block.preparationBufferMinutes,
          item.block.transitionBufferMinutes,
          item.block.recoveryBufferMinutes,
        ],
        'start': item.window.start.toIso8601String(),
        'end': item.window.end.toIso8601String(),
      },
  ]);

  Future<String> exportLocalData() async {
    final snapshot = await loadSelectedDay();
    final export = <String, Object?>{
      'schemaVersion': 1,
      'product': 'Dayweft',
      'exportedAt': _now().toUtc().toIso8601String(),
      'preferences': _preferencesJson(snapshot.preferences),
      'plan': _planJson(snapshot.plan),
      'blocks': snapshot.blocks.map(_blockJson).toList(),
      'tasks': [
        ...snapshot.tasks,
        ...snapshot.inboxTasks,
      ].map(_taskJson).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(export);
  }

  DayImport previewLocalImport(String rawJson) {
    try {
      return DayImport.parse(rawJson);
    } on FormatException catch (error) {
      throw PlanningFailure(PlanningFailureCode.invalidInput, error.message);
    }
  }

  Future<void> importLocalData(String rawJson) async {
    final document = previewLocalImport(rawJson);
    final blocks = document.blocks;
    final tasks = document.tasks;
    final originalTaskIds = [for (final task in tasks) task['id']! as String];
    final taskIdMap = {for (final id in originalTaskIds) id: _uuid.v4()};
    final dependencies = {
      for (final task in tasks)
        task['id']!
            as String: (task['dependencyIds'] as List<Object?>? ?? const [])
            .cast<String>(),
    };
    final snapshot = await loadDay(document.day);
    final now = _now();
    final importedBlockIds = <String, String>{};
    final importedTaskIds = <String>[];

    await _database.transaction(() async {
      final previous = await _database
          .customSelect(
            'SELECT r.id FROM schedule_revisions r LEFT JOIN revision_undos u ON u.revision_id = r.id '
            "WHERE json_extract(r.reversible_change_set_json, '\$.importFingerprint') = ? AND u.id IS NULL LIMIT 1",
            variables: [Variable<String>(document.fingerprint)],
            readsFrom: {_database.scheduleRevisions, _database.revisionUndos},
          )
          .get();
      if (previous.isNotEmpty) {
        throw const PlanningFailure(
          PlanningFailureCode.invalidInput,
          'This day export has already been imported. Undo that import before importing it again.',
        );
      }
      for (final block in blocks) {
        _validateBlock(
          block['title'] as String? ?? 'Imported block',
          DateTime.parse(block['startsAt']! as String),
          DateTime.parse(block['endsAt']! as String),
          block['blockType'] as String? ?? 'flexible',
          [
            block['travelBufferMinutes'] as int? ?? 0,
            block['preparationBufferMinutes'] as int? ?? 0,
            block['transitionBufferMinutes'] as int? ?? 0,
            block['recoveryBufferMinutes'] as int? ?? 0,
          ],
        );
        final originalId = block['id'] as String? ?? _uuid.v4();
        final importedId = _uuid.v4();
        importedBlockIds[originalId] = importedId;
        await _database
            .into(_database.timeBlocks)
            .insert(
              TimeBlocksCompanion.insert(
                id: importedId,
                dayPlanId: snapshot.plan.id,
                title: (block['title'] as String?) ?? 'Imported block',
                startsAt:
                    DateTime.tryParse(block['startsAt'] as String? ?? '') ??
                    now,
                endsAt:
                    DateTime.tryParse(block['endsAt'] as String? ?? '') ??
                    now.add(const Duration(minutes: 30)),
                blockType: (block['blockType'] as String?) ?? 'flexible',
                category: Value(block['category'] as String?),
                sourceId: const Value('local-import'),
                travelBufferMinutes: Value(
                  (block['travelBufferMinutes'] as int?) ?? 0,
                ),
                preparationBufferMinutes: Value(
                  (block['preparationBufferMinutes'] as int?) ?? 0,
                ),
                transitionBufferMinutes: Value(
                  (block['transitionBufferMinutes'] as int?) ?? 0,
                ),
                recoveryBufferMinutes: Value(
                  (block['recoveryBufferMinutes'] as int?) ?? 0,
                ),
                sortOrder: snapshot.blocks.length + importedBlockIds.length,
                syncState: SyncState.localOnly,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }

      for (var index = 0; index < tasks.length; index++) {
        final task = tasks[index];
        final originalBlockId = task['blockId'] as String?;
        final importedBlockId = originalBlockId == null
            ? null
            : importedBlockIds[originalBlockId];
        final importedTaskId = taskIdMap[originalTaskIds[index]]!;
        importedTaskIds.add(importedTaskId);
        final importedStatus = task['status']! as String;
        await _database
            .into(_database.tasks)
            .insert(
              TasksCompanion.insert(
                id: importedTaskId,
                dayPlanId: Value(
                  importedBlockId == null &&
                          task['dayPlanId'] == null &&
                          importedStatus != 'deferred'
                      ? null
                      : snapshot.plan.id,
                ),
                blockId: Value(importedBlockId),
                title: (task['title'] as String?) ?? 'Imported task',
                notes: Value(task['notes'] as String?),
                energyRequired: Value(task['energyRequired'] as String?),
                cognitiveLoad: Value(task['cognitiveLoad'] as String?),
                dependencyIdsJson: Value(
                  jsonEncode(
                    dependencies[originalTaskIds[index]]!
                        .map((id) => taskIdMap[id]!)
                        .toList(),
                  ),
                ),
                requestedDay: Value(task['requestedDay'] as String?),
                requestedStartTime: Value(
                  task['requestedStartTime'] as String?,
                ),
                requestedEndTime: Value(task['requestedEndTime'] as String?),
                approximateTime: Value(
                  task['approximateTime'] as bool? ?? false,
                ),
                estimatedMinutes: (task['estimatedMinutes'] as int?) ?? 30,
                actualMinutes: Value(task['actualMinutes'] as int?),
                priority: (task['priority'] as String?) ?? 'medium',
                category: Value(task['category'] as String?),
                status: importedStatus,
                sourceId: const Value('local-import'),
                deadline: Value(
                  DateTime.tryParse(task['deadline'] as String? ?? ''),
                ),
                canSplit: Value((task['canSplit'] as bool?) ?? false),
                minimumUsefulMinutes: Value(
                  (task['minimumUsefulMinutes'] as int?) ?? 15,
                ),
                sortOrder:
                    (task['sortOrder'] as int?) ?? importedTaskIds.length,
                syncState: SyncState.localOnly,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }

      await _recordRevision(
        snapshot.plan,
        'Imported local Dayweft data.',
        <String, Object?>{
          'undo': 'delete_import',
          'importFingerprint': document.fingerprint,
          'blockIds': importedBlockIds.values.toList(),
          'taskIds': importedTaskIds,
        },
      );
    });
  }

  Future<List<RealityObservation>> realityCheckToday() async {
    final snapshot = await loadSelectedDay();
    final engine = _engineFor(snapshot);
    final plan = _toDomainPlan(snapshot);
    return Isolate.run(() => engine.realityCheck(plan));
  }

  Future<ReweaveResult> reweaveToday({
    required domain.DisruptionType disruptionType,
    int? unavailableMinutes,
  }) async {
    if (unavailableMinutes != null &&
        (unavailableMinutes < 0 || unavailableMinutes > 1440)) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Enter between 0 and 1440 unavailable minutes.',
      );
    }
    final snapshot = await loadSelectedDay();
    final engine = _engineFor(snapshot);
    final plan = _toDomainPlan(snapshot);
    final disruption = domain.Disruption(
      id: _uuid.v4(),
      type: disruptionType,
      reportedAt: _now(),
      duration: unavailableMinutes == null
          ? null
          : Duration(minutes: unavailableMinutes),
    );
    return Isolate.run(
      () => engine.reweave(plan: plan, disruption: disruption),
    );
  }

  Future<void> applyReweaveAlternative(ReweaveAlternative alternative) async {
    final snapshot = await loadSelectedDay();
    if (alternative.preview.id != snapshot.plan.id ||
        alternative.preview.revision != snapshot.plan.revision) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'The plan changed. Generate and review a new alternative.',
      );
    }
    final original = _toDomainPlan(snapshot);
    final previewBlocks = {
      for (final block in alternative.preview.blocks) block.id: block,
    };
    final originalTasks = original.tasksById;
    final deferredIds = alternative.deferredTaskIds.toSet();
    void invalidProposal() => throw const PlanningFailure(
      PlanningFailureCode.constraintViolation,
      'The proposal does not match the stored plan. Generate a new recovery preview.',
    );
    if (previewBlocks.length != snapshot.blocks.length ||
        alternative.preview.blocks.length != snapshot.blocks.length ||
        snapshot.blocks.any((block) => !previewBlocks.containsKey(block.id)) ||
        alternative.preview.tasks.length != originalTasks.length ||
        alternative.preview.tasks.map((task) => task.id).toSet().length !=
            originalTasks.length ||
        deferredIds.length != alternative.deferredTaskIds.length) {
      invalidProposal();
    }
    for (final task in alternative.preview.tasks) {
      final before = originalTasks[task.id];
      if (before == null ||
          task.title != before.title ||
          task.estimatedDuration != before.estimatedDuration ||
          task.actualDuration != before.actualDuration ||
          task.priority != before.priority ||
          task.deadline != before.deadline ||
          task.canSplit != before.canSplit ||
          task.minimumUsefulDuration != before.minimumUsefulDuration ||
          jsonEncode(task.dependencyIds) != jsonEncode(before.dependencyIds) ||
          task.status !=
              (deferredIds.contains(task.id)
                  ? domain.TaskStatus.deferred
                  : before.status)) {
        invalidProposal();
      }
    }
    for (final id in deferredIds) {
      final task = originalTasks[id];
      if (task == null ||
          task.status != domain.TaskStatus.planned ||
          task.deadline != null ||
          original.blocks.any(
            (block) =>
                block.type == domain.BlockType.fixed &&
                block.taskIds.contains(id),
          )) {
        invalidProposal();
      }
    }
    for (final before in original.blocks) {
      final after = previewBlocks[before.id]!;
      final expectedTasks =
          before.taskIds.where((id) => !deferredIds.contains(id)).toList()
            ..sort();
      final proposedTasks = [...after.taskIds]..sort();
      if (after.type != before.type ||
          after.reservedBufferDuration != before.reservedBufferDuration ||
          jsonEncode(expectedTasks) != jsonEncode(proposedTasks)) {
        invalidProposal();
      }
    }
    for (final change in alternative.changes.where(
      (change) => change.after != null,
    )) {
      final after = previewBlocks[change.entityId];
      if (after == null ||
          after.window.start != change.after!.start ||
          after.window.end != change.after!.end) {
        invalidProposal();
      }
    }
    for (final fixed in snapshot.blocks.where(
      (block) => block.blockType == 'fixed',
    )) {
      final preview = alternative.preview.blocks
          .where((block) => block.id == fixed.id)
          .firstOrNull;
      if (preview == null ||
          preview.window.start != fixed.startsAt ||
          preview.window.end != fixed.endsAt) {
        throw const PlanningFailure(
          PlanningFailureCode.constraintViolation,
          'A fixed commitment cannot change through this suggestion.',
        );
      }
    }
    final hardIssues = _engineFor(snapshot)
        .realityCheck(alternative.preview)
        .where((issue) => issue.isHardConstraint);
    if (hardIssues.isNotEmpty || alternative.splitTaskIds.isNotEmpty) {
      throw const PlanningFailure(
        PlanningFailureCode.constraintViolation,
        'This alternative still has unresolved constraints. Review the work before applying it.',
      );
    }
    final taskIds = alternative.deferredTaskIds.toSet();
    final affectedTasks = snapshot.tasks
        .where((task) => taskIds.contains(task.id))
        .toList();
    final movedBlocks = snapshot.blocks
        .where(
          (block) =>
              previewBlocks[block.id]!.window.start != block.startsAt ||
              previewBlocks[block.id]!.window.end != block.endsAt,
        )
        .toList();
    final now = _now();
    await _database.transaction(() async {
      for (final block in movedBlocks) {
        final after = previewBlocks[block.id]!.window;
        await _writeBlock(
          block.id,
          TimeBlocksCompanion(
            startsAt: Value(after.start),
            endsAt: Value(after.end),
            updatedAt: Value(now),
          ),
        );
      }
      for (final task in affectedTasks) {
        await _writeTask(
          task.id,
          TasksCompanion(
            blockId: const Value(null),
            status: const Value('deferred'),
            updatedAt: Value(now),
          ),
        );
      }
      await _recordRevision(
        snapshot.plan,
        'Applied ${_strategyLabel(alternative.strategy)}.',
        <String, Object?>{
          'undo': 'restore_reweave',
          'tasks': affectedTasks.map(_taskPlacementJson).toList(),
          'blocks': movedBlocks.map(_blockWindowJson).toList(),
        },
      );
    });
  }

  Future<RhythmSummary> loadRhythmSummary() async {
    final snapshot = await loadSelectedDay();
    final estimationRecords =
        await (_database.select(_database.estimationRecords)..where(
              (row) =>
                  row.deletedAt.isNull() &
                  row.excluded.equals(false) &
                  row.measurementSource.isNotValue('legacy_unknown'),
            ))
            .get();
    final focusSessions = await (_database.select(
      _database.focusSessions,
    )..where((row) => row.status.equals('completed'))).get();
    final energy =
        await (_database.select(_database.energyCheckIns)
              ..where((row) => row.deletedAt.isNull())
              ..orderBy([
                (row) => OrderingTerm(
                  expression: row.checkedAt,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();
    final calibration = const domain.EstimationCalibration().summarise(
      estimationRecords.map(
        (record) => domain.DurationSample(
          estimatedMinutes: record.estimatedMinutes,
          actualMinutes: record.actualMinutes,
          category: record.category,
          timeOfDay: record.timeOfDay,
          dayOfWeek: record.dayOfWeek,
          interruptionCount: record.interruptionCount,
          wasSplit: record.wasSplit,
        ),
      ),
    );

    return RhythmSummary(
      estimationSampleSize: calibration.sampleSize,
      medianEstimateFactor: calibration.factor,
      estimateLowerQuartile: calibration.lowerQuartile,
      estimateUpperQuartile: calibration.upperQuartile,
      deferredTaskCount: snapshot.tasks
          .where((task) => task.status == 'deferred')
          .length,
      successfulReweaves: snapshot.revisions
          .where((revision) => revision.reason.startsWith('Applied '))
          .length,
      focusSessionCount: focusSessions.length,
      totalFocusMinutes: focusSessions.fold<int>(
        0,
        (total, session) => total + (session.actualMinutes ?? 0),
      ),
      latestEnergyLevel: snapshot.preferences.energyEnabled
          ? energy?.level
          : null,
      insufficientDataWarning: !calibration.hasEnoughEvidence
          ? 'At least ${calibration.minimumSamples} measured records are needed before showing a personal estimation factor.'
          : null,
    );
  }

  Future<void> recordEnergyCheckIn(String level) async {
    if (!['low', 'steady', 'high'].contains(level)) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Choose low, steady or high.',
      );
    }
    if (!(await ensurePreferences()).energyEnabled) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Enable energy check-ins before recording one.',
      );
    }
    final now = _now();
    await _database
        .into(_database.energyCheckIns)
        .insert(
          EnergyCheckInsCompanion.insert(
            id: _uuid.v4(),
            level: level,
            checkedAt: now,
          ),
        );
  }

  Future<void> deleteLearningHistory() async {
    await _database.transaction(() async {
      await _database.delete(_database.estimationRecords).go();
      await _database.delete(_database.energyCheckIns).go();
      await _redactHistoricalMeasurements();
      await _database
          .update(_database.focusSessionStates)
          .write(
            const FocusSessionStatesCompanion(estimateAtStart: Value(null)),
          );
    });
  }

  Future<void> _redactHistoricalMeasurements({String? id}) async {
    final revisions = await _database.select(_database.scheduleRevisions).get();
    for (final revision in revisions) {
      final payload =
          jsonDecode(revision.reversibleChangeSetJson) as Map<String, Object?>;
      final measurement = payload['previousMeasurement'];
      if (payload['undo'] == 'restore_focus_task' &&
          measurement is Map<String, Object?> &&
          (id == null || measurement['id'] == id)) {
        payload['previousMeasurement'] = null;
        await (_database.update(
          _database.scheduleRevisions,
        )..where((row) => row.id.equals(revision.id))).write(
          ScheduleRevisionsCompanion(
            reversibleChangeSetJson: Value(jsonEncode(payload)),
          ),
        );
      }
    }
  }

  Future<void> setEnergyEnabled(bool enabled) async {
    final preferences = await ensurePreferences();
    await (_database.update(
      _database.userPreferences,
    )..where((row) => row.id.equals(preferences.id))).write(
      UserPreferencesCompanion(
        energyEnabled: Value(enabled),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<List<EstimationRecord>> loadEstimationRecords() =>
      (_database.select(_database.estimationRecords)
            ..where((row) => row.deletedAt.isNull())
            ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
          .get();

  Future<void> excludeEstimationRecord(
    String id, {
    required bool excluded,
  }) async {
    await (_database.update(_database.estimationRecords)
          ..where((row) => row.id.equals(id)))
        .write(EstimationRecordsCompanion(excluded: Value(excluded)));
  }

  Future<void> deleteEstimationRecord(String id) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.estimationRecords,
      )..where((row) => row.id.equals(id))).go();
      await _redactHistoricalMeasurements(id: id);
    });
  }

  Future<void> completeFocusSession({
    required String title,
    required int plannedMinutes,
    required int actualMinutes,
    required int interruptionCount,
  }) async {
    final now = _now();
    await _database
        .into(_database.focusSessions)
        .insert(
          FocusSessionsCompanion.insert(
            id: _uuid.v4(),
            title: title,
            startedAt: now.subtract(Duration(minutes: actualMinutes)),
            endedAt: Value(now),
            plannedMinutes: plannedMinutes,
            actualMinutes: Value(actualMinutes),
            interruptionCount: Value(interruptionCount),
            status: 'completed',
            createdAt: now,
          ),
        );
  }

  Future<LocalShareSummary> createLocalAvailabilityShare() async {
    final snapshot = await loadSelectedDay();
    final token = _uuid.v4();
    final tokenHash = token.replaceAll('-', '');
    final expiresAt = _now().add(const Duration(days: 7));
    final payload = <String, Object?>{
      'day': snapshot.plan.day.toIso8601String(),
      'availability': snapshot.blocks
          .map(
            (block) => <String, Object?>{
              'startsAt': block.startsAt.toIso8601String(),
              'endsAt': block.endsAt.toIso8601String(),
              'busy': block.blockType == 'fixed',
            },
          )
          .toList(),
    };
    await _database
        .into(_database.shareLinks)
        .insert(
          ShareLinksCompanion.insert(
            id: _uuid.v4(),
            tokenHash: tokenHash,
            shareType: 'availability',
            payloadJson: jsonEncode(payload),
            expiresAt: expiresAt,
            createdAt: _now(),
          ),
        );
    return LocalShareSummary(
      tokenHash: tokenHash,
      shareType: 'availability',
      expiresAt: expiresAt,
    );
  }

  Future<void> revokeLocalShares() async {
    final now = _now();
    await _database
        .update(_database.shareLinks)
        .write(ShareLinksCompanion(revokedAt: Value(now)));
  }

  Future<void> markCalendarPermission(String permissionState) async {
    final now = _now();
    await _database
        .into(_database.calendarConnections)
        .insertOnConflictUpdate(
          CalendarConnectionsCompanion.insert(
            id: 'device-calendar',
            platform: 'device',
            permissionState: permissionState,
            updatedAt: now,
          ),
        );
  }

  Future<void> recordTaskActualDuration(
    String taskId, {
    required int actualMinutes,
    int interruptionCount = 0,
    bool wasSplit = false,
  }) async {
    if (actualMinutes <= 0 || interruptionCount < 0) {
      throw const FormatException(
        'Enter a positive actual duration and a valid interruption count.',
      );
    }
    final task =
        await (_database.select(_database.tasks)
              ..where((row) => row.id.equals(taskId) & row.deletedAt.isNull()))
            .getSingle();
    if (task.status != 'completed') {
      throw const FormatException(
        'Complete the task before recording its actual duration.',
      );
    }
    final now = _now();
    await _database.transaction(() async {
      final existing = await (_database.select(
        _database.estimationRecords,
      )..where((row) => row.taskId.equals(task.id))).get();
      await _writeTask(
        task.id,
        TasksCompanion(
          actualMinutes: Value(actualMinutes),
          updatedAt: Value(now),
        ),
      );
      if (existing.isNotEmpty) {
        // Editing a measurement does not manufacture another independent sample.
        await (_database.update(
          _database.estimationRecords,
        )..where((row) => row.id.equals(existing.first.id))).write(
          EstimationRecordsCompanion(
            actualMinutes: Value(actualMinutes),
            interruptionCount: Value(interruptionCount),
            wasSplit: Value(wasSplit),
            measurementSource: const Value('manual'),
            deletedAt: const Value(null),
          ),
        );
        return;
      }
      await _database
          .into(_database.estimationRecords)
          .insert(
            EstimationRecordsCompanion.insert(
              id: _uuid.v4(),
              taskId: Value(task.id),
              category: Value(task.category),
              estimatedMinutes: task.estimatedMinutes,
              actualMinutes: actualMinutes,
              measurementSource: const Value('manual'),
              interruptionCount: Value(interruptionCount),
              wasSplit: Value(wasSplit),
              timeOfDay: _timeBucket(now),
              dayOfWeek: now.weekday,
              createdAt: now,
            ),
          );
    });
  }

  Future<bool> undoLastRevision({String? expectedRevisionId}) async {
    final snapshot = await loadSelectedDay();
    final revision = snapshot.revisions
        .where((revision) => !snapshot.undoneRevisionIds.contains(revision.id))
        .firstOrNull;
    if (revision == null) {
      return false;
    }
    if (expectedRevisionId != null && revision.id != expectedRevisionId) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'The plan changed again. Review revision history before undoing.',
      );
    }
    final payload =
        jsonDecode(revision.reversibleChangeSetJson) as Map<String, Object?>;
    final undo = payload['undo'];
    final now = _now();

    await _database.transaction(() async {
      await _assertPlanVersion(snapshot.plan);
      if (undo == 'restore_focus_task') {
        final id = payload['taskId']! as String;
        await _writeTask(
          id,
          TasksCompanion(
            status: Value(payload['status']! as String),
            actualMinutes: Value(payload['actualMinutes'] as int?),
          ),
        );
        await (_database.delete(
          _database.estimationRecords,
        )..where((row) => row.id.equals('focus:$id'))).go();
        final previous = payload['previousMeasurement'];
        if (previous is Map<String, Object?>) {
          await _database
              .into(_database.estimationRecords)
              .insertOnConflictUpdate(
                EstimationRecord.fromJson(previous).toCompanion(true),
              );
        }
      } else if (undo == 'restore_task_details') {
        final task = payload['task']! as Map<String, Object?>;
        final dependencies = (task['dependencyIds'] as List<Object?>? ?? [])
            .cast<String>();
        await _writeTask(
          task['id']! as String,
          TasksCompanion(
            title: Value(task['title']! as String),
            notes: Value(task['notes'] as String?),
            estimatedMinutes: Value(task['estimatedMinutes']! as int),
            priority: Value(task['priority']! as String),
            category: Value(task['category'] as String?),
            energyRequired: Value(task['energyRequired'] as String?),
            cognitiveLoad: Value(task['cognitiveLoad'] as String?),
            dependencyIdsJson: Value(jsonEncode(dependencies)),
            deadline: Value(
              task['deadline'] == null
                  ? null
                  : DateTime.parse(task['deadline']! as String),
            ),
            canSplit: Value(task['canSplit']! as bool),
            minimumUsefulMinutes: Value(task['minimumUsefulMinutes']! as int),
            status: Value(task['status']! as String),
            deletedAt: const Value(null),
          ),
        );
      } else if (undo == 'delete_block') {
        final blockId = payload['blockId'] as String;
        await _writeBlock(
          blockId,
          TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      } else if (undo == 'delete_blocks') {
        final blockIds = (payload['blockIds'] as List<Object?>).cast<String>();
        for (final blockId in blockIds) {
          await _writeBlock(
            blockId,
            TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
          );
        }
      } else if (undo == 'delete_task' || undo == 'delete_tasks') {
        final taskIds = undo == 'delete_task'
            ? [payload['taskId']! as String]
            : (payload['taskIds']! as List<Object?>).cast<String>();
        for (final taskId in taskIds) {
          await _writeTask(
            taskId,
            TasksCompanion(
              status: const Value('deleted'),
              deletedAt: Value(now),
              updatedAt: Value(now),
            ),
          );
        }
      } else if (undo == 'move_task_to_inbox') {
        final taskId = payload['taskId'] as String;
        await _writeTask(
          taskId,
          TasksCompanion(
            dayPlanId: const Value(null),
            blockId: const Value(null),
            status: const Value('inbox'),
            updatedAt: Value(now),
          ),
        );
      } else if (undo == 'restore_block') {
        final block = payload['block'] as Map<String, Object?>;
        await _writeBlock(
          block['id']! as String,
          TimeBlocksCompanion(
            deletedAt: const Value(null),
            updatedAt: Value(now),
          ),
        );
        final tasks = (payload['tasks'] as List<Object?>? ?? const [])
            .whereType<Map<String, Object?>>();
        for (final task in tasks) {
          await _writeTask(
            task['id']! as String,
            TasksCompanion(
              dayPlanId: Value(task['dayPlanId'] as String?),
              blockId: Value(task['blockId'] as String?),
              status: Value(task['status']! as String),
              sortOrder: Value(task['sortOrder']! as int),
              updatedAt: Value(now),
            ),
          );
        }
      } else if (undo == 'update_block') {
        final block = payload['block'] as Map<String, Object?>;
        await _writeBlock(
          block['id']! as String,
          TimeBlocksCompanion(
            title: Value(block['title']! as String),
            startsAt: Value(DateTime.parse(block['startsAt']! as String)),
            endsAt: Value(DateTime.parse(block['endsAt']! as String)),
            blockType: Value(block['blockType']! as String),
            category: Value(block['category'] as String?),
            travelBufferMinutes: Value(
              block['travelBufferMinutes'] as int? ?? 0,
            ),
            preparationBufferMinutes: Value(
              block['preparationBufferMinutes'] as int? ?? 0,
            ),
            transitionBufferMinutes: Value(
              block['transitionBufferMinutes'] as int? ?? 0,
            ),
            recoveryBufferMinutes: Value(
              block['recoveryBufferMinutes'] as int? ?? 0,
            ),
            updatedAt: Value(now),
          ),
        );
      } else if (undo == 'move_task_to_block') {
        final taskId = payload['taskId'] as String;
        final blockId = payload['blockId'] as String?;
        await _writeTask(
          taskId,
          TasksCompanion(blockId: Value(blockId), updatedAt: Value(now)),
        );
      } else if (undo == 'reorder_blocks') {
        final previousOrder = (payload['previousOrder'] as List<Object?>)
            .whereType<Map<String, Object?>>()
            .toList();
        for (final block in previousOrder) {
          await _writeBlock(
            block['id']! as String,
            TimeBlocksCompanion(
              sortOrder: Value(block['sortOrder']! as int),
              updatedAt: Value(now),
            ),
          );
        }
      } else if (undo == 'delete_import') {
        final blockIds = (payload['blockIds'] as List<Object?>).cast<String>();
        final taskIds = (payload['taskIds'] as List<Object?>).cast<String>();
        for (final taskId in taskIds) {
          await _writeTask(
            taskId,
            TasksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
          );
        }
        for (final blockId in blockIds) {
          await _writeBlock(
            blockId,
            TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
          );
        }
      } else if (undo == 'restore_tasks' ||
          undo == 'restore_reweave' ||
          undo == 'restore_samples') {
        final tasks = (payload['tasks'] as List<Object?>)
            .whereType<Map<String, Object?>>()
            .toList();
        for (final task in tasks) {
          await _writeTask(
            task['id']! as String,
            TasksCompanion(
              dayPlanId: Value(task['dayPlanId'] as String?),
              blockId: Value(task['blockId'] as String?),
              status: Value(task['status']! as String),
              sortOrder: Value(task['sortOrder']! as int),
              deletedAt: const Value(null),
              updatedAt: Value(now),
            ),
          );
        }
        final blocks =
            (payload['blocks'] as List<Object?>? ?? const <Object?>[])
                .whereType<Map<String, Object?>>()
                .toList();
        for (final block in blocks) {
          await _writeBlock(
            block['id']! as String,
            TimeBlocksCompanion(
              startsAt: Value(DateTime.parse(block['startsAt']! as String)),
              endsAt: Value(DateTime.parse(block['endsAt']! as String)),
              deletedAt: const Value(null),
              updatedAt: Value(now),
            ),
          );
        }
        if (undo == 'restore_samples') {
          await (_database.update(
            _database.userPreferences,
          )..where((row) => row.id.equals(_preferencesId))).write(
            UserPreferencesCompanion(
              sampleDataEnabled: Value(payload['sampleDataEnabled']! as bool),
              updatedAt: Value(now),
            ),
          );
        }
      }
      await _database
          .into(_database.revisionUndos)
          .insert(
            RevisionUndosCompanion.insert(
              id: _uuid.v4(),
              revisionId: revision.id,
              undoneAt: now,
            ),
          );
      await (_database.update(
        _database.dayPlans,
      )..where((row) => row.id.equals(snapshot.plan.id))).write(
        DayPlansCompanion(
          revision: Value(snapshot.plan.revision + 1),
          localVersion: Value(snapshot.plan.localVersion + 1),
          updatedAt: Value(now),
        ),
      );
    });
    return true;
  }

  ParsedCapture parseCapture(String input) {
    final parsed = const domain.LocalCaptureParser().parse(
      input,
      reference: _now(),
    );
    return ParsedCapture(
      title: parsed.title,
      estimatedMinutes: parsed.estimatedMinutes,
      priority: parsed.priority.name,
      category: parsed.category,
      energyRequired: parsed.energy?.name,
      plannedDate: parsed.day,
      deadline: parsed.deadline,
      startTime: parsed.startTime,
      endTime: parsed.endTime,
      approximateTime: parsed.approximate,
      warnings: parsed.warnings,
    );
  }

  Future<DayPlan> _ensurePlan(DateTime day, UserPreference preferences) async {
    final existing = await (_database.select(
      _database.dayPlans,
    )..where((row) => row.day.equals(day))).getSingleOrNull();
    if (existing != null) {
      return existing;
    }
    final now = _now();
    final planId = _uuid.v4();
    await _database
        .into(_database.dayPlans)
        .insert(
          DayPlansCompanion.insert(
            id: planId,
            day: day,
            timeZone: _now().timeZoneName,
            syncState: SyncState.localOnly,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_database.select(
      _database.dayPlans,
    )..where((row) => row.id.equals(planId))).getSingle();
  }

  Future<void> _installSampleData(DateTime date) async {
    await addInboxTask(
      title: 'Review the Dayweft sample plan',
      estimatedMinutes: 20,
      sourceId: 'sample-data',
    );
    await addBlock(
      title: 'Focused work',
      startsAt: _timeOnToday('10:00'),
      endsAt: _timeOnToday('11:30'),
      blockType: 'flexible',
      category: 'work',
      sourceId: 'sample-data',
    );
  }

  Future<String> _recordRevision(
    DayPlan plan,
    String reason,
    Map<String, Object?> reversibleChangeSet,
  ) async {
    await _assertPlanVersion(plan);
    final now = _now();
    final nextRevision = plan.revision + 1;
    final revisionId = _uuid.v4();
    await _database
        .into(_database.scheduleRevisions)
        .insert(
          ScheduleRevisionsCompanion.insert(
            id: revisionId,
            dayPlanId: plan.id,
            revisionNumber: nextRevision,
            reason: reason,
            reversibleChangeSetJson: jsonEncode(reversibleChangeSet),
            createdAt: now,
          ),
        );
    await (_database.update(
      _database.dayPlans,
    )..where((row) => row.id.equals(plan.id))).write(
      DayPlansCompanion(
        revision: Value(nextRevision),
        localVersion: Value(plan.localVersion + 1),
        updatedAt: Value(now),
      ),
    );
    return revisionId;
  }

  Future<void> _assertPlanVersion(DayPlan expected) async {
    final current = await (_database.select(
      _database.dayPlans,
    )..where((row) => row.id.equals(expected.id))).getSingle();
    if (current.revision != expected.revision) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'The plan changed. Refresh and review the change again.',
      );
    }
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  void _validateBlock(
    String title,
    DateTime start,
    DateTime end,
    String type,
    List<int> buffers,
  ) {
    if (title.trim().isEmpty ||
        title.length > 500 ||
        !end.isAfter(start) ||
        !['fixed', 'flexible', 'optional'].contains(type) ||
        buffers.any((value) => value < 0 || value > 1440) ||
        buffers.fold<int>(0, (total, value) => total + value) >
            end.difference(start).inMinutes) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Use a title, a positive duration and valid block settings.',
      );
    }
  }

  void _validateTask(String title, int minutes, String priority) {
    if (title.trim().isEmpty ||
        minutes <= 0 ||
        !['low', 'medium', 'high', 'essential'].contains(priority)) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Use a task title, a positive estimate and a valid priority.',
      );
    }
  }

  void _requireBlock(LocalDaySnapshot snapshot, String id) {
    if (!snapshot.blocks.any((block) => block.id == id)) {
      throw const PlanningFailure(
        PlanningFailureCode.notFound,
        'This block is no longer available.',
      );
    }
  }

  DateTime _timeOnToday(String value) {
    final parts = value.split(':').map(int.parse).toList();
    final day = _planningDay;
    return DateTime(day.year, day.month, day.day, parts[0], parts[1]);
  }

  String _timeBucket(DateTime value) {
    if (value.hour < 12) {
      return 'morning';
    }
    if (value.hour < 17) {
      return 'afternoon';
    }
    return 'evening';
  }

  Map<String, Object?> _blockJson(TimeBlock block) {
    return <String, Object?>{
      'id': block.id,
      'title': block.title,
      'startsAt': block.startsAt.toIso8601String(),
      'endsAt': block.endsAt.toIso8601String(),
      'blockType': block.blockType,
      'category': block.category,
      'sourceId': block.sourceId,
      'travelBufferMinutes': block.travelBufferMinutes,
      'preparationBufferMinutes': block.preparationBufferMinutes,
      'transitionBufferMinutes': block.transitionBufferMinutes,
      'recoveryBufferMinutes': block.recoveryBufferMinutes,
      'sortOrder': block.sortOrder,
    };
  }

  Map<String, Object?> _preferencesJson(UserPreference preferences) {
    return <String, Object?>{
      'wakeTime': preferences.wakeTime,
      'windDownTime': preferences.windDownTime,
      'workStartTime': preferences.workStartTime,
      'workEndTime': preferences.workEndTime,
      'planningStyle': preferences.planningStyle,
      'preferredBreakMinutes': preferences.preferredBreakMinutes,
      'contingencyMinutes': preferences.contingencyMinutes,
      'transitionMinutes': preferences.transitionMinutes,
    };
  }

  Map<String, Object?> _planJson(DayPlan plan) {
    return <String, Object?>{
      'id': plan.id,
      'day': plan.day.toIso8601String(),
      'timeZone': plan.timeZone,
      'revision': plan.revision,
    };
  }

  Map<String, Object?> _taskJson(Task task) {
    return <String, Object?>{
      'id': task.id,
      'dayPlanId': task.dayPlanId,
      'blockId': task.blockId,
      'title': task.title,
      'notes': task.notes,
      'energyRequired': task.energyRequired,
      'cognitiveLoad': task.cognitiveLoad,
      'dependencyIds': taskDependencyIds(task),
      'requestedDay': task.requestedDay,
      'requestedStartTime': task.requestedStartTime,
      'requestedEndTime': task.requestedEndTime,
      'approximateTime': task.approximateTime,
      'estimatedMinutes': task.estimatedMinutes,
      'actualMinutes': task.actualMinutes,
      'priority': task.priority,
      'category': task.category,
      'status': task.status,
      'deadline': task.deadline?.toIso8601String(),
      'canSplit': task.canSplit,
      'minimumUsefulMinutes': task.minimumUsefulMinutes,
      'sortOrder': task.sortOrder,
    };
  }

  Map<String, Object?> _taskPlacementJson(Task task) {
    return <String, Object?>{
      'id': task.id,
      'dayPlanId': task.dayPlanId,
      'blockId': task.blockId,
      'status': task.status,
      'sortOrder': task.sortOrder,
    };
  }

  Map<String, Object?> _blockWindowJson(TimeBlock block) {
    return <String, Object?>{
      'id': block.id,
      'startsAt': block.startsAt.toIso8601String(),
      'endsAt': block.endsAt.toIso8601String(),
    };
  }

  domain.DayPlan _toDomainPlan(LocalDaySnapshot snapshot) {
    final tasksByBlock = <String, List<String>>{};
    for (final task in snapshot.tasks) {
      final blockId = task.blockId;
      if (blockId == null) {
        continue;
      }
      tasksByBlock.putIfAbsent(blockId, () => <String>[]).add(task.id);
    }

    return domain.DayPlan(
      id: snapshot.plan.id,
      day: snapshot.plan.day,
      timeZone: snapshot.plan.timeZone,
      workingWindow: _workingWindow(snapshot.preferences, snapshot.plan.day),
      blocks: snapshot.blocks
          .map(
            (block) => domain.TimeBlock(
              id: block.id,
              title: block.title,
              window: domain.TimeWindow(
                start: block.startsAt,
                end: block.endsAt,
              ),
              type: _domainBlockType(block.blockType),
              taskIds: tasksByBlock[block.id] ?? const <String>[],
              category: block.category,
              sourceId: block.sourceId,
              buffers: _domainBuffers(block),
            ),
          )
          .toList(),
      tasks:
          [
                ...snapshot.tasks,
                ...snapshot.inboxTasks.where(
                  (task) => task.status == 'completed',
                ),
              ]
              .map(
                (task) => domain.DayweftTask(
                  id: task.id,
                  title: task.title,
                  estimatedDuration: Duration(minutes: task.estimatedMinutes),
                  actualDuration: task.actualMinutes == null
                      ? null
                      : Duration(minutes: task.actualMinutes!),
                  priority: _domainPriority(task.priority),
                  category: task.category,
                  deadline: task.deadline,
                  notes: task.notes,
                  energyRequired: task.energyRequired == null
                      ? null
                      : domain.EnergyLevel.values.byName(task.energyRequired!),
                  cognitiveLoad: task.cognitiveLoad == null
                      ? null
                      : domain.CognitiveLoad.values.byName(task.cognitiveLoad!),
                  dependencyIds: taskDependencyIds(task),
                  canSplit: task.canSplit,
                  minimumUsefulDuration: Duration(
                    minutes: task.minimumUsefulMinutes,
                  ),
                  status: _domainTaskStatus(task.status),
                ),
              )
              .toList(),
      revision: snapshot.plan.revision,
    );
  }

  domain.BlockType _domainBlockType(String value) {
    return switch (value) {
      'fixed' => domain.BlockType.fixed,
      'optional' => domain.BlockType.optional,
      _ => domain.BlockType.flexible,
    };
  }

  domain.TimeWindow _workingWindow(UserPreference preferences, DateTime day) {
    DateTime time(String value) {
      final parts = value.split(':').map(int.parse).toList();
      return DateTime(day.year, day.month, day.day, parts[0], parts[1]);
    }

    final start = time(preferences.workStartTime);
    final end = time(preferences.workEndTime);
    return domain.TimeWindow(
      start: start,
      end: end.isAfter(start)
          ? end
          : DateTime(end.year, end.month, end.day + 1, end.hour, end.minute),
    );
  }

  domain.TaskPriority _domainPriority(String value) {
    return switch (value) {
      'low' => domain.TaskPriority.low,
      'high' => domain.TaskPriority.high,
      'essential' => domain.TaskPriority.essential,
      _ => domain.TaskPriority.medium,
    };
  }

  domain.TaskStatus _domainTaskStatus(String value) {
    return switch (value) {
      'completed' => domain.TaskStatus.completed,
      'deferred' => domain.TaskStatus.deferred,
      'deleted' => domain.TaskStatus.deleted,
      'planned' => domain.TaskStatus.planned,
      _ => domain.TaskStatus.inbox,
    };
  }

  List<domain.DayweftBuffer> _domainBuffers(TimeBlock block) {
    return <domain.DayweftBuffer>[
      if (block.travelBufferMinutes > 0)
        domain.DayweftBuffer(
          id: '${block.id}:travel',
          type: domain.BufferType.travel,
          duration: Duration(minutes: block.travelBufferMinutes),
        ),
      if (block.preparationBufferMinutes > 0)
        domain.DayweftBuffer(
          id: '${block.id}:preparation',
          type: domain.BufferType.preparation,
          duration: Duration(minutes: block.preparationBufferMinutes),
        ),
      if (block.transitionBufferMinutes > 0)
        domain.DayweftBuffer(
          id: '${block.id}:transition',
          type: domain.BufferType.transition,
          duration: Duration(minutes: block.transitionBufferMinutes),
        ),
      if (block.recoveryBufferMinutes > 0)
        domain.DayweftBuffer(
          id: '${block.id}:recovery',
          type: domain.BufferType.recovery,
          duration: Duration(minutes: block.recoveryBufferMinutes),
        ),
    ];
  }

  DayweftAdaptiveEngine _engineFor(LocalDaySnapshot snapshot) {
    return DayweftAdaptiveEngine(
      minimumTransition: Duration(
        minutes: snapshot.preferences.transitionMinutes,
      ),
      preferredBreakDuration: Duration(
        minutes: snapshot.preferences.preferredBreakMinutes,
      ),
      contingencyDuration: Duration(
        minutes: snapshot.preferences.contingencyMinutes,
      ),
    );
  }

  String _strategyLabel(domain.ReweaveStrategy strategy) {
    return switch (strategy) {
      domain.ReweaveStrategy.protectEssentials => 'Protect Essentials',
      domain.ReweaveStrategy.balancedReweave => 'Balanced Reweave',
      domain.ReweaveStrategy.reducePressure => 'Reduce Pressure',
    };
  }
}
