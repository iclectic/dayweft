import 'package:dayweft_mobile/app/bootstrap/dayweft_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dayweft app opens on Today Timeline', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DayweftApp()));
    await tester.pumpAndSettle();

    expect(find.text('Today Timeline'), findsWidgets);
    expect(find.text('Reweave My Day'), findsOneWidget);
    expect(find.textContaining('Reality Check'), findsOneWidget);
  });

  testWidgets('bottom navigation reaches settings', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DayweftApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Local-only mode'), findsOneWidget);
  });
}
