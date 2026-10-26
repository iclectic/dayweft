import 'dart:convert';

enum RevisionValueType { text, minutes, instant, flag, predecessors }

class RevisionFieldChange {
  const RevisionFieldChange({
    required this.label,
    required this.before,
    required this.after,
    required this.type,
  });
  final String label;
  final Object? before;
  final Object? after;
  final RevisionValueType type;
}

List<RevisionFieldChange> compareRevision(String changeSetJson) {
  final Object? decoded = jsonDecode(changeSetJson);
  if (decoded is! Map<String, Object?>) {
    return const [];
  }
  final before = decoded['task'] ?? decoded['block'];
  final after = decoded['after'];
  if (before is! Map<String, Object?> || after is! Map<String, Object?>) {
    return const [];
  }
  const fields = <String, (String, RevisionValueType)>{
    'title': ('Title', RevisionValueType.text),
    'startsAt': ('Start', RevisionValueType.instant),
    'endsAt': ('End', RevisionValueType.instant),
    'blockType': ('Block type', RevisionValueType.text),
    'estimatedMinutes': ('Estimate', RevisionValueType.minutes),
    'priority': ('Priority', RevisionValueType.text),
    'category': ('Category', RevisionValueType.text),
    'notes': ('Notes', RevisionValueType.text),
    'deadline': ('Deadline', RevisionValueType.instant),
    'energyRequired': ('Energy requirement', RevisionValueType.text),
    'cognitiveLoad': ('Cognitive load', RevisionValueType.text),
    'canSplit': ('Allow splitting', RevisionValueType.flag),
    'minimumUsefulMinutes': ('Minimum fragment', RevisionValueType.minutes),
    'dependencyIds': ('Predecessor selection', RevisionValueType.predecessors),
    'travelBufferMinutes': ('Travel buffer', RevisionValueType.minutes),
    'preparationBufferMinutes': (
      'Preparation buffer',
      RevisionValueType.minutes,
    ),
    'transitionBufferMinutes': ('Transition buffer', RevisionValueType.minutes),
    'recoveryBufferMinutes': ('Recovery buffer', RevisionValueType.minutes),
  };
  return [
    for (final field in fields.entries)
      if (jsonEncode(before[field.key]) != jsonEncode(after[field.key]))
        RevisionFieldChange(
          label: field.value.$1,
          before: before[field.key],
          after: after[field.key],
          type: field.value.$2,
        ),
  ];
}
