import 'dart:convert';

import 'package:dayweft_mobile/features/planning/application/revision_comparison.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('comparison exposes changed values and leaves unchanged fields out', () {
    final changes = compareRevision(
      jsonEncode({
        'task': {
          'title': 'Before',
          'estimatedMinutes': 20,
          'notes': null,
          'priority': 'high',
        },
        'after': {
          'title': 'After',
          'estimatedMinutes': 40,
          'notes': 'New notes',
          'priority': 'high',
        },
      }),
    );
    expect(changes.map((change) => change.label), [
      'Title',
      'Estimate',
      'Notes',
    ]);
    expect(changes[1].type, RevisionValueType.minutes);
    expect(changes[1].before, 20);
    expect(changes[1].after, 40);
  });
  test('block comparison retains before/after times and buffer changes', () {
    final changes = compareRevision(
      jsonEncode({
        'block': {
          'startsAt': '2026-10-26T09:00:00',
          'recoveryBufferMinutes': 0,
        },
        'after': {
          'startsAt': '2026-10-26T10:00:00',
          'recoveryBufferMinutes': 15,
        },
      }),
    );
    expect(changes.first.type, RevisionValueType.instant);
    expect(changes.last.label, 'Recovery buffer');
  });
  test(
    'legacy revisions without forward snapshots retain their reason-only view',
    () {
      expect(
        compareRevision('{"undo":"delete_task","taskId":"task"}'),
        isEmpty,
      );
      expect(compareRevision('[]'), isEmpty);
      expect(compareRevision('{"task":[],"after":{}}'), isEmpty);
    },
  );
}
