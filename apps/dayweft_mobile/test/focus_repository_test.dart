import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/quiet_focus/application/focus_controller.dart';
import 'package:dayweft_mobile/features/quiet_focus/data/focus_repository.dart';
import 'package:dayweft_mobile/features/quiet_focus/domain/focus_time.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeFocusTime implements FocusTimeSource {
  DateTime wall = DateTime(2026, 10, 27, 9);
  int ticks = 100000;
  String boot = 'boot-1';
  void advance(int seconds) {
    ticks += seconds * 1000;
    wall = wall.add(Duration(seconds: seconds));
  }

  @override
  Future<FocusTimeReading> read() async => FocusTimeReading(
    wallTime: wall,
    monotonicMilliseconds: ticks,
    bootToken: boot,
  );
}

void main() {
  late DayweftDatabase database;
  late FakeFocusTime time;
  late FocusRepository repository;
  setUp(() {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    time = FakeFocusTime();
    repository = FocusRepository(database, time);
  });
  tearDown(() => database.close());

  test(
    'active countdown survives repository recreation, wall changes and background gaps',
    () async {
      final first = await repository.start(
        title: 'Work',
        mode: FocusMode.countdown,
        plannedMinutes: 25,
      );
      time.advance(65);
      time.wall = time.wall.subtract(const Duration(hours: 3));
      final restored = (await FocusRepository(database, time).loadActive())!;
      expect(restored.session.id, first.session.id);
      expect(restored.elapsedMilliseconds, 65000);
      expect(restored.displayedSeconds, 25 * 60 - 65);
      expect(restored.version, first.version);
    },
  );

  test(
    'pause excludes suspended time; resume and interruption are durable',
    () async {
      var current = await repository.start(
        title: 'Work',
        mode: FocusMode.countUp,
      );
      time.advance(60);
      current = await repository.pause(current.session.id, current.version);
      time.advance(600);
      expect((await repository.loadActive())!.elapsedMilliseconds, 60000);
      current = await repository.resume(current.session.id, current.version);
      time.advance(30);
      current = await repository.interrupt(current.session.id, current.version);
      expect(current.elapsedMilliseconds, 90000);
      expect(
        (await FocusRepository(
          database,
          time,
        ).loadActive())!.session.interruptionCount,
        1,
      );
    },
  );

  test('reboot pauses for review and never counts unknown time', () async {
    await repository.start(title: 'Work', mode: FocusMode.countUp);
    time.advance(65);
    await repository.checkpoint();
    time.advance(4000);
    time.boot = 'boot-2';
    time.ticks = 100;
    var current = (await repository.loadActive())!;
    expect(current.session.status, 'needsReview');
    expect(current.elapsedMilliseconds, 65000);
    current = await repository.resume(current.session.id, current.version);
    time.advance(10);
    expect((await repository.loadActive())!.elapsedMilliseconds, 75000);
  });

  test(
    'countdown caps at target and abandon retains actual measured record',
    () async {
      await repository.start(
        title: 'Work',
        mode: FocusMode.countdown,
        plannedMinutes: 1,
      );
      time.advance(300);
      final current = (await repository.loadActive())!;
      expect(current.session.status, 'ready');
      expect(current.elapsedMilliseconds, 60000);
      await repository.finish(
        current.session.id,
        current.version,
        abandoned: true,
      );
      expect(await repository.loadActive(), isNull);
      final saved = await database.select(database.focusSessions).getSingle();
      expect(saved.status, 'abandoned');
      expect(saved.actualMinutes, 1);
      expect(saved.endedAt, isNotNull);
    },
  );

  test(
    'concurrent starts and stale commands cannot create or erase sessions',
    () async {
      final current = await repository.start(
        title: 'Work',
        mode: FocusMode.countUp,
      );
      await expectLater(
        repository.start(title: 'Other', mode: FocusMode.countUp),
        throwsA(isA<PlanningFailure>()),
      );
      await repository.pause(current.session.id, current.version);
      await expectLater(
        repository.resume(current.session.id, current.version),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.loadActive())!.session.status, 'paused');
      expect(await database.select(database.focusSessions).get(), hasLength(1));
    },
  );

  test(
    'sub-minute completion never fabricates a whole minute of evidence',
    () async {
      final planning = LocalPlanningRepository(database, now: () => time.wall);
      await planning.addInboxTask(title: 'Read');
      final task = (await planning.loadToday()).inboxTasks.single;
      final current = await repository.start(
        title: 'Read',
        mode: FocusMode.countUp,
        taskId: task.id,
      );
      time.advance(10);
      await repository.finish(
        current.session.id,
        current.version,
        completeTask: true,
      );
      expect((await planning.loadToday()).inboxTasks.single.actualMinutes, 0);
      expect(await planning.loadEstimationRecords(), isEmpty);
      expect(
        (await database.select(database.focusSessionStates).getSingle())
            .elapsedMilliseconds,
        10000,
      );
    },
  );

  test(
    'task completion uses summed eligible focus time rather than the estimate',
    () async {
      final planning = LocalPlanningRepository(database, now: () => time.wall);
      await planning.addInboxTask(title: 'Read', estimatedMinutes: 30);
      final task = (await planning.loadToday()).inboxTasks.single;
      var current = await repository.start(
        title: 'Read',
        mode: FocusMode.countUp,
        taskId: task.id,
      );
      time.advance(120);
      await repository.finish(current.session.id, current.version);
      current = await repository.start(
        title: 'Read',
        mode: FocusMode.countUp,
        taskId: task.id,
      );
      time.advance(180);
      await repository.finish(
        current.session.id,
        current.version,
        completeTask: true,
      );
      expect((await planning.loadToday()).inboxTasks.single.actualMinutes, 5);
      final evidence = (await planning.loadEstimationRecords()).single;
      expect(evidence.actualMinutes, 5);
      expect(evidence.estimatedMinutes, 30);
      expect(evidence.measurementSource, 'focus');
      await planning.undoLastRevision();
      final undone = (await planning.loadToday()).inboxTasks.single;
      expect(undone.status, 'inbox');
      expect(undone.actualMinutes, isNull);
      expect(await planning.loadEstimationRecords(), isEmpty);
    },
  );

  test(
    'restart retains abandoned session and starts a new measured interval',
    () async {
      final current = await repository.start(
        title: 'Work',
        mode: FocusMode.countUp,
      );
      time.advance(70);
      final restarted = await repository.restart(
        current.session.id,
        current.version,
      );
      expect(restarted.session.id, isNot(current.session.id));
      expect(restarted.elapsedMilliseconds, 0);
      final sessions = await database.select(database.focusSessions).get();
      expect(
        sessions.where((row) => row.status == 'abandoned').single.actualMinutes,
        1,
      );
      expect(sessions.where((row) => row.status == 'running'), hasLength(1));
    },
  );

  test('deleted learning cannot be restored by later focus undo', () async {
    final planning = LocalPlanningRepository(database, now: () => time.wall);
    await planning.addInboxTask(title: 'Work');
    final task = (await planning.loadToday()).inboxTasks.single;
    var current = await repository.start(
      title: 'Work',
      mode: FocusMode.countUp,
      taskId: task.id,
    );
    time.advance(120);
    await repository.finish(
      current.session.id,
      current.version,
      completeTask: true,
    );
    await planning.toggleTask(task.id);
    current = await repository.start(
      title: 'Work',
      mode: FocusMode.countUp,
      taskId: task.id,
    );
    time.advance(120);
    await repository.finish(
      current.session.id,
      current.version,
      completeTask: true,
    );
    await planning.deleteLearningHistory();
    await planning.undoLastRevision();
    expect(await planning.loadEstimationRecords(), isEmpty);
  });

  test('controller commands persist through Riverpod to real SQLite', () async {
    final container = ProviderContainer(
      overrides: [
        dayweftDatabaseProvider.overrideWithValue(database),
        focusTimeSourceProvider.overrideWithValue(time),
      ],
    );
    addTearDown(container.dispose);
    await container.read(focusControllerProvider.future);
    final controller = container.read(focusControllerProvider.notifier);
    await controller.start(title: 'Work', mode: FocusMode.countUp, minutes: 25);
    time.advance(60);
    await controller.refresh();
    await controller.pause();
    await controller.resume();
    await controller.interrupt();
    await controller.refresh(checkpoint: true);
    expect(
      container.read(focusControllerProvider).requireValue!.elapsedMilliseconds,
      60000,
    );
    await controller.restart();
    expect(
      container.read(focusControllerProvider).requireValue!.elapsedMilliseconds,
      0,
    );
    await controller.finish(abandoned: true);
    expect(container.read(focusControllerProvider).requireValue, isNull);
  });
}
