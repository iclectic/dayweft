import 'package:dayweft_design_system/dayweft_design_system.dart';
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/time/app_clock.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/templates/data/custom_template_repository.dart';
import 'package:dayweft_mobile/features/templates/presentation/custom_template_editor.dart';
import 'package:dayweft_mobile/features/templates/presentation/template_picker.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Clock implements AppClock {
  @override
  DateTime now() => DateTime(2026, 10, 29, 8);
}

const _block = TemplateBlock(
  title: 'Morning work',
  startTime: '09:00',
  endTime: '10:00',
  blockType: 'flexible',
  category: 'work',
);

void main() {
  late DayweftDatabase database;
  late CustomTemplateRepository templates;
  setUp(() {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    templates = CustomTemplateRepository(database);
  });
  tearDown(() => database.close());
  Finder field(String label) => find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.labelText == label,
  );
  Future<void> open(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dayweftDatabaseProvider.overrideWithValue(database),
          appClockProvider.overrideWithValue(_Clock()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showTemplatePicker(context),
                child: const Text('Templates'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Templates'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'create, review and apply a custom block through the actual editors',
    (tester) async {
      await open(tester);
      await tester.tap(find.text('Create template'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Template name'), 'My reusable morning');
      tester.testTextInput.hide();
      await tester.tap(find.text('Add template block'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Block title'), 'My morning work');
      tester.testTextInput.hide();
      await tester.tap(find.text('Use block'));
      await tester.pumpAndSettle();
      expect(await templates.loadAll(), isEmpty);
      await tester.tap(find.text('Save template'));
      await tester.pumpAndSettle();
      expect((await templates.loadAll()).single.name, 'My reusable morning');
      await tester.ensureVisible(find.text('My reusable morning'));
      await tester.tap(find.text('My reusable morning'));
      await tester.pumpAndSettle();
      final planning = LocalPlanningRepository(database, now: _Clock().now);
      expect((await planning.loadToday()).blocks, isEmpty);
      await tester.tap(find.text('Add selected blocks'));
      await tester.pumpAndSettle();
      expect(
        (await planning.loadToday()).blocks.single.title,
        'My morning work',
      );
    },
  );

  testWidgets(
    'rename and duplicate persist; cancel deletion leaves both templates',
    (tester) async {
      await templates.create(name: 'Original', blocks: [_block]);
      await open(tester);
      await tester.tap(find.byTooltip('Actions for Original'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit template'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Template name'), 'Renamed');
      tester.testTextInput.hide();
      await tester.tap(find.text('Save template'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Actions for Renamed'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Duplicate template'));
      await tester.pumpAndSettle();
      expect(
        (await templates.loadAll()).map((t) => t.name),
        containsAll(['Renamed', 'Renamed (copy)']),
      );
      await tester.tap(find.byTooltip('Actions for Renamed'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete template'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await templates.loadAll(), hasLength(2));
    },
  );

  testWidgets('delete undo still works after the template sheet is closed', (
    tester,
  ) async {
    final saved = await templates.create(
      name: 'Restore this',
      blocks: [_block],
    );
    await open(tester);
    await tester.tap(find.byTooltip('Actions for Restore this'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete template'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(await templates.loadAll(), isEmpty);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect((await templates.get(saved.id)).name, 'Restore this');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'save this day excludes task content and permits review before saving',
    (tester) async {
      final planning = LocalPlanningRepository(database, now: _Clock().now);
      await planning.addBlock(
        title: 'My block',
        startsAt: DateTime(2026, 10, 29, 9),
        endsAt: DateTime(2026, 10, 29, 10),
        blockType: 'fixed',
      );
      await planning.addTaskToBlock(
        blockId: (await planning.loadToday()).blocks.single.id,
        title: 'Private task content',
        estimatedMinutes: 20,
      );
      await open(tester);
      await tester.tap(find.text('Save this day'));
      await tester.pumpAndSettle();
      expect(find.text('My block'), findsOneWidget);
      expect(find.text('Private task content'), findsNothing);
      expect(await templates.loadAll(), isEmpty);
      await tester.enterText(field('Template name'), 'Saved day');
      tester.testTextInput.hide();
      await tester.tap(find.text('Save template'));
      await tester.pumpAndSettle();
      expect(
        (await templates.loadAll()).single.blocks.single.title,
        'My block',
      );
    },
  );

  testWidgets(
    'invalid name stays in the editor and cancel does not save draft',
    (tester) async {
      final original = await templates.create(
        name: 'Original',
        blocks: [_block],
      );
      await open(tester);
      await tester.tap(find.byTooltip('Actions for Original'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit template'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Template name'), '');
      tester.testTextInput.hide();
      await tester.tap(find.text('Save template'));
      await tester.pumpAndSettle();
      expect(find.byType(CustomTemplateEditor), findsOneWidget);
      expect((await templates.get(original.id)).name, 'Original');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect((await templates.get(original.id)).name, 'Original');
    },
  );

  testWidgets(
    'a stale editor preserves the newer saved template and the visible draft',
    (tester) async {
      final original = await templates.create(
        name: 'Original',
        blocks: [_block],
      );
      await open(tester);
      await tester.tap(find.byTooltip('Actions for Original'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit template'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Template name'), 'Stale draft');
      tester.testTextInput.hide();
      await templates.update(
        id: original.id,
        expectedVersion: 1,
        name: 'Newer saved edit',
        blocks: original.blocks,
      );
      await tester.tap(find.text('Save template'));
      await tester.pumpAndSettle();
      expect(find.byType(CustomTemplateEditor), findsOneWidget);
      expect(
        tester.widget<TextField>(field('Template name')).controller!.text,
        'Stale draft',
      );
      expect((await templates.get(original.id)).name, 'Newer saved edit');
      await tester.scrollUntilVisible(
        find.textContaining('This template changed.'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.textContaining('This template changed.'), findsOneWidget);
    },
  );

  testWidgets(
    'block buffer validation and editor controls work at 200% on a narrow dark screen',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
          child: MaterialApp(
            theme: DayweftTheme.dark(),
            home: const CustomTemplateEditor(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(field('Template name'), 'Accessible pattern');
      tester.testTextInput.hide();
      await tester.scrollUntilVisible(
        find.text('Add template block'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Add template block')),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add template block'));
      await tester.pumpAndSettle();
      await tester.enterText(field('Block title'), 'Work with buffers');
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      final dialogScroll = find
          .descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('Reserved buffers'),
        200,
        scrollable: dialogScroll,
      );
      await Scrollable.ensureVisible(
        tester.element(find.text('Reserved buffers')),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reserved buffers'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(field('Travel minutes'));
      await tester.enterText(field('Travel minutes'), '90');
      tester.testTextInput.hide();
      await tester.tap(find.text('Use block'));
      await tester.pumpAndSettle();
      expect(
        find.text('Reserved buffers must fit inside each template block.'),
        findsOneWidget,
      );
      await tester.ensureVisible(field('Travel minutes'));
      await tester.enterText(field('Travel minutes'), '10');
      tester.testTextInput.hide();
      await tester.tap(find.text('Use block'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await tester.tap(find.text('Save template'));
      await tester.pumpAndSettle();
      expect(
        (await templates.loadAll()).single.blocks.single.travelBufferMinutes,
        10,
      );
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
  );

  for (final dark in [false, true]) {
    testWidgets('custom template editor ${dark ? 'dark' : 'light'} golden', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final saved = await templates.create(
        name: 'My morning pattern',
        blocks: [_block],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
          child: MaterialApp(
            theme: dark ? DayweftTheme.dark() : DayweftTheme.light(),
            home: CustomTemplateEditor(template: saved),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/custom_template_editor_${dark ? 'dark' : 'light'}.png',
        ),
      );
    });
  }
}
