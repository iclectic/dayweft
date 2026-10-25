import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'onboarding saves overnight preferences without requesting access',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalPlanningRepository(database);
      await repository.completeOnboarding(
        includeSampleData: false,
        choices: const OnboardingPreferences(
          workingPattern: WorkingPattern.shift,
          wakeTime: '15:00',
          windDownTime: '08:00',
          workStartTime: '22:00',
          workEndTime: '06:00',
          calendarPreference: CalendarPreference.device,
          planningStyle: PlanningStyle.spacious,
        ),
      );
      final snapshot = await repository.loadToday();
      expect(snapshot.preferences.workingPattern, 'shift');
      expect(snapshot.preferences.workEndTime, '06:00');
      expect(snapshot.preferences.calendarPreference, 'device');
      expect(snapshot.preferences.planningStyle, 'spacious');
      expect(
        await database.select(database.calendarConnections).get(),
        isEmpty,
      );
      expect(snapshot.blocks, isEmpty);
    },
  );

  test('invalid choices leave onboarding incomplete', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await expectLater(
      repository.completeOnboarding(
        includeSampleData: false,
        choices: const OnboardingPreferences(wakeTime: '25:00'),
      ),
      throwsFormatException,
    );
    expect((await repository.ensurePreferences()).onboardingCompleted, isFalse);
  });

  test(
    'sample removal is reversible without losing personal task identity',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalPlanningRepository(database);
      await repository.completeOnboarding(includeSampleData: true);
      var snapshot = await repository.loadToday();
      final blockId = snapshot.blocks.single.id;
      await repository.addTaskToBlock(
        blockId: blockId,
        title: 'Personal work',
        estimatedMinutes: 20,
      );
      final taskId = (await repository.loadToday()).tasks.single.id;
      await repository.removeSampleData();
      await repository.undoLastRevision();
      snapshot = await repository.loadToday();
      expect(snapshot.blocks.single.id, blockId);
      expect(snapshot.tasks.single.id, taskId);
      expect(snapshot.tasks.single.blockId, blockId);
      expect(snapshot.preferences.sampleDataEnabled, isTrue);
      expect(snapshot.inboxTasks.single.sourceId, 'sample-data');
    },
  );

  test(
    'sample installation is idempotent and removal preserves personal work',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalPlanningRepository(database);
      await repository.completeOnboarding(includeSampleData: true);
      await repository.completeOnboarding(includeSampleData: true);
      var snapshot = await repository.loadToday();
      expect(snapshot.blocks, hasLength(1));
      expect(snapshot.inboxTasks, hasLength(1));
      await repository.addTaskToBlock(
        blockId: snapshot.blocks.single.id,
        title: 'My own work',
        estimatedMinutes: 20,
      );
      await repository.removeSampleData();
      snapshot = await repository.loadToday();
      expect(snapshot.blocks, isEmpty);
      expect(snapshot.inboxTasks.single.title, 'My own work');
      expect(snapshot.inboxTasks.single.status, 'inbox');
      expect(snapshot.preferences.sampleDataEnabled, isFalse);
      await repository.removeSampleData();
      expect(
        (await repository.loadToday()).inboxTasks.single.title,
        'My own work',
      );
    },
  );
}
