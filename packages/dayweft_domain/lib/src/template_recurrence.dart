/// A weekly rule evaluated on civil dates, independently of elapsed time.
///
/// Exceptions suppress an occurrence; they never alter an existing plan.
class TemplateRecurrence {
  TemplateRecurrence({
    required Set<int> weekdays,
    required DateTime startsOn,
    DateTime? endsOn,
    Iterable<DateTime> exceptions = const [],
  }) : weekdays = Set.unmodifiable(weekdays),
       startsOn = _civilDate(startsOn),
       endsOn = endsOn == null ? null : _civilDate(endsOn),
       exceptions = Set.unmodifiable(exceptions.map(_civilDate)) {
    if (weekdays.isEmpty || weekdays.any((day) => day < 1 || day > 7)) {
      throw ArgumentError.value(weekdays, 'weekdays', 'Choose weekdays 1–7.');
    }
    if (this.endsOn != null && this.endsOn!.isBefore(this.startsOn)) {
      throw ArgumentError('The end date must not precede the start date.');
    }
  }

  /// ISO weekdays: Monday is 1 and Sunday is 7.
  final Set<int> weekdays;
  final DateTime startsOn;
  final DateTime? endsOn;
  final Set<DateTime> exceptions;

  bool occursOn(DateTime date) {
    final day = _civilDate(date);
    return !day.isBefore(startsOn) &&
        (endsOn == null || !day.isAfter(endsOn!)) &&
        weekdays.contains(day.weekday) &&
        !exceptions.contains(day);
  }
}

// UTC is used only as a stable representation of the supplied calendar
// components, not as the time or timezone of an occurrence.
DateTime _civilDate(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day);
