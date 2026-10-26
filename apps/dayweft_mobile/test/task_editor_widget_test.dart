import 'package:dayweft_design_system/dayweft_design_system.dart';
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/inbox/presentation/inbox_screen.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/tasks/presentation/task_editor_screen.dart';
import 'package:drift/native.dart';
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
    await repository.addInboxTask(title: 'Review notes');
  });
  tearDown(() async => database.close());

  Future<void> openInbox(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const MaterialApp(home: InboxScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('editing and cancelling preserve the expected local state', (
    tester,
  ) async {
    await openInbox(tester);
    await tester.tap(find.text('Review notes'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Task title'), 'Revised notes');
    await tester.enterText(field('Estimated minutes'), '45');
    tester.testTextInput.hide();
    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();
    expect(find.text('Revised notes'), findsOneWidget);
    expect(
      (await repository.loadToday()).inboxTasks.single.estimatedMinutes,
      45,
    );
    await tester.tap(find.text('Revised notes'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Task title'), 'Unsaved');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(
      (await repository.loadToday()).inboxTasks.single.title,
      'Revised notes',
    );
  });

  testWidgets('invalid estimates leave the draft visible and do not write', (
    tester,
  ) async {
    await openInbox(tester);
    await tester.tap(find.text('Review notes'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Estimated minutes'), '-5');
    tester.testTextInput.hide();
    await tester.tap(find.text('Save task'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Enter an estimate between 1 and 1440 minutes.'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(TaskEditorScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.byType(TaskEditorScreen), findsOneWidget);
    expect(
      (await repository.loadToday()).inboxTasks.single.estimatedMinutes,
      30,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('delete confirmation and one-tap undo restore the task', (
    tester,
  ) async {
    await openInbox(tester);
    await tester.tap(find.byTooltip('Task actions for Review notes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect((await repository.loadToday()).inboxTasks, hasLength(1));
    await tester.tap(find.byTooltip('Task actions for Review notes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect((await repository.loadToday()).inboxTasks, isEmpty);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Review notes'), findsOneWidget);
  });

  testWidgets('editor reflows at large text and exposes 48-point controls', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openInbox(tester);
    await tester.tap(find.text('Review notes'));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await tester.scrollUntilVisible(
      find.text('Predecessor tasks'),
      300,
      scrollable: find
          .descendant(
            of: find.byType(TaskEditorScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.drag(
      find
          .descendant(
            of: find.byType(TaskEditorScreen),
            matching: find.byType(Scrollable),
          )
          .first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Predecessor tasks'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  for (final dark in [false, true]) {
    testWidgets('task editor ${dark ? 'dark' : 'light'} golden', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final task = (await repository.loadToday()).inboxTasks.single;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
          child: MaterialApp(
            theme: dark ? DayweftTheme.dark() : DayweftTheme.light(),
            home: TaskEditorScreen(task: task),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/task_editor_${dark ? 'dark' : 'light'}.png'),
      );
    });
  }
}
