import 'dart:convert';

import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class LocalDaySnapshot {
  const LocalDaySnapshot({
    required this.plan,
    required this.blocks,
    required this.tasks,
    required this.inboxTasks,
    required this.revisions,
    required this.preferences,
  });

  final DayPlan plan;
  final List<TimeBlock> blocks;
  final List<Task> tasks;
  final List<Task> inboxTasks;
  final List<ScheduleRevision> revisions;
  final UserPreference preferences;

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
  });

  final String title;
  final int estimatedMinutes;
  final String? startTime;
  final String? endTime;
  final String priority;
  final String? category;

  bool get hasSchedule => startTime != null && endTime != null;
}

class LocalPlanningRepository {
  LocalPlanningRepository(this._database, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

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
    final now = DateTime.now();
    final companion = UserPreferencesCompanion.insert(
      id: _preferencesId,
      createdAt: now,
      updatedAt: now,
    );
    await _database.into(_database.userPreferences).insert(companion);
    return (_database.select(
      _database.userPreferences,
    )..where((row) => row.id.equals(_preferencesId))).getSingle();
  }

  Future<void> completeOnboarding({required bool includeSampleData}) async {
    final preferences = await ensurePreferences();
    final now = DateTime.now();
    await (_database.update(
      _database.userPreferences,
    )..where((row) => row.id.equals(preferences.id))).write(
      UserPreferencesCompanion(
        onboardingCompleted: const Value(true),
        sampleDataEnabled: Value(includeSampleData),
        updatedAt: Value(now),
      ),
    );
    if (includeSampleData) {
      await _installSampleData(DateTime.now());
    }
  }

