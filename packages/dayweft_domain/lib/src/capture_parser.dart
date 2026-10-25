import 'dayweft_domain_base.dart';

class CaptureInterpretation {
  const CaptureInterpretation({
    required this.title,
    required this.estimatedMinutes,
    required this.priority,
    this.category,
    this.energy,
    this.day,
    this.deadline,
    this.startTime,
    this.endTime,
    this.approximate = false,
    this.warnings = const [],
  });
  final String title;
  final int estimatedMinutes;
  final TaskPriority priority;
  final String? category;
  final EnergyLevel? energy;
  final DateTime? day;
  final DateTime? deadline;
  final String? startTime;
  final String? endTime;
  final bool approximate;
  final List<String> warnings;
}

/// A bounded English grammar. Unrecognised text is preserved for confirmation.
class LocalCaptureParser {
  const LocalCaptureParser();

  CaptureInterpretation parse(String input, {required DateTime reference}) {
    var title = input.trim();
    if (title.isEmpty || title.length > 16000) {
      throw const FormatException(
        'Capture needs between 1 and 16000 characters.',
      );
    }
    final warnings = <String>[];
    final duration = RegExp(
      r'\b(?:for\s+)?(\d+(?:\.\d+)?)\s*(hours|hour|hrs|hr|h|minutes|minute|mins|min|m)\b',
      caseSensitive: false,
    ).firstMatch(title);
    var minutes = 30;
    if (duration != null) {
      final amount = double.tryParse(duration[1]!);
      final proposed = amount == null
          ? 0
          : (amount * (duration[2]!.toLowerCase().startsWith('h') ? 60 : 1))
                .round();
      if (proposed > 0 && proposed <= 525600) {
        minutes = proposed;
        title = title.replaceRange(duration.start, duration.end, ' ');
      } else {
        warnings.add('Duration was not understood. Review the estimate.');
      }
    }

    final categoryMatch = RegExp(
      r'(?:^|\s)#([A-Za-z0-9_-]{1,50})\b',
    ).firstMatch(title);
    final category = categoryMatch?[1];
    if (categoryMatch != null) {
      title = title.replaceRange(categoryMatch.start, categoryMatch.end, ' ');
    }

    final energyMatch = RegExp(
      r'\b(?:energy\s*[:=]?\s*(low|steady|high)|(low|steady|high)\s+energy)\b',
      caseSensitive: false,
    ).firstMatch(title);
    final energyName = (energyMatch?[1] ?? energyMatch?[2])?.toLowerCase();
    final energy = energyName == null
        ? null
        : EnergyLevel.values.byName(energyName);
    if (energyMatch != null) {
      title = title.replaceRange(energyMatch.start, energyMatch.end, ' ');
    }

    final priorityMatch = RegExp(
      r'\b(urgent|essential|high priority|low priority|medium priority|priority\s*[:=]?\s*(?:low|medium|high|essential))\b',
      caseSensitive: false,
    ).firstMatch(title);
    var priority = TaskPriority.medium;
    if (priorityMatch != null) {
      final value = priorityMatch[0]!.toLowerCase();
      priority = value.contains('urgent') || value.contains('essential')
          ? TaskPriority.essential
          : value.contains('high')
          ? TaskPriority.high
          : value.contains('low')
          ? TaskPriority.low
          : TaskPriority.medium;
      title = title.replaceRange(priorityMatch.start, priorityMatch.end, ' ');
    }

    final dateMatch = RegExp(
      r'\b(?:(due|on)\s+)?(today|tomorrow|monday|tuesday|wednesday|thursday|friday|saturday|sunday|\d{4}-\d{2}-\d{2})\b',
      caseSensitive: false,
    ).firstMatch(title);
    DateTime? day;
    var dueDate = false;
    if (dateMatch != null) {
      day = _day(dateMatch[2]!.toLowerCase(), reference);
      if (day == null) {
        warnings.add('Date was not understood. It remains in the title.');
      } else {
        dueDate = dateMatch[1]?.toLowerCase() == 'due';
        title = title.replaceRange(dateMatch.start, dateMatch.end, ' ');
      }
    }

    String? startTime;
    String? endTime;
    DateTime? deadline;
    var approximate = false;
    final range = RegExp(
      r'\b(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\s*[-–]\s*(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
      caseSensitive: false,
    ).firstMatch(title);
    if (range != null) {
      startTime = _time(range[1]!, range[2], range[3] ?? range[6]);
      endTime = _time(range[4]!, range[5], range[6]);
      if (startTime == null || endTime == null || startTime == endTime) {
        startTime = null;
        endTime = null;
        warnings.add('Time range was not understood. It remains in the title.');
      } else {
        title = title.replaceRange(range.start, range.end, ' ');
      }
    } else {
      final time = RegExp(
        r'\b(at|around|about|by)\s+(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
        caseSensitive: false,
      ).firstMatch(title);
      if (time != null) {
        final parsed = _time(time[2]!, time[3], time[4]);
        if (parsed == null) {
          warnings.add('Time was not understood. It remains in the title.');
        } else {
          if (time[1]!.toLowerCase() == 'by') {
            final date =
                day ?? DateTime(reference.year, reference.month, reference.day);
            final parts = parsed.split(':');
            deadline = DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(parts[0]),
              int.parse(parts[1]),
            );
          } else {
            startTime = parsed;
            approximate = ['around', 'about'].contains(time[1]!.toLowerCase());
          }
          title = title.replaceRange(time.start, time.end, ' ');
        }
      }
    }
    if (dueDate && deadline == null && day != null) {
      deadline = DateTime(
        day.year,
        day.month,
        day.day + 1,
      ).subtract(const Duration(microseconds: 1));
    }
    if (deadline != null && deadline.isBefore(reference)) {
      warnings.add('The parsed deadline is in the past. Confirm or change it.');
    }
    title = title
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[:\s]+|[:\s]+$'), '')
        .trim();
    if (title.isEmpty) {
      title = input.trim();
      warnings.add('Add a task title before confirming.');
    }
    return CaptureInterpretation(
      title: title,
      estimatedMinutes: minutes,
      priority: priority,
      category: category,
      energy: energy,
      day: dueDate ? null : day,
      deadline: deadline,
      startTime: startTime,
      endTime: endTime,
      approximate: approximate,
      warnings: List.unmodifiable(warnings),
    );
  }

  String? _time(String hourText, String? minuteText, String? meridiem) {
    var hour = int.parse(hourText);
    final minute = int.parse(minuteText ?? '0');
    if (minute > 59 || hour > 23) return null;
    if (meridiem != null) {
      if (hour < 1 || hour > 12) return null;
      hour = hour % 12 + (meridiem.toLowerCase() == 'pm' ? 12 : 0);
    }
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  DateTime? _day(String text, DateTime reference) {
    final today = DateTime(reference.year, reference.month, reference.day);
    if (text == 'today') return today;
    if (text == 'tomorrow') {
      return DateTime(today.year, today.month, today.day + 1);
    }
    const weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final weekday = weekdays.indexOf(text) + 1;
    if (weekday > 0) {
      return DateTime(
        today.year,
        today.month,
        today.day + (weekday - today.weekday + 7) % 7,
      );
    }
    final parsed = DateTime.tryParse(text);
    if (parsed == null ||
        '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}' !=
            text) {
      return null;
    }
    return parsed;
  }
}
