import 'dart:io';

import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'draft persists atomically without changing the plan and rejects stale writes',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'dayweft-allocations-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/planning.sqlite');
      var db = DayweftDatabase.forTesting(NativeDatabase(file));
      addTearDown(() => db.close());
      final day = DateTime(2026, 11, 2);
      var repository = LocalPlanningRepository(db, planningDate: day);
      await repository.addBlock(
        title: 'First',
        startsAt: DateTime(2026, 11, 2, 9),
        endsAt: DateTime(2026, 11, 2, 10),
        blockType: 'flexible',
      );
      await repository.addBlock(
        title: 'Second',
        startsAt: DateTime(2026, 11, 2, 11),
        endsAt: DateTime(2026, 11, 2, 12),
        blockType: 'flexible',
      );
      var snapshot = await repository.loadSelectedDay();
      await repository.addTaskToBlock(
        blockId: snapshot.blocks.first.id,
        title: 'Keep all work',
        estimatedMinutes: 60,
      );
      snapshot = await repository.loadSelectedDay();
      final original = snapshot.tasks.single;
      await repository.updateTask(
        taskId: original.id,
        expectedVersion: original.localVersion,
        details: domain.TaskDetails(
          title: original.title,
          estimatedMinutes: 60,
          canSplit: true,
          minimumUsefulMinutes: 20,
        ),
      );
      snapshot = await repository.loadSelectedDay();
      final allocations = [
        for (var i = 0; i < 2; i++)
          domain.TaskAllocation(
            id: 'fragment-$i',
            taskId: original.id,
            blockId: snapshot.blocks[i].id,
            window: domain.TimeWindow(
              start: snapshot.blocks[i].startsAt,
              end: snapshot.blocks[i].startsAt.add(const Duration(minutes: 30)),
            ),
          ),
      ];
      final saved = await repository.saveAllocationDraft(
        expectedPlanId: snapshot.plan.id,
        expectedPlanRevision: snapshot.plan.revision,
        expectedDraftVersion: null,
        allocations: allocations,
      );
      expect(saved.version, 1);
      final unchanged = await repository.loadSelectedDay();
      expect(unchanged.plan.revision, snapshot.plan.revision);
      expect(unchanged.tasks.single.blockId, snapshot.blocks.first.id);
      await db.close();
      db = DayweftDatabase.forTesting(NativeDatabase(file));
      repository = LocalPlanningRepository(db, planningDate: day);
      final reopened = (await repository.loadAllocationDraft())!;
      expect(reopened.version, 1);
      expect(reopened.isStale, isFalse);
      expect(reopened.allocations.map((part) => part.id), [
        'fragment-0',
        'fragment-1',
      ]);
      expect(
        reopened.allocations.last.window.duration,
        const Duration(minutes: 30),
      );
      await expectLater(
        repository.saveAllocationDraft(
          expectedPlanId: snapshot.plan.id,
          expectedPlanRevision: snapshot.plan.revision,
          expectedDraftVersion: null,
          allocations: allocations,
        ),
        throwsA(isA<PlanningFailure>()),
      );
      await expectLater(
        repository.saveAllocationDraft(
          expectedPlanId: snapshot.plan.id,
          expectedPlanRevision: snapshot.plan.revision,
          expectedDraftVersion: 1,
          allocations: [allocations.first],
        ),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.loadAllocationDraft())!.version, 1);
      final revised = await repository.saveAllocationDraft(
        expectedPlanId: snapshot.plan.id,
        expectedPlanRevision: snapshot.plan.revision,
        expectedDraftVersion: 1,
        allocations: allocations,
      );
      expect(revised.version, 2);
      await (db.update(db.tasks)..where((row) => row.id.equals(original.id)))
          .write(const TasksCompanion(estimatedMinutes: Value(90)));
      expect((await repository.loadAllocationDraft())!.isStale, isTrue);
      await (db.update(db.tasks)..where((row) => row.id.equals(original.id)))
          .write(const TasksCompanion(estimatedMinutes: Value(60)));
      expect((await repository.loadAllocationDraft())!.isStale, isFalse);
      await repository.addInboxTask(title: 'A later change');
      await expectLater(
        repository.saveAllocationDraft(
          expectedPlanId: snapshot.plan.id,
          expectedPlanRevision: snapshot.plan.revision,
          expectedDraftVersion: 2,
          allocations: allocations,
        ),
        throwsA(isA<PlanningFailure>()),
      );
      final current = await repository.loadSelectedDay();
      expect(current.tasks.single.blockId, snapshot.blocks.first.id);
      expect(
        (await repository.loadAllocationDraft())!.planRevision,
        snapshot.plan.revision,
      );
      expect((await repository.loadAllocationDraft())!.isStale, isTrue);
    },
  );
}
