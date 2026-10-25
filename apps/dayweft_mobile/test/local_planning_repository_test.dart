import 'dart:convert';

import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('local repository creates a day plan and inbox tasks', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);

    await repository.completeOnboarding(includeSampleData: false);
    await repository.addInboxTask(title: 'Call Alex for 20 min');

    final snapshot = await repository.loadToday();

    expect(snapshot.preferences.onboardingCompleted, isTrue);
    expect(snapshot.plan.id, isNotEmpty);
    expect(snapshot.inboxTasks.single.title, 'Call Alex for 20 min');
  });

  test('basic parser confirms duration, priority and time range', () {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);

    final parsed = repository.parseCapture(
      'Urgent review notes for 45 min 9-10am',
    );

    expect(parsed.estimatedMinutes, 45);
    expect(parsed.priority, 'essential');
    expect(parsed.startTime, '09:00');
    expect(parsed.endTime, '10:00');
  });

  test('undo removes the last locally created block', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    final now = DateTime.now();

    await repository.addBlock(
      title: 'Temporary block',
      startsAt: DateTime(now.year, now.month, now.day, 13),
      endsAt: DateTime(now.year, now.month, now.day, 14),
      blockType: 'flexible',
    );
    expect((await repository.loadToday()).blocks, isNotEmpty);

    final didUndo = await repository.undoLastRevision();

    expect(didUndo, isTrue);
    expect(
      (await repository.loadToday()).blocks.any(
        (block) => block.title == 'Temporary block',
      ),
      isFalse,
    );
  });

  test('blocks can be edited and reordered locally', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    final now = DateTime.now();

    await repository.addBlock(
      title: 'First',
      startsAt: DateTime(now.year, now.month, now.day, 10),
      endsAt: DateTime(now.year, now.month, now.day, 11),
      blockType: 'flexible',
    );
    await repository.addBlock(
      title: 'Second',
      startsAt: DateTime(now.year, now.month, now.day, 12),
      endsAt: DateTime(now.year, now.month, now.day, 13),
      blockType: 'optional',
    );
    final firstSnapshot = await repository.loadToday();
    final second = firstSnapshot.blocks.firstWhere(
      (block) => block.title == 'Second',
    );

    await repository.updateBlock(
      blockId: second.id,
      title: 'Second resized',
      startsAt: DateTime(now.year, now.month, now.day, 12, 30),
      endsAt: DateTime(now.year, now.month, now.day, 13, 30),
      blockType: 'fixed',
    );
    await repository.moveBlock(blockId: second.id, direction: -1);

    final snapshot = await repository.loadToday();
    expect(
      snapshot.blocks.any((block) => block.title == 'Second resized'),
      isTrue,
    );
    expect(
      snapshot.blocks.firstWhere((block) => block.id == second.id).blockType,
      'fixed',
    );

    await repository.undoLastRevision();
    final undone = await repository.loadToday();
    expect(undone.blocks.last.id, second.id);
  });

  test('planned tasks can move between blocks', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    final now = DateTime.now();

    await repository.addBlock(
      title: 'Source',
      startsAt: DateTime(now.year, now.month, now.day, 10),
      endsAt: DateTime(now.year, now.month, now.day, 11),
      blockType: 'flexible',
    );
    await repository.addBlock(
      title: 'Target',
      startsAt: DateTime(now.year, now.month, now.day, 12),
      endsAt: DateTime(now.year, now.month, now.day, 13),
      blockType: 'flexible',
    );
    var snapshot = await repository.loadToday();
    final source = snapshot.blocks.firstWhere(
      (block) => block.title == 'Source',
    );
    final target = snapshot.blocks.firstWhere(
      (block) => block.title == 'Target',
    );

    await repository.addTaskToBlock(
      blockId: source.id,
      title: 'Move me',
      estimatedMinutes: 25,
    );
    snapshot = await repository.loadToday();
    final task = snapshot.tasks.firstWhere(
      (candidate) => candidate.title == 'Move me',
    );

    await repository.movePlannedTaskToBlock(
      taskId: task.id,
      blockId: target.id,
    );

    snapshot = await repository.loadToday();
    expect(
      snapshot.tasks.firstWhere((candidate) => candidate.id == task.id).blockId,
      target.id,
    );
  });

  test('local data can be exported and imported as JSON', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    final now = DateTime.now();

    await repository.addBlock(
      title: 'Exported block',
      startsAt: DateTime(now.year, now.month, now.day, 14),
      endsAt: DateTime(now.year, now.month, now.day, 15),
      blockType: 'flexible',
    );
    final export = await repository.exportLocalData();
    final decoded = jsonDecode(export) as Map<String, Object?>;

    expect(decoded['product'], 'Dayweft');
    expect(export, contains('Exported block'));

    final importDatabase = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(importDatabase.close);
    final importRepository = LocalPlanningRepository(importDatabase);
    await importRepository.completeOnboarding(includeSampleData: false);

    await importRepository.importLocalData(export);

    final imported = await importRepository.loadToday();
    expect(
      imported.blocks.any((block) => block.title == 'Exported block'),
      isTrue,
    );
    expect(imported.revisions.first.reason, 'Imported local Dayweft data.');
  });

  test('planning buffer preferences update locally', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);

    await repository.updatePlanningBuffers(
      preferredBreakMinutes: 25,
      contingencyMinutes: 45,
      transitionMinutes: 15,
    );

    final snapshot = await repository.loadToday();
    expect(snapshot.preferences.preferredBreakMinutes, 25);
    expect(snapshot.preferences.contingencyMinutes, 45);
    expect(snapshot.preferences.transitionMinutes, 15);
  });

  test(
    'rhythm summary uses local estimation, energy and focus evidence',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalPlanningRepository(database);
      await repository.completeOnboarding(includeSampleData: false);
      final now = DateTime.now();

      await repository.addBlock(
        title: 'Evidence block',
        startsAt: DateTime(now.year, now.month, now.day, 10),
        endsAt: DateTime(now.year, now.month, now.day, 11),
        blockType: 'flexible',
      );
      var snapshot = await repository.loadToday();
      final block = snapshot.blocks.firstWhere(
        (candidate) => candidate.title == 'Evidence block',
      );
      for (var index = 0; index < 12; index += 1) {
        await repository.addTaskToBlock(
          blockId: block.id,
          title: 'Evidence task $index',
          estimatedMinutes: 20,
        );
        snapshot = await repository.loadToday();
        final task = snapshot.tasks.firstWhere(
          (candidate) => candidate.title == 'Evidence task $index',
        );
        await repository.toggleTask(task.id);
        await repository.recordTaskActualDuration(task.id, actualMinutes: 30);
      }
      await repository.setEnergyEnabled(true);
      await repository.recordEnergyCheckIn('steady');
      await repository.completeFocusSession(
        title: 'Focus evidence',
        plannedMinutes: 25,
        actualMinutes: 12,
        interruptionCount: 1,
      );

      final summary = await repository.loadRhythmSummary();

      expect(summary.estimationSampleSize, 12);
      expect(summary.medianEstimateFactor, 1.5);
      expect(summary.latestEnergyLevel, 'steady');
      expect(summary.focusSessionCount, 1);
      expect(summary.totalFocusMinutes, 12);
    },
  );

  test('local sharing and calendar permission state are stored', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);

    final share = await repository.createLocalAvailabilityShare();
    await repository.revokeLocalShares();
    await repository.markCalendarPermission('not_requested');

    expect(share.shareType, 'availability');
    final revokedShares = await database.select(database.shareLinks).get();
    expect(revokedShares.single.revokedAt, isNotNull);
    final calendars = await database.select(database.calendarConnections).get();
    expect(calendars.single.permissionState, 'not_requested');
    expect(calendars.single.readOnly, isTrue);
  });

  test('confirmed reweave defers eligible work and undo restores it', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    final now = DateTime.now();

    await repository.addBlock(
      title: 'Flexible work',
      startsAt: DateTime(now.year, now.month, now.day, 10),
      endsAt: DateTime(now.year, now.month, now.day, 11),
      blockType: 'flexible',
    );
    var snapshot = await repository.loadToday();
    final block = snapshot.blocks.firstWhere(
      (candidate) => candidate.title == 'Flexible work',
    );
    await repository.addTaskToBlock(
      blockId: block.id,
      title: 'Optional polish',
      estimatedMinutes: 30,
      priority: 'low',
    );

    final result = await repository.reweaveToday(
      disruptionType: domain.DisruptionType.needBreak,
    );
    final reducePressure = result.alternatives.firstWhere(
      (alternative) =>
          alternative.strategy == domain.ReweaveStrategy.reducePressure,
    );
    expect(reducePressure.deferredTaskIds, isNotEmpty);

    await repository.applyReweaveAlternative(reducePressure);
    snapshot = await repository.loadToday();
    expect(snapshot.tasks.single.status, 'deferred');
    expect(snapshot.tasks.single.blockId, isNull);

    await repository.undoLastRevision();
    snapshot = await repository.loadToday();
    expect(snapshot.tasks.single.status, 'planned');
    expect(snapshot.tasks.single.blockId, block.id);
  });

  test(
    'confirmed reweave moves flexible blocks and undo restores timing',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalPlanningRepository(database);
      await repository.completeOnboarding(includeSampleData: false);
      final now = DateTime.now();

      await repository.addBlock(
        title: 'Protected meeting',
        startsAt: DateTime(now.year, now.month, now.day, 9),
        endsAt: DateTime(now.year, now.month, now.day, 10),
        blockType: 'fixed',
      );
      await repository.addBlock(
        title: 'Moveable work',
        startsAt: DateTime(now.year, now.month, now.day, 9, 30),
        endsAt: DateTime(now.year, now.month, now.day, 10, 30),
        blockType: 'flexible',
      );
      var snapshot = await repository.loadToday();
      final original = snapshot.blocks.firstWhere(
        (block) => block.title == 'Moveable work',
      );

      final result = await repository.reweaveToday(
        disruptionType: domain.DisruptionType.meetingOverran,
      );
      final balanced = result.alternatives.firstWhere(
        (alternative) =>
            alternative.strategy == domain.ReweaveStrategy.balancedReweave,
      );

      await repository.applyReweaveAlternative(balanced);
      snapshot = await repository.loadToday();
      final moved = snapshot.blocks.firstWhere(
        (block) => block.id == original.id,
      );
      expect(moved.startsAt, isNot(original.startsAt));
      expect(moved.startsAt.hour, 10);
      expect(moved.startsAt.minute, 10);

      await repository.undoLastRevision();
      snapshot = await repository.loadToday();
      final restored = snapshot.blocks.firstWhere(
        (block) => block.id == original.id,
      );
      expect(restored.startsAt, original.startsAt);
      expect(restored.endsAt, original.endsAt);
    },
  );
}
