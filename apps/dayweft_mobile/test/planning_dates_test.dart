import 'package:dayweft_mobile/core/config/app_configuration.dart';
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/core/time/app_clock.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/application/planning_date.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FixedClock implements AppClock {
  FixedClock(this.value);
  DateTime value;
  @override
  DateTime now() => value;
}

void main() {
  test('all environments start locally and unknown names fail explicitly', () {
    for (final value in AppEnvironment.values) {
      expect(AppConfiguration.fromName(value.name).environment, value);
    }
    expect(() => AppConfiguration.fromName('prodution'), throwsArgumentError);
  });

  test('civil navigation crosses months and leap years', () {
    expect(adjacentDate(DateTime(2028, 3, 1), -1), DateTime(2028, 2, 29));
    expect(adjacentDate(DateTime(2026, 12, 31), 1), DateTime(2027));
    expect(civilDate(DateTime(2026, 10, 25, 23)), DateTime(2026, 10, 25));
  });

  test(
    'dates isolate blocks, history and undo through the real controller',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      final clock = FixedClock(DateTime(2026, 10, 26, 8));
      final container = ProviderContainer(
        overrides: [
          dayweftDatabaseProvider.overrideWithValue(database),
          appClockProvider.overrideWithValue(clock),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await database.close();
      });
      await container.read(planningControllerProvider.future);
      final controller = container.read(planningControllerProvider.notifier);
      await controller.completeOnboarding(includeSampleData: false);
      await controller.addInboxTask('Available on any day');
      await controller.addBlock(
        title: 'Monday',
        startsAt: DateTime(2026, 10, 26, 9),
        endsAt: DateTime(2026, 10, 26, 10),
        blockType: 'fixed',
      );
      final monday = container.read(planningControllerProvider).requireValue;

      container.read(planningDateProvider.notifier).move(1);
      var tuesday = await container.read(planningControllerProvider.future);
      expect(tuesday.plan.day, DateTime(2026, 10, 27));
      expect(tuesday.blocks, isEmpty);
      expect(tuesday.revisions, isEmpty);
      expect(tuesday.inboxTasks.single.title, 'Available on any day');
      await controller.addBlock(
        title: 'Tuesday night',
        startsAt: DateTime(2026, 10, 27, 23),
        endsAt: DateTime(2026, 10, 28, 1),
        blockType: 'fixed',
      );
      tuesday = container.read(planningControllerProvider).requireValue;
      final reopened = LocalPlanningRepository(
        database,
        now: clock.now,
        planningDate: DateTime(2026, 10, 27),
      );
      expect(
        (await reopened.loadSelectedDay()).blocks.single.id,
        tuesday.blocks.single.id,
      );
      expect(await controller.undoLastRevision(), isTrue);

      container.read(planningDateProvider.notifier).today();
      final restored = await container.read(planningControllerProvider.future);
      expect(restored.plan.id, monday.plan.id);
      expect(restored.blocks.single.title, 'Monday');
      expect(restored.revisions, hasLength(monday.revisions.length));
      expect(restored.undoneRevisionIds, isEmpty);
    },
  );

  test(
    'selected-date writes reject mismatched dates without inserting data',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalPlanningRepository(
        database,
        planningDate: DateTime(2026, 10, 27),
        now: () => DateTime(2026, 10, 26),
      );
      await expectLater(
        repository.addBlock(
          title: 'Wrong day',
          startsAt: DateTime(2026, 10, 26, 9),
          endsAt: DateTime(2026, 10, 26, 10),
          blockType: 'flexible',
        ),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.loadSelectedDay()).blocks, isEmpty);
    },
  );
}
