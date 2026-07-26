import 'package:dayweft_design_system/dayweft_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('themes use Material 3', () {
    expect(DayweftTheme.light().useMaterial3, isTrue);
    expect(DayweftTheme.dark().useMaterial3, isTrue);
  });

  testWidgets('thread divider exposes semantics', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ThreadDivider())),
    );

    expect(find.bySemanticsLabel('Timeline connection'), findsOneWidget);
  });
}
