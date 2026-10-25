import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

void main() {
  const parser = LocalCaptureParser();
  final reference = DateTime(2026, 10, 24, 9);
  test('English grammar parses all supported fields offline', () {
    final result = parser.parse(
      'Read chapter tomorrow around 2pm for 1.5h high priority low energy #study',
      reference: reference,
    );
    expect(result.title, 'Read chapter');
    expect(result.estimatedMinutes, 90);
    expect(result.priority, TaskPriority.high);
    expect(result.energy, EnergyLevel.low);
    expect(result.category, 'study');
    expect(result.day, DateTime(2026, 10, 25));
    expect(result.startTime, '14:00');
    expect(result.approximate, isTrue);
  });
  test('range meridiem is inferred consistently', () {
    final result = parser.parse(
      'Review 9-10pm for 45 min',
      reference: reference,
    );
    expect(result.startTime, '21:00');
    expect(result.endTime, '22:00');
    expect(result.estimatedMinutes, 45);
  });
  test(
    'due date and explicit deadline are distinguished from preferred time',
    () {
      final result = parser.parse(
        'Send notes due tomorrow by 5pm',
        reference: reference,
      );
      expect(result.deadline, DateTime(2026, 10, 25, 17));
      expect(result.day, isNull);
      expect(result.startTime, isNull);
    },
  );
  test('invalid values remain visible instead of silently normalising', () {
    final result = parser.parse(
      'Meet on 2026-02-30 at 25:99 for 0m',
      reference: reference,
    );
    expect(result.day, isNull);
    expect(result.startTime, isNull);
    expect(result.title, contains('2026-02-30'));
    expect(result.title, contains('25:99'));
    expect(result.title, contains('0m'));
    expect(result.warnings, hasLength(3));
  });
  test('overnight range and midnight retain intent', () {
    final result = parser.parse(
      'Shift tomorrow 10pm-1am',
      reference: reference,
    );
    expect(result.startTime, '22:00');
    expect(result.endTime, '01:00');
    expect(
      parser.parse('Call at 12am', reference: reference).startTime,
      '00:00',
    );
    expect(
      parser.parse('Call at 12pm', reference: reference).startTime,
      '12:00',
    );
  });
  test('weekdays and unknown text do not invent extra fields', () {
    final result = parser.parse('Call Monday', reference: reference);
    expect(result.day, DateTime(2026, 10, 26));
    expect(
      parser.parse('A thought without a time', reference: reference).title,
      'A thought without a time',
    );
    expect(() => parser.parse('', reference: reference), throwsFormatException);
    expect(
      () => parser.parse('a' * 16001, reference: reference),
      throwsFormatException,
    );
  });
}
