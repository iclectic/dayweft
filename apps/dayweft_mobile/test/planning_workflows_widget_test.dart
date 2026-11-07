import 'dart:convert';

import 'package:dayweft_design_system/dayweft_design_system.dart';
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/time/app_clock.dart';
import 'package:dayweft_mobile/features/data_management/presentation/day_import_dialog.dart';
import 'package:dayweft_mobile/features/planning/application/planning_date.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/templates/presentation/template_picker.dart';
import 'package:dayweft_mobile/features/timeline/presentation/today_timeline_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Clock implements AppClock {
  @override
  DateTime now() => DateTime(2026, 10, 29, 8);
}

void main() {
  late DayweftDatabase database;
  late LocalPlanningRepository repository;
  setUp(() async {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    repository = LocalPlanningRepository(database, now: _Clock().now);
    await repository.completeOnboarding(includeSampleData: false);
  });
  tearDown(() => database.close());

  Future<void> open(
    WidgetTester tester, {
    bool timeline = false,
    bool largeText = false,
  }) async {
    await tester.binding.setSurfaceSize(Size(largeText ? 320 : 420, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dayweftDatabaseProvider.overrideWithValue(database),
          appClockProvider.overrideWithValue(_Clock()),
        ],
        child: MaterialApp(
          theme: largeText ? DayweftTheme.dark() : DayweftTheme.light(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(largeText ? 2 : 1)),
            child: child!,
          ),
          home: timeline
              ? const Scaffold(body: TodayTimelineScreen())
              : Scaffold(
                  body: Builder(
                    builder: (context) => Column(
                      children: [
                        TextButton(
                          onPressed: () => showTemplatePicker(context),
                          child: const Text('Open templates'),
                        ),
                        TextButton(
                          onPressed: () => showDayImportDialog(context),
                          child: const Text('Open import'),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  );

  testWidgets(
    'date navigation saves a new block on the selected day and isolates undo',
    (tester) async {
      await repository.addBlock(
        title: 'Original appointment',
        startsAt: DateTime(2026, 10, 29, 9),
        endsAt: DateTime(2026, 10, 29, 10),
        blockType: 'fixed',
      );
      await open(tester, timeline: true);
      await tester.tap(find.byTooltip('Next day'));
      await tester.pumpAndSettle();
      expect(find.text('Original appointment'), findsNothing);
      await tester.ensureVisible(find.text('Add block'));
      await tester.tap(find.text('Add block'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Block title'), 'Tomorrow work');
      tester.testTextInput.hide();
      await tester.tap(find.text('Save block'));
      await tester.pumpAndSettle();
      expect(
        (await repository.loadDay(DateTime(2026, 10, 30))).blocks.single.title,
        'Tomorrow work',
      );
      await tester.tap(find.byTooltip('Undo last change'));
      await tester.pumpAndSettle();
      expect(
        (await repository.loadDay(DateTime(2026, 10, 30))).blocks,
        isEmpty,
      );
      await tester.tap(find.text('Return to today'));
      await tester.pumpAndSettle();
      expect(find.text('Original appointment'), findsOneWidget);
      expect((await repository.loadToday()).undoneRevisionIds, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  Future<void> workday(WidgetTester tester) async {
    await tester.tap(find.text('Open templates'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Workday'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await Scrollable.ensureVisible(
      tester.element(find.text('Workday')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workday'));
    await tester.pumpAndSettle();
  }

  testWidgets('template selection only applies confirmed blocks and can undo', (
    tester,
  ) async {
    await open(tester);
    await workday(tester);
    expect((await repository.loadToday()).blocks, isEmpty);
    for (final title in ['Deep work', 'Admin wrap-up']) {
      final tile = find.widgetWithText(CheckboxListTile, title);
      await tester.ensureVisible(tile);
      await tester.tap(tile);
    }
    await tester.tap(find.text('Add selected blocks'));
    await tester.pumpAndSettle();
    expect((await repository.loadToday()).blocks.single.title, 'Plan the day');
    await repository.undoLastRevision();
    expect((await repository.loadToday()).blocks, isEmpty);
  });

  testWidgets('cancelling template preview never changes the plan', (
    tester,
  ) async {
    await open(tester);
    await workday(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect((await repository.loadToday()).blocks, isEmpty);
    expect((await repository.loadToday()).revisions, isEmpty);
  });

  testWidgets('stale template error stays reviewable and preserves later work', (
    tester,
  ) async {
    await open(tester);
    await workday(tester);
    await repository.addInboxTask(title: 'Captured after preview');
    await tester.tap(find.text('Add selected blocks'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'The plan or planning preferences changed. Review a new template preview.',
      ),
      findsOneWidget,
    );
    expect((await repository.loadToday()).blocks, isEmpty);
    expect(
      (await repository.loadToday()).inboxTasks.single.title,
      'Captured after preview',
    );
  });

  String export() => jsonEncode({
    'product': 'Dayweft',
    'schemaVersion': 1,
    'plan': {'day': '2026-10-28T00:00:00.000'},
    'blocks': [
      {
        'id': 'block-a',
        'title': 'Imported appointment',
        'startsAt': '2026-10-28T10:00:00.000',
        'endsAt': '2026-10-28T11:00:00.000',
        'blockType': 'fixed',
      },
    ],
    'tasks': [
      {
        'id': 'task-a',
        'title': 'Imported capture',
        'estimatedMinutes': 20,
        'priority': 'medium',
        'status': 'inbox',
      },
    ],
  });

  testWidgets(
    'import validation preserves the draft and cancel is non-mutating',
    (tester) async {
      await open(tester);
      await tester.tap(find.text('Open import'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Dayweft JSON'), '{broken');
      await tester.tap(find.text('Review import'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(field('Dayweft JSON')).controller!.text,
        '{broken',
      );
      expect(find.byType(DayImportDialog), findsOneWidget);
      await tester.enterText(field('Dayweft JSON'), export());
      tester.testTextInput.hide();
      await tester.tap(find.text('Review import'));
      await tester.pumpAndSettle();
      expect(find.text('Review day import'), findsOneWidget);
      expect(
        (await repository.loadDay(DateTime(2026, 10, 28))).blocks,
        isEmpty,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(
        (await repository.loadDay(DateTime(2026, 10, 28))).blocks,
        isEmpty,
      );
    },
  );

  testWidgets(
    'confirmed import switches date and rejects a repeated batch in UI',
    (tester) async {
      await open(tester);
      for (var attempt = 0; attempt < 2; attempt++) {
        await tester.tap(find.text('Open import'));
        await tester.pumpAndSettle();
        await tester.enterText(field('Dayweft JSON'), export());
        tester.testTextInput.hide();
        await tester.tap(find.text('Review import'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm import'));
        await tester.pumpAndSettle();
        if (attempt == 0) {
          expect(find.byType(DayImportDialog), findsNothing);
          final container = ProviderScope.containerOf(
            tester.element(find.text('Open import')),
          );
          expect(container.read(planningDateProvider), DateTime(2026, 10, 28));
        } else {
          expect(
            find.text(
              'This day export has already been imported. Undo that import before importing it again.',
            ),
            findsOneWidget,
          );
        }
      }
      expect(
        (await repository.loadDay(DateTime(2026, 10, 28))).blocks,
        hasLength(1),
      );
      expect((await repository.loadToday()).inboxTasks, hasLength(1));
    },
  );

  testWidgets(
    'template preview remains usable with 200% text on a narrow dark screen',
    (tester) async {
      await open(tester, largeText: true);
      await workday(tester);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect((await repository.loadToday()).blocks, isEmpty);
    },
  );
}
