import 'package:dayweft_mobile/app/bootstrap/dayweft_app.dart';
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onboarding has a stable local-first golden', (tester) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(DayweftApp),
      matchesGoldenFile('goldens/onboarding_local_first.png'),
    );
  });

  testWidgets('Dayweft app starts with local-first onboarding', (tester) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Calm Time'), findsOneWidget);
    expect(find.text('Local first'), findsOneWidget);
    expect(find.text('Skip setup'), findsOneWidget);
  });

  testWidgets('Dayweft app opens on Today Timeline after onboarding', (
    tester,
  ) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = LocalPlanningRepository(database);
    await repository.completeOnboarding(includeSampleData: false);
    final now = DateTime.now();
    await repository.addBlock(
      title: 'Accessible planning block',
      startsAt: DateTime(now.year, now.month, now.day, 10),
      endsAt: DateTime(now.year, now.month, now.day, 11),
      blockType: 'flexible',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today Timeline'), findsWidgets);
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add block'), findsOneWidget);
    expect(find.text('Reweave My Day'), findsOneWidget);
    expect(find.text('Reality Check'), findsOneWidget);
  });

  testWidgets('bottom navigation reaches settings', (tester) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await LocalPlanningRepository(
      database,
    ).completeOnboarding(includeSampleData: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Local-only mode'), findsOneWidget);
    expect(find.text('Preferred break'), findsOneWidget);
    expect(find.text('Contingency time'), findsOneWidget);
    final dataExport = find.text('Data export', skipOffstage: false);
    expect(dataExport, findsOneWidget);
    await tester.ensureVisible(dataExport);
    await tester.pumpAndSettle();
    expect(
      find.text('Share availability', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text('Calendar permission', skipOffstage: false),
      findsOneWidget,
    );
  });

  testWidgets('bottom navigation reaches Quiet Focus and Your Rhythm', (
    tester,
  ) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await LocalPlanningRepository(
      database,
    ).completeOnboarding(includeSampleData: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Focus'));
    await tester.pumpAndSettle();
    expect(find.text('Quiet Focus'), findsWidgets);
    expect(find.text('Log interruption (0)'), findsOneWidget);

    await tester.tap(find.text('Rhythm'));
    await tester.pumpAndSettle();
    expect(find.text('Your Rhythm'), findsWidgets);
    expect(find.text('Estimate evidence'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Latest energy check-in'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Latest energy check-in'), findsOneWidget);
  });

  testWidgets('onboarding exposes accessible local-first controls', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Local first'), findsOneWidget);
    expect(find.text('Skip setup'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNothing);
    semantics.dispose();
  });

  testWidgets('every onboarding preference step can be skipped offline', (
    tester,
  ) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Your working pattern'), findsOneWidget);
    for (var step = 0; step < 3; step++) {
      await tester.ensureVisible(find.text('Skip this step'));
      await tester.tap(find.text('Skip this step'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Try a sample day'), findsOneWidget);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isFalse,
    );
    await tester.tap(find.text('Start locally'));
    await tester.pumpAndSettle();
    final snapshot = await LocalPlanningRepository(database).loadToday();
    expect(snapshot.preferences.onboardingCompleted, isTrue);
    expect(snapshot.blocks, isEmpty);
    expect(await database.select(database.calendarConnections).get(), isEmpty);
  });

  testWidgets('skipping samples preserves earlier working-pattern choices', (
    tester,
  ) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flexible or mixed hours'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shift work').last);
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.ensureVisible(find.text('Continue'));
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Skip sample data'));
    await tester.pumpAndSettle();
    final preferences = await LocalPlanningRepository(
      database,
    ).ensurePreferences();
    expect(preferences.workingPattern, 'shift');
    expect(preferences.sampleDataEnabled, isFalse);
  });

  testWidgets(
    'capture confirmation saves displayed values and back cancels drafts',
    (tester) async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = LocalPlanningRepository(database);
      await repository.completeOnboarding(includeSampleData: false);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
          child: const DayweftApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inbox').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Quick capture'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'Read tomorrow around 2pm for 90m high priority low energy #study',
      );
      await tester.pumpAndSettle();
      expect(find.text('Category: study'), findsOneWidget);
      expect(find.text('Energy: low'), findsOneWidget);
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Confirm and add to Inbox'));
      await tester.tap(find.text('Confirm and add to Inbox'));
      await tester.pumpAndSettle();
      final task = (await repository.loadToday()).inboxTasks.single;
      expect(task.estimatedMinutes, 90);
      expect(task.energyRequired, 'low');
      expect(task.priority, 'high');
      await tester.tap(find.text('Quick capture'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Leave this as a draft');
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect((await repository.loadToday()).inboxTasks, hasLength(1));
    },
  );

  testWidgets('onboarding reflows at large text and exposes sized targets', (
    tester,
  ) async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final semantics = tester.ensureSemantics();
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
        child: const DayweftApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Skip setup'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await tester.ensureVisible(find.text('Skip setup'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip setup'));
    await tester.pumpAndSettle();
    semantics.dispose();
    expect(
      (await LocalPlanningRepository(
        database,
      ).ensurePreferences()).onboardingCompleted,
      isTrue,
    );
  });
}