  Future<void> removeSampleData() async {
    final snapshot = await loadToday();
    final sampleBlocks = snapshot.blocks
        .where((block) => block.sourceId == 'sample-data')
        .map((block) => block.id)
        .toSet();
    final now = DateTime.now();
    for (final task in snapshot.tasks) {
      if (task.sourceId == 'sample-data' ||
          sampleBlocks.contains(task.blockId)) {
        await (_database.update(
          _database.tasks,
        )..where((row) => row.id.equals(task.id))).write(
          TasksCompanion(
            status: const Value('deleted'),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      }
    }
    for (final block in snapshot.blocks.where(
      (block) => sampleBlocks.contains(block.id),
    )) {
      await (_database.update(
        _database.timeBlocks,
      )..where((row) => row.id.equals(block.id))).write(
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
  }

  Future<LocalDaySnapshot> loadToday() async {
    final preferences = await ensurePreferences();
    final today = _dateOnly(DateTime.now());
    final plan = await _ensurePlan(today, preferences);
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

    return LocalDaySnapshot(
      plan: plan,
      blocks: blocks,
      tasks: tasks,
      inboxTasks: inboxTasks,
      revisions: revisions,
      preferences: preferences,
    );
  }

  Future<void> addBlock({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
    String? category,
    String? sourceId,
  }) async {
    final snapshot = await loadToday();
    final now = DateTime.now();
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
    final snapshot = await loadToday();
    final block = snapshot.blocks.firstWhere(
      (candidate) => candidate.id == blockId,
    );
    final blockTasks = snapshot.tasksForBlock(blockId);
    final now = DateTime.now();
    await _database.transaction(() async {
      await (_database.update(
        _database.timeBlocks,
      )..where((row) => row.id.equals(blockId))).write(
        TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
      for (final task in blockTasks) {
        await (_database.update(
          _database.tasks,
        )..where((row) => row.id.equals(task.id))).write(
          TasksCompanion(
            status: const Value('inbox'),
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
          'taskIds': blockTasks.map((task) => task.id).toList(),
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
  }) async {
    final snapshot = await loadToday();
    final block = snapshot.blocks.firstWhere(
      (candidate) => candidate.id == blockId,
    );
    final now = DateTime.now();
    await _database.transaction(() async {
      await (_database.update(
        _database.timeBlocks,
      )..where((row) => row.id.equals(blockId))).write(
        TimeBlocksCompanion(
          title: Value(title),
          startsAt: Value(startsAt),
          endsAt: Value(endsAt),
          blockType: Value(blockType),
          updatedAt: Value(now),
        ),
      );
      await _recordRevision(
        snapshot.plan,
        'Edited block "${block.title}".',
        <String, Object?>{'undo': 'update_block', 'block': _blockJson(block)},
      );
    });
  }

  Future<void> moveBlock({
    required String blockId,
    required int direction,
  }) async {
    final snapshot = await loadToday();
    final blocks = [...snapshot.blocks];
    final index = blocks.indexWhere((block) => block.id == blockId);
    final target = index + direction;
    if (index < 0 || target < 0 || target >= blocks.length) {
      return;
    }
    final moved = blocks[index];
    final swapped = blocks[target];
    final now = DateTime.now();
    await _database.transaction(() async {
      await (_database.update(
        _database.timeBlocks,
      )..where((row) => row.id.equals(moved.id))).write(
        TimeBlocksCompanion(sortOrder: Value(target), updatedAt: Value(now)),
      );
      await (_database.update(
        _database.timeBlocks,
      )..where((row) => row.id.equals(swapped.id))).write(
        TimeBlocksCompanion(sortOrder: Value(index), updatedAt: Value(now)),
      );
      await _recordRevision(
        snapshot.plan,
        'Reordered "${moved.title}".',
        <String, Object?>{'undo': 'reorder_blocks'},
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
    final snapshot = await loadToday();
    final sortOrder = snapshot.tasksForBlock(blockId).length;
    final now = DateTime.now();
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
  }) async {
    final now = DateTime.now();
    await _database
        .into(_database.tasks)
        .insert(
          TasksCompanion.insert(
            id: _uuid.v4(),
            dayPlanId: const Value(null),
            blockId: const Value(null),
            title: title,
            estimatedMinutes: estimatedMinutes,
            priority: priority,
            status: 'inbox',
            category: Value(category),
            sourceId: Value(sourceId),
            sortOrder: 0,
            syncState: SyncState.localOnly,
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> addInboxTasks(List<String> titles) async {
    for (final title in titles.where((value) => value.trim().isNotEmpty)) {
      await addInboxTask(title: title.trim());
    }
  }

  Future<void> moveInboxTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    final snapshot = await loadToday();
    final task = snapshot.inboxTasks.firstWhere(
      (candidate) => candidate.id == taskId,
    );
    final now = DateTime.now();
    await _database.transaction(() async {
      await (_database.update(
        _database.tasks,
      )..where((row) => row.id.equals(taskId))).write(
        TasksCompanion(
          dayPlanId: Value(snapshot.plan.id),
          blockId: Value(blockId),
          status: const Value('planned'),
          sortOrder: Value(snapshot.tasksForBlock(blockId).length),
          updatedAt: Value(now),
        ),
      );
      await _recordRevision(
        snapshot.plan,
        'Moved "${task.title}" from Inbox to Today Timeline.',
        <String, Object?>{'undo': 'move_task_to_inbox', 'taskId': taskId},
      );
    });
  }

  Future<void> movePlannedTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    final snapshot = await loadToday();
    final task = snapshot.tasks.firstWhere(
      (candidate) => candidate.id == taskId,
    );
    final now = DateTime.now();
    await _database.transaction(() async {
      await (_database.update(
        _database.tasks,
      )..where((row) => row.id.equals(taskId))).write(
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
          'undo': 'move_task_to_block',
          'taskId': taskId,
          'blockId': task.blockId,
        },
      );
    });
  }

  Future<void> toggleTask(String taskId) async {
    final snapshot = await loadToday();
    final task = [
      ...snapshot.tasks,
      ...snapshot.inboxTasks,
    ].firstWhere((candidate) => candidate.id == taskId);
    final nextStatus = task.status == 'completed'
        ? (task.blockId == null ? 'inbox' : 'planned')
        : 'completed';
    final now = DateTime.now();
    await (_database.update(
      _database.tasks,
    )..where((row) => row.id.equals(taskId))).write(
      TasksCompanion(status: Value(nextStatus), updatedAt: Value(now)),
    );
  }

  Future<void> applyTemplate(DayTemplate template) async {
    final snapshot = await loadToday();
    final now = DateTime.now();
    final blockIds = <String>[];
    await _database.transaction(() async {
      for (final block in template.blocks) {
        final blockId = _uuid.v4();
        blockIds.add(blockId);
        await _database
            .into(_database.timeBlocks)
            .insert(
              TimeBlocksCompanion.insert(
                id: blockId,
                dayPlanId: snapshot.plan.id,
                title: block.title,
                startsAt: _timeOnToday(block.startTime),
                endsAt: _timeOnToday(block.endTime),
                blockType: block.blockType,
                category: Value(block.category),
                sourceId: Value('template:${template.id}'),
                sortOrder: snapshot.blocks.length + blockIds.length - 1,
                syncState: SyncState.localOnly,
                createdAt: now,
                updatedAt: now,
              ),
            );
      }
      await _recordRevision(
        snapshot.plan,
        'Applied ${template.name} template.',
        <String, Object?>{'undo': 'delete_blocks', 'blockIds': blockIds},
      );
    });
  }

  Future<bool> undoLastRevision() async {
    final snapshot = await loadToday();
    final revision = snapshot.revisions.firstOrNull;
    if (revision == null) {
      return false;
    }
    final payload =
        jsonDecode(revision.reversibleChangeSetJson) as Map<String, Object?>;
    final undo = payload['undo'];
    final now = DateTime.now();

    await _database.transaction(() async {
      if (undo == 'delete_block') {
        final blockId = payload['blockId'] as String;
        await (_database.update(
          _database.timeBlocks,
        )..where((row) => row.id.equals(blockId))).write(
          TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      } else if (undo == 'delete_blocks') {
        final blockIds = (payload['blockIds'] as List<Object?>).cast<String>();
        for (final blockId in blockIds) {
          await (_database.update(
            _database.timeBlocks,
          )..where((row) => row.id.equals(blockId))).write(
            TimeBlocksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
          );
        }
      } else if (undo == 'delete_task') {
        final taskId = payload['taskId'] as String;
        await (_database.update(
          _database.tasks,
        )..where((row) => row.id.equals(taskId))).write(
          TasksCompanion(
            status: const Value('deleted'),
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      } else if (undo == 'move_task_to_inbox') {
        final taskId = payload['taskId'] as String;
        await (_database.update(
          _database.tasks,
        )..where((row) => row.id.equals(taskId))).write(
          TasksCompanion(
            dayPlanId: const Value(null),
            blockId: const Value(null),
            status: const Value('inbox'),
            updatedAt: Value(now),
          ),
        );
      } else if (undo == 'restore_block') {
        final block = payload['block'] as Map<String, Object?>;
        await (_database.update(
          _database.timeBlocks,
        )..where((row) => row.id.equals(block['id']! as String))).write(
          TimeBlocksCompanion(
            deletedAt: const Value(null),
            updatedAt: Value(now),
          ),
        );
      } else if (undo == 'update_block') {
        final block = payload['block'] as Map<String, Object?>;
        await (_database.update(
          _database.timeBlocks,
        )..where((row) => row.id.equals(block['id']! as String))).write(
          TimeBlocksCompanion(
            title: Value(block['title']! as String),
            startsAt: Value(DateTime.parse(block['startsAt']! as String)),
            endsAt: Value(DateTime.parse(block['endsAt']! as String)),
            blockType: Value(block['blockType']! as String),
            updatedAt: Value(now),
          ),
        );
      } else if (undo == 'move_task_to_block') {
        final taskId = payload['taskId'] as String;
        final blockId = payload['blockId'] as String?;
        await (_database.update(
          _database.tasks,
        )..where((row) => row.id.equals(taskId))).write(
          TasksCompanion(blockId: Value(blockId), updatedAt: Value(now)),
        );
      }
      await (_database.delete(
        _database.scheduleRevisions,
      )..where((row) => row.id.equals(revision.id))).go();
    });
    return true;
  }

  ParsedCapture parseCapture(String input) {
    final trimmed = input.trim();
    final durationMatch = RegExp(
      r'(\d+)\s*(m|min|mins|minutes|h|hr|hour|hours)\b',
    ).firstMatch(trimmed);
    final estimatedMinutes = durationMatch == null
        ? 30
        : _durationToMinutes(
            int.parse(durationMatch.group(1)!),
            durationMatch.group(2)!,
          );
    final timeRange = RegExp(
      r'\b(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\s*[-–]\s*(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
      caseSensitive: false,
    ).firstMatch(trimmed);
    final priority = trimmed.toLowerCase().contains('urgent')
        ? 'essential'
        : 'medium';
    return ParsedCapture(
      title: trimmed
          .replaceAll(
            RegExp(
              r'\bfor\s+\d+\s*(m|min|mins|minutes|h|hr|hour|hours)\b',
              caseSensitive: false,
            ),
            '',
          )
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim(),
      estimatedMinutes: estimatedMinutes,
      startTime: timeRange == null ? null : _normaliseTime(timeRange, 1, 2, 3),
      endTime: timeRange == null ? null : _normaliseTime(timeRange, 4, 5, 6),
      priority: priority,
    );
  }

  Future<DayPlan> _ensurePlan(DateTime day, UserPreference preferences) async {
    final existing = await (_database.select(
      _database.dayPlans,
    )..where((row) => row.day.equals(day))).getSingleOrNull();
    if (existing != null) {
      return existing;
    }
    final now = DateTime.now();
    final planId = _uuid.v4();
    await _database
        .into(_database.dayPlans)
        .insert(
          DayPlansCompanion.insert(
            id: planId,
            day: day,
            timeZone: DateTime.now().timeZoneName,
            syncState: SyncState.localOnly,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await addBlock(
      title: 'Start the day',
      startsAt: _timeOnToday(preferences.wakeTime),
      endsAt: _timeOnToday(_addMinutes(preferences.wakeTime, 30)),
      blockType: 'fixed',
      category: 'routine',
      sourceId: 'bookend',
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

  Future<void> _recordRevision(
    DayPlan plan,
    String reason,
    Map<String, Object?> reversibleChangeSet,
  ) async {
    final now = DateTime.now();
    final nextRevision = plan.revision + 1;
    await _database
        .into(_database.scheduleRevisions)
        .insert(
          ScheduleRevisionsCompanion.insert(
            id: _uuid.v4(),
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
      DayPlansCompanion(revision: Value(nextRevision), updatedAt: Value(now)),
    );
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime _timeOnToday(String value) {
    final parts = value.split(':').map(int.parse).toList();
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, parts[0], parts[1]);
  }

  String _addMinutes(String value, int minutes) {
    final parts = value.split(':').map(int.parse).toList();
    final total = parts[0] * 60 + parts[1] + minutes;
    final hour = (total ~/ 60) % 24;
    final minute = total % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int _durationToMinutes(int amount, String unit) {
    final normalised = unit.toLowerCase();
    if (normalised.startsWith('h')) {
      return amount * 60;
    }
    return amount;
  }

  String _normaliseTime(
    RegExpMatch match,
    int hourIndex,
    int minuteIndex,
    int meridiemIndex,
  ) {
    var hour = int.parse(match.group(hourIndex)!);
    final minute = int.tryParse(match.group(minuteIndex) ?? '0') ?? 0;
    final meridiem = match.group(meridiemIndex)?.toLowerCase();
    if (meridiem == 'pm' && hour < 12) {
      hour += 12;
    }
    if (meridiem == 'am' && hour == 12) {
      hour = 0;
    }
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
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
      'sortOrder': block.sortOrder,
    };
  }
}

class DayTemplate {
  const DayTemplate({
    required this.id,
    required this.name,
    required this.blocks,
  });

  final String id;
  final String name;
  final List<TemplateBlock> blocks;
}

class TemplateBlock {
  const TemplateBlock({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.blockType,
    required this.category,
  });

  final String title;
  final String startTime;
  final String endTime;
  final String blockType;
  final String category;
}

const dayweftTemplates = <DayTemplate>[
  DayTemplate(
    id: 'workday',
    name: 'Workday',
    blocks: <TemplateBlock>[
      TemplateBlock(
        title: 'Plan the day',
        startTime: '09:00',
        endTime: '09:20',
        blockType: 'fixed',
        category: 'planning',
      ),
      TemplateBlock(
        title: 'Deep work',
        startTime: '09:30',
        endTime: '11:30',
        blockType: 'flexible',
        category: 'work',
      ),
      TemplateBlock(
        title: 'Admin wrap-up',
        startTime: '16:00',
        endTime: '16:45',
        blockType: 'optional',
        category: 'admin',
      ),
    ],
  ),
  DayTemplate(
    id: 'study',
    name: 'Study day',
    blocks: <TemplateBlock>[
      TemplateBlock(
        title: 'Reading block',
        startTime: '10:00',
        endTime: '11:30',
        blockType: 'flexible',
        category: 'study',
      ),
      TemplateBlock(
        title: 'Practice questions',
        startTime: '13:00',
        endTime: '14:30',
        blockType: 'flexible',
        category: 'study',
      ),
    ],
  ),
  DayTemplate(
    id: 'recovery',
    name: 'Recovery day',
    blocks: <TemplateBlock>[
      TemplateBlock(
        title: 'Low-pressure essentials',
        startTime: '10:00',
        endTime: '11:00',
        blockType: 'fixed',
        category: 'admin',
      ),
      TemplateBlock(
        title: 'Recovery time',
        startTime: '14:00',
        endTime: '15:00',
        blockType: 'fixed',
        category: 'rest',
      ),
    ],
  ),
];
