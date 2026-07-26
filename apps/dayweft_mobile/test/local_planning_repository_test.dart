import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
