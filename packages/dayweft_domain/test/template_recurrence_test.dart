import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

void main() {
  test('weekly occurrences respect inclusive boundaries and exceptions', () {
    final rule = TemplateRecurrence(
      weekdays: {DateTime.monday, DateTime.friday},
      startsOn: DateTime(2026, 10, 26, 22),
      endsOn: DateTime(2026, 11, 6, 1),
      exceptions: [DateTime(2026, 10, 30, 23)],
    );
    expect(rule.occursOn(DateTime(2026, 10, 23)), isFalse);
    expect(rule.occursOn(DateTime(2026, 10, 26)), isTrue);
    expect(rule.occursOn(DateTime(2026, 10, 30)), isFalse);
    expect(rule.occursOn(DateTime(2026, 11, 2)), isTrue);
    expect(rule.occursOn(DateTime(2026, 11, 3)), isFalse);
    expect(rule.occursOn(DateTime(2026, 11, 6, 23)), isTrue);
    expect(rule.occursOn(DateTime(2026, 11, 9)), isFalse);
  });

  test('weekday decisions use calendar components across clock changes', () {
    final rule = TemplateRecurrence(
      weekdays: {DateTime.sunday},
      startsOn: DateTime(2026, 3, 1),
    );
    expect(rule.occursOn(DateTime(2026, 3, 29, 23)), isTrue);
    expect(rule.occursOn(DateTime(2026, 3, 30)), isFalse);
    expect(rule.occursOn(DateTime.utc(2026, 10, 25, 23)), isTrue);
  });

  test('invalid weekdays and reversed date ranges are rejected', () {
    for (final days in [
      <int>{},
      {0},
      {8},
      {1, 9},
    ]) {
      expect(
        () => TemplateRecurrence(weekdays: days, startsOn: DateTime(2026)),
        throwsArgumentError,
      );
    }
    expect(
      () => TemplateRecurrence(
        weekdays: {1},
        startsOn: DateTime(2026, 2),
        endsOn: DateTime(2026, 1),
      ),
      throwsArgumentError,
    );
  });

  test('rule copies its inputs and exposes immutable collections', () {
    final weekdays = {1};
    final exceptions = [DateTime(2026, 1, 5)];
    final rule = TemplateRecurrence(
      weekdays: weekdays,
      startsOn: DateTime(2026),
      exceptions: exceptions,
    );
    weekdays.add(2);
    exceptions.clear();
    expect(rule.occursOn(DateTime(2026, 1, 5)), isFalse);
    expect(rule.occursOn(DateTime(2026, 1, 6)), isFalse);
    expect(() => rule.weekdays.add(3), throwsUnsupportedError);
    expect(() => rule.exceptions.clear(), throwsUnsupportedError);
  });
}
