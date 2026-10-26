import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/timeline/presentation/today_timeline_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Finder field(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
);

void main() {
  late DayweftDatabase database;
  late LocalPlanningRepository repository;
  setUp(() async {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    final now = DateTime.now();
    for (final entry in [(10, 'Morning'), (12, 'Later')]) {
      await repository.addBlock(
        title: entry.$2,
        startsAt: DateTime(now.year, now.month, now.day, entry.$1),
        endsAt: DateTime(now.year, now.month, now.day, entry.$1 + 1),
        blockType: 'flexible',
        category: 'work',
      );
    }
  });
  tearDown(() async => database.close());
  Future<void> openTimeline(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: Scaffold(body: TodayTimelineScreen())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'dragging a task to another block updates local placement and can undo',
    (tester) async {
      final before = await repository.loadToday();
      await repository.addTaskToBlock(
        blockId: before.blocks.first.id,
        title: 'Drag this task',
        estimatedMinutes: 20,
      );
      await openTimeline(tester);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Drag this task')),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      await gesture.moveTo(tester.getCenter(find.text('Later')));
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(
        (await repository.loadToday()).tasks.single.blockId,
        before.blocks.last.id,
      );
      await tester.tap(find.byTooltip('Undo last change'));
      await tester.pumpAndSettle();
      expect(
        (await repository.loadToday()).tasks.single.blockId,
        before.blocks.first.id,
      );
    },
  );

  testWidgets('block buffer edits have visible before/after history and undo', (
    tester,
  ) async {
    await openTimeline(tester);
    await tester.tap(find.byTooltip('Block actions for Morning'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit or resize block'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Category (optional)'), 'study');
    tester.testTextInput.hide();
    await tester.ensureVisible(find.text('Travel, preparation and recovery'));
    await tester.tap(find.text('Travel, preparation and recovery'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(field('Recovery minutes'));
    await tester.enterText(field('Recovery minutes'), '10');
    tester.testTextInput.hide();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    var snapshot = await repository.loadToday();
    expect(snapshot.blocks.first.recoveryBufferMinutes, 10);
    expect(snapshot.blocks.first.category, 'study');
    final history = find.text(
      'Revision history (${snapshot.revisions.length})',
    );
    await tester.ensureVisible(history);
    await tester.tap(history);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edited block "Morning".'));
    await tester.pumpAndSettle();
    expect(find.text('Before: work\nAfter: study'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Undo last change'));
    await tester.pumpAndSettle();
    snapshot = await repository.loadToday();
    expect(snapshot.blocks.first.recoveryBufferMinutes, 0);
    expect(snapshot.blocks.first.category, 'work');
  });

  testWidgets(
    'block capture requires preview and preserves parsed attributes',
    (tester) async {
      await openTimeline(tester);
      await tester.tap(find.text('Add task').first);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'Read for 45m high priority low energy #study',
      );
      await tester.pumpAndSettle();
      expect(find.text('Category: study'), findsOneWidget);
      expect(find.text('Energy: low'), findsOneWidget);
      expect((await repository.loadToday()).tasks, isEmpty);
      tester.testTextInput.hide();
      await tester.ensureVisible(find.text('Confirm and add to block'));
      await tester.tap(find.text('Confirm and add to block'));
      await tester.pumpAndSettle();
      final task = (await repository.loadToday()).tasks.single;
      expect(task.estimatedMinutes, 45);
      expect(task.priority, 'high');
      expect(task.energyRequired, 'low');
      expect(task.category, 'study');
      expect(task.blockId, isNotNull);
    },
  );
}
