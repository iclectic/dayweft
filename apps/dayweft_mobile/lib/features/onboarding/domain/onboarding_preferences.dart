enum WorkingPattern { regular, flexible, shift, study, caring }

enum CalendarPreference { later, device }

enum PlanningStyle { structured, balanced, spacious }

/// Local choices only: choosing a calendar never requests OS access here.
class OnboardingPreferences {
  const OnboardingPreferences({
    this.workingPattern = WorkingPattern.flexible,
    this.wakeTime = '07:00',
    this.windDownTime = '22:00',
    this.workStartTime = '09:00',
    this.workEndTime = '17:00',
    this.calendarPreference = CalendarPreference.later,
    this.planningStyle = PlanningStyle.balanced,
  });

  final WorkingPattern workingPattern;
  final String wakeTime;
  final String windDownTime;
  final String workStartTime;
  final String workEndTime;
  final CalendarPreference calendarPreference;
  final PlanningStyle planningStyle;

  void validate() {
    final time = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
    if (![
      wakeTime,
      windDownTime,
      workStartTime,
      workEndTime,
    ].every(time.hasMatch)) {
      throw const FormatException('Choose valid times for your day.');
    }
    if (workStartTime == workEndTime) {
      throw const FormatException('Choose different work start and end times.');
    }
  }
}
