import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DayweftDatabase database;
  late LocalPlanningRepository repository;
  setUp(() async {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
  });
  tearDown(() async => database.close());

  test(
    'a suggestion cannot overwrite work captured after its preview',
    () async {
      final result = await repository.reweaveToday(
        disruptionType: domain.DisruptionType.custom,
      );
      await repository.addInboxTask(title: 'New local work');
      await expectLater(
        repository.applyReweaveAlternative(result.alternatives.first),
        throwsA(
          isA<PlanningFailure>().having(
            (failure) => failure.code,
            'code',
            PlanningFailureCode.staleProposal,
          ),
        ),
      );
      expect(
        (await repository.loadToday()).inboxTasks.single.title,
        'New local work',
      );
    },
  );

  test(
    'confirmed parsing persists every interpreted field and batch undo',
    () async {
      final captures = [
        repository.parseCapture(
          'Read tomorrow around 2pm for 90m high priority low energy #study',
        ),
        repository.parseCapture('Send notes due tomorrow by 5pm'),
      ];
      await repository.addConfirmedCaptures(captures);
      var snapshot = await LocalPlanningRepository(database).loadToday();
      final reading = snapshot.inboxTasks.firstWhere(
        (task) => task.title == 'Read',
      );
      expect(reading.estimatedMinutes, 90);
      expect(reading.priority, 'high');
      expect(reading.energyRequired, 'low');
      expect(reading.category, 'study');
      expect(reading.requestedStartTime, '14:00');
      expect(reading.approximateTime, isTrue);
      expect(reading.requestedDay, isNotNull);
      expect(
        snapshot.inboxTasks
            .firstWhere((task) => task.title == 'Send notes')
            .deadline,
        isNotNull,
      );
      expect(snapshot.blocks, isEmpty);
      await repository.undoLastRevision();
      snapshot = await repository.loadToday();
      expect(snapshot.inboxTasks, isEmpty);
      expect(snapshot.undoneRevisionIds, hasLength(1));
    },
  );

  Future<TimeBlock> block() async {
    final now = DateTime.now();
    await repository.addBlock(
      title: 'Work',
      startsAt: DateTime(now.year, now.month, now.day, 10),
      endsAt: DateTime(now.year, now.month, now.day, 11),
      blockType: 'flexible',
    );
    return (await repository.loadToday()).blocks.single;
  }

  test('completion does not invent an actual measurement', () async {
    final work = await block();
    await repository.addTaskToBlock(
      blockId: work.id,
      title: 'Measure me',
      estimatedMinutes: 20,
    );
    final task = (await repository.loadToday()).tasks.single;
    await repository.toggleTask(task.id);
    expect(await repository.loadEstimationRecords(), isEmpty);
    expect((await repository.loadRhythmSummary()).medianEstimateFactor, isNull);
    await repository.recordTaskActualDuration(task.id, actualMinutes: 40);
    await repository.recordTaskActualDuration(task.id, actualMinutes: 35);
    final records = await repository.loadEstimationRecords();
    expect(records, hasLength(1));
    expect(records.single.actualMinutes, 35);
    expect(records.single.estimatedMinutes, 20);
    expect(records.single.measurementSource, 'manual');
    await repository.excludeEstimationRecord(records.single.id, excluded: true);
    expect((await repository.loadRhythmSummary()).estimationSampleSize, 0);
    await repository.deleteEstimationRecord(records.single.id);
    expect(await repository.loadEstimationRecords(), isEmpty);
  });

  test(
    'energy is disabled by default and deleting learning removes records',
    () async {
      await expectLater(
        repository.recordEnergyCheckIn('steady'),
        throwsA(isA<PlanningFailure>()),
      );
      await repository.setEnergyEnabled(true);
      await repository.recordEnergyCheckIn('low');
      expect((await repository.loadRhythmSummary()).latestEnergyLevel, 'low');
      await repository.setEnergyEnabled(false);
      expect((await repository.loadRhythmSummary()).latestEnergyLevel, isNull);
      await repository.deleteLearningHistory();
      expect(await database.select(database.energyCheckIns).get(), isEmpty);
    },
  );

  test(
    'block deletion undo restores completed task placement and history',
    () async {
      final work = await block();
      await repository.addTaskToBlock(
        blockId: work.id,
        title: 'Keep me',
        estimatedMinutes: 20,
      );
      final task = (await repository.loadToday()).tasks.single;
      await repository.toggleTask(task.id);
      await repository.deleteBlock(work.id);
      await repository.undoLastRevision();
      final snapshot = await repository.loadToday();
      expect(snapshot.tasks.single.id, task.id);
      expect(snapshot.tasks.single.blockId, work.id);
      expect(snapshot.tasks.single.status, 'completed');
      expect(snapshot.undoneRevisionIds, contains(snapshot.revisions.first.id));
      expect(snapshot.revisions.first.reason, contains('Deleted block'));
    },
  );

  test(
    'invalid blocks and missing destinations cannot corrupt local work',
    () async {
      final now = DateTime.now();
      await expectLater(
        repository.addBlock(
          title: 'Invalid',
          startsAt: now,
          endsAt: now,
          blockType: 'flexible',
        ),
        throwsA(isA<PlanningFailure>()),
      );
      await repository.addInboxTask(title: 'Keep this task');
      final task = (await repository.loadToday()).inboxTasks.single;
      await expectLater(
        repository.moveInboxTaskToBlock(taskId: task.id, blockId: 'missing'),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.loadToday()).inboxTasks.single.id, task.id);
    },
  );

  test(
    'proposal change lists cannot bypass fixed commitments or drop tasks',
    () async {
      final work = await block();
      await repository.addTaskToBlock(
        blockId: work.id,
        title: 'Preserve identity',
        estimatedMinutes: 20,
      );
      final current = await repository.loadToday();
      final trusted = (await repository.reweaveToday(
        disruptionType: domain.DisruptionType.custom,
      )).alternatives.first;
      final missingTaskPreview = domain.DayPlan(
        id: trusted.preview.id,
        day: trusted.preview.day,
        timeZone: trusted.preview.timeZone,
        workingWindow: trusted.preview.workingWindow,
        blocks: trusted.preview.blocks,
        tasks: const [],
        revision: trusted.preview.revision,
      );
      for (final forged in [
        ReweaveAlternative(
          strategy: trusted.strategy,
          preview: missingTaskPreview,
          changes: trusted.changes,
          protectedIds: trusted.protectedIds,
          deferredTaskIds: trusted.deferredTaskIds,
          tradeOffs: trusted.tradeOffs,
          evidenceSummary: trusted.evidenceSummary,
        ),
        ReweaveAlternative(
          strategy: trusted.strategy,
          preview: trusted.preview,
          changes: [
            domain.ScheduleChange(
              entityId: work.id,
              summary: 'Misleading change',
              reason: 'invalid',
              before: domain.TimeWindow(start: work.startsAt, end: work.endsAt),
              after: domain.TimeWindow(
                start: work.startsAt.add(const Duration(hours: 1)),
                end: work.endsAt.add(const Duration(hours: 1)),
              ),
            ),
          ],
          protectedIds: trusted.protectedIds,
          deferredTaskIds: trusted.deferredTaskIds,
          tradeOffs: trusted.tradeOffs,
          evidenceSummary: trusted.evidenceSummary,
        ),
      ]) {
        await expectLater(
          repository.applyReweaveAlternative(forged),
          throwsA(isA<PlanningFailure>()),
        );
      }
      final after = await repository.loadToday();
      expect(after.tasks.single.id, current.tasks.single.id);
      expect(after.blocks.single.startsAt, work.startsAt);
      expect(after.plan.revision, current.plan.revision);
    },
  );
}
