import 'dart:convert';

import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late DayweftDatabase database;
  late LocalPlanningRepository repository;
  setUp(() async {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    await repository.addInboxTask(title: 'Original');
  });
  tearDown(() async => database.close());

  Future<Task> task() async => (await repository.loadToday()).inboxTasks.single;

  test(
    'all edited attributes persist and undo survives repository recreation',
    () async {
      final original = await task();
      final deadline = DateTime(2026, 11, 2, 17);
      await repository.updateTask(
        taskId: original.id,
        expectedVersion: original.localVersion,
        details: domain.TaskDetails(
          title: 'Revised',
          estimatedMinutes: 45,
          priority: domain.TaskPriority.essential,
          category: 'study',
          notes: 'Local notes',
          deadline: deadline,
          energyRequired: domain.EnergyLevel.low,
          cognitiveLoad: domain.CognitiveLoad.demanding,
          canSplit: true,
          minimumUsefulMinutes: 15,
        ),
      );
      repository = LocalPlanningRepository(database);
      final changed = await task();
      expect(changed.title, 'Revised');
      expect(changed.estimatedMinutes, 45);
      expect(changed.priority, 'essential');
      expect(changed.category, 'study');
      expect(changed.notes, 'Local notes');
      expect(changed.deadline, deadline);
      expect(changed.energyRequired, 'low');
      expect(changed.cognitiveLoad, 'demanding');
      expect(changed.canSplit, isTrue);
      expect(changed.localVersion, greaterThan(original.localVersion));
      await repository.undoLastRevision();
      final restored = await task();
      expect(restored.title, original.title);
      expect(restored.notes, isNull);
      expect(restored.deadline, isNull);
      expect(restored.cognitiveLoad, isNull);
      expect(restored.canSplit, isFalse);
      expect(restored.localVersion, greaterThan(changed.localVersion));
    },
  );

  test(
    'stale editors and invalid input cannot overwrite newer local work',
    () async {
      final original = await task();
      await repository.toggleTask(original.id);
      await expectLater(
        repository.updateTask(
          taskId: original.id,
          expectedVersion: original.localVersion,
          details: domain.TaskDetails(title: 'Stale', estimatedMinutes: 20),
        ),
        throwsA(
          isA<PlanningFailure>().having(
            (e) => e.code,
            'code',
            PlanningFailureCode.staleProposal,
          ),
        ),
      );
      final current = await task();
      await expectLater(
        repository.updateTask(
          taskId: current.id,
          expectedVersion: current.localVersion,
          details: domain.TaskDetails(title: ' ', estimatedMinutes: -1),
        ),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await task()).title, 'Original');
      expect((await task()).status, 'completed');
    },
  );

  test(
    'deletion preserves task identity, attributes, completion and undo',
    () async {
      final original = await task();
      await repository.toggleTask(original.id);
      final completed = await task();
      await repository.deleteTask(
        completed.id,
        expectedVersion: completed.localVersion,
      );
      expect((await repository.loadToday()).inboxTasks, isEmpty);
      await repository.undoLastRevision();
      expect((await task()).id, completed.id);
      expect((await task()).status, 'completed');
      expect((await task()).deletedAt, isNull);
    },
  );

  test(
    'dependency cycles and deleting a required predecessor are rejected atomically',
    () async {
      final first = await task();
      await repository.addInboxTask(title: 'Successor');
      final second = (await repository.loadToday()).inboxTasks.last;
      await repository.updateTask(
        taskId: second.id,
        expectedVersion: second.localVersion,
        details: domain.TaskDetails(
          title: second.title,
          estimatedMinutes: 30,
          dependencyIds: [first.id],
        ),
      );
      await expectLater(
        repository.updateTask(
          taskId: first.id,
          expectedVersion: first.localVersion,
          details: domain.TaskDetails(
            title: first.title,
            estimatedMinutes: 30,
            dependencyIds: [second.id],
          ),
        ),
        throwsA(isA<PlanningFailure>()),
      );
      await expectLater(
        repository.deleteTask(first.id, expectedVersion: first.localVersion),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.loadToday()).inboxTasks, hasLength(2));
    },
  );

  test(
    'returning completed work to inbox and undo preserves placement and status',
    () async {
      final now = DateTime.now();
      await repository.addBlock(
        title: 'Work',
        startsAt: DateTime(now.year, now.month, now.day, 10),
        endsAt: DateTime(now.year, now.month, now.day, 11),
        blockType: 'flexible',
      );
      final block = (await repository.loadToday()).blocks.single;
      final original = await task();
      await repository.moveInboxTaskToBlock(
        taskId: original.id,
        blockId: block.id,
      );
      await repository.toggleTask(original.id);
      final planned = (await repository.loadToday()).tasks.single;
      await repository.returnTaskToInbox(
        planned.id,
        expectedVersion: planned.localVersion,
      );
      expect((await task()).status, 'completed');
      expect((await task()).blockId, isNull);
      await repository.undoLastRevision();
      final restored = (await repository.loadToday()).tasks.single;
      expect(restored.blockId, block.id);
      expect(restored.status, 'completed');
    },
  );

  test(
    'export/import preserves constraints and remaps dependency identities',
    () async {
      final predecessor = await task();
      await repository.addInboxTask(title: 'Dependent');
      final dependent = (await repository.loadToday()).inboxTasks.last;
      await repository.updateTask(
        taskId: dependent.id,
        expectedVersion: dependent.localVersion,
        details: domain.TaskDetails(
          title: dependent.title,
          estimatedMinutes: 40,
          dependencyIds: [predecessor.id],
          cognitiveLoad: domain.CognitiveLoad.demanding,
          energyRequired: domain.EnergyLevel.high,
          canSplit: true,
          minimumUsefulMinutes: 20,
          notes: 'Preserve notes',
          deadline: DateTime(2026, 11, 5, 16),
        ),
      );
      final exported = await repository.exportLocalData();
      final target = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(target.close);
      final importer = LocalPlanningRepository(target);
      await importer.importLocalData(exported);
      final imported = (await importer.loadToday()).inboxTasks;
      final restored = imported.firstWhere((task) => task.title == 'Dependent');
      expect(restored.cognitiveLoad, 'demanding');
      expect(restored.energyRequired, 'high');
      expect(restored.notes, 'Preserve notes');
      expect(restored.minimumUsefulMinutes, 20);
      expect(taskDependencyIds(restored), [
        imported.firstWhere((task) => task.title == 'Original').id,
      ]);
      expect(restored.id, isNot(dependent.id));
      final invalid = jsonDecode(exported) as Map<String, Object?>;
      final rows = (invalid['tasks']! as List<Object?>)
          .cast<Map<String, Object?>>();
      rows.first['dependencyIds'] = ['missing'];
      await expectLater(
        importer.importLocalData(jsonEncode(invalid)),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await importer.loadToday()).inboxTasks, hasLength(2));
    },
  );

  test('a deletion snackbar cannot undo a later unrelated change', () async {
    final original = await task();
    await repository.deleteTask(
      original.id,
      expectedVersion: original.localVersion,
    );
    final deletionId = (await repository.loadToday()).revisions.first.id;
    await repository.addInboxTask(title: 'Later work');
    await expectLater(
      repository.undoLastRevision(expectedRevisionId: deletionId),
      throwsA(isA<PlanningFailure>()),
    );
    expect(
      (await repository.loadToday()).inboxTasks.single.title,
      'Later work',
    );
  });

  test(
    'block category and buffers persist and undo restores all values',
    () async {
      final now = DateTime.now();
      await repository.addBlock(
        title: 'Travel',
        startsAt: DateTime(now.year, now.month, now.day, 10),
        endsAt: DateTime(now.year, now.month, now.day, 11),
        blockType: 'flexible',
        category: 'work',
        travelBufferMinutes: 5,
      );
      final original = (await repository.loadToday()).blocks.single;
      await repository.updateBlock(
        blockId: original.id,
        expectedVersion: original.localVersion,
        title: 'Prepared',
        startsAt: original.startsAt,
        endsAt: original.endsAt,
        blockType: 'fixed',
        category: 'study',
        travelBufferMinutes: 10,
        preparationBufferMinutes: 5,
        transitionBufferMinutes: 5,
        recoveryBufferMinutes: 10,
      );
      final changed = (await repository.loadToday()).blocks.single;
      expect(changed.recoveryBufferMinutes, 10);
      expect(changed.category, 'study');
      await expectLater(
        repository.updateBlock(
          blockId: original.id,
          expectedVersion: original.localVersion,
          title: 'Stale',
          startsAt: original.startsAt,
          endsAt: original.endsAt,
          blockType: 'flexible',
        ),
        throwsA(isA<PlanningFailure>()),
      );
      await repository.undoLastRevision();
      final restored = (await repository.loadToday()).blocks.single;
      expect(restored.category, 'work');
      expect(restored.travelBufferMinutes, 5);
      expect(restored.recoveryBufferMinutes, 0);
      expect(restored.localVersion, greaterThan(changed.localVersion));
    },
  );
}
