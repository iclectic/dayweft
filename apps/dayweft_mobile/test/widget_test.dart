import 'package:dayweft_mobile/app/bootstrap/dayweft_app.dart';
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

    expect(find.text('Dayweft: Adaptive Day Planner'), findsOneWidget);
    expect(find.text('Local first'), findsOneWidget);
    expect(find.text('Start locally'), findsOneWidget);
  });

  testWidgets('Dayweft app opens on Today Timeline after onboarding', (
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

    expect(find.text('Today Timeline'), findsWidgets);
    expect(find.text('Add block'), findsOneWidget);
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
  });
}
