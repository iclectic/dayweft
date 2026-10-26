import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DayweftDatabase database;
  late ProviderContainer container;
  late PlanningController controller;
  setUp(() async {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
    );
    controller = container.read(planningControllerProvider.notifier);
    await container.read(planningControllerProvider.future);
  });
  tearDown(() async {
    container.dispose();
    await database.close();
  });
  LocalDaySnapshot snapshot() =>
      container.read(planningControllerProvider).requireValue;

  test(
    'local onboarding, sample removal and preferences flow through real SQLite',
    () async {
      await controller.completeOnboarding(includeSampleData: true);
      expect(snapshot().preferences.sampleDataEnabled, isTrue);
      await controller.removeSampleData();
      expect(snapshot().blocks, isEmpty);
      await controller.updatePlanningPreferences(
        const OnboardingPreferences(wakeTime: '06:30'),
      );
      await controller.updatePlanningBuffers(
        preferredBreakMinutes: 30,
        contingencyMinutes: 45,
        transitionMinutes: 15,
      );
      await controller.reload();
      expect(snapshot().preferences.wakeTime, '06:30');
      expect(snapshot().preferences.transitionMinutes, 15);
    },
  );

  test(
    'capture, schedule, edit, measure, return, delete and undo refresh state offline',
    () async {
      await controller.completeOnboarding(includeSampleData: false);
      await controller.addInboxTask('Read');
      await controller.addInboxTasks(['Prepare']);
      await controller.addConfirmedCaptures([
        controller.parseCapture('Send notes for 20m #work'),
      ]);
      final original = snapshot().inboxTasks.first;
      await controller.updateTask(
        taskId: original.id,
        expectedVersion: original.localVersion,
        details: domain.TaskDetails(
          title: 'Read carefully',
          estimatedMinutes: 40,
        ),
      );
      final now = DateTime.now();
      await controller.addBlock(
        title: 'Morning',
        startsAt: DateTime(now.year, now.month, now.day, 9),
        endsAt: DateTime(now.year, now.month, now.day, 10),
        blockType: 'flexible',
      );
      final first = snapshot().blocks.single;
      await controller.addBlock(
        title: 'Later',
        startsAt: DateTime(now.year, now.month, now.day, 11),
        endsAt: DateTime(now.year, now.month, now.day, 12),
        blockType: 'optional',
      );
      final second = snapshot().blocks.last;
      await controller.moveInboxTaskToBlock(
        taskId: original.id,
        blockId: first.id,
      );
      await controller.movePlannedTaskToBlock(
        taskId: original.id,
        blockId: second.id,
      );
      await controller.toggleTask(original.id);
      await controller.recordTaskActualDuration(original.id, actualMinutes: 50);
      final records = await container
          .read(localPlanningRepositoryProvider)
          .loadEstimationRecords();
      await controller.excludeEstimationRecord(
        records.single.id,
        excluded: true,
      );
      await controller.deleteEstimationRecord(records.single.id);
      await controller.returnTaskToInbox(
        original.id,
        expectedVersion: snapshot().tasks.single.localVersion,
      );
      final inboxTask = snapshot().inboxTasks.firstWhere(
        (task) => task.id == original.id,
      );
      await controller.deleteTask(
        original.id,
        expectedVersion: inboxTask.localVersion,
      );
      await controller.undoLastRevision();
      expect(
        snapshot().inboxTasks
            .firstWhere((task) => task.id == original.id)
            .status,
        'completed',
      );
      await controller.addTaskToBlock(
        blockId: first.id,
        title: 'Work',
        estimatedMinutes: 20,
      );
      await controller.updateBlock(
        blockId: second.id,
        title: 'Afternoon',
        startsAt: second.startsAt,
        endsAt: second.endsAt,
        blockType: 'flexible',
        recoveryBufferMinutes: 10,
      );
      await controller.moveBlock(blockId: second.id, direction: -1);
      await controller.reorderBlockToIndex(blockId: second.id, newIndex: 1);
      final exported = await controller.exportLocalData();
      await controller.importLocalData(exported);
      expect(snapshot().blocks, hasLength(4));
      await controller.deleteBlock(first.id);
      expect(snapshot().blocks.any((block) => block.id == first.id), isFalse);
    },
  );

  test(
    'recovery confirmation and learning controls keep local state coherent',
    () async {
      await controller.completeOnboarding(includeSampleData: false);
      await controller.applyTemplate(dayweftTemplates.first);
      await controller.realityCheckToday();
      final result = await controller.reweaveToday(
        disruptionType: domain.DisruptionType.custom,
      );
      await controller.applyReweaveAlternative(result.alternatives.first);
      await controller.undoLastRevision();
      await controller.setEnergyEnabled(true);
      await controller.recordEnergyCheckIn('steady');
      await controller.completeFocusSession(
        title: 'Local focus',
        plannedMinutes: 25,
        actualMinutes: 10,
        interruptionCount: 1,
      );
      expect((await controller.loadRhythmSummary()).totalFocusMinutes, 10);
      await controller.deleteLearningHistory();
      expect((await controller.loadRhythmSummary()).latestEnergyLevel, isNull);
      await controller.createLocalAvailabilityShare();
      await controller.revokeLocalShares();
      await controller.markCalendarPermission('not_requested');
      expect(
        (await database.select(database.shareLinks).getSingle()).revokedAt,
        isNotNull,
      );
    },
  );
}
