import 'dart:convert';

import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart'
    hide TemplateRecurrence;
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:drift/drift.dart';

class StoredTemplateRecurrence {
  const StoredTemplateRecurrence({required this.version, required this.rule});
  final int version;
  // A null rule is a tombstone, retaining the version after removal.
  final TemplateRecurrence? rule;
}

class TemplateRecurrenceRepository {
  TemplateRecurrenceRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DayweftDatabase _db;
  final DateTime Function() _now;

  Future<StoredTemplateRecurrence?> get(String templateId) async {
    final row = await (_db.select(
      _db.templateRecurrences,
    )..where((row) => row.templateId.equals(templateId))).getSingleOrNull();
    if (row == null) return null;
    return StoredTemplateRecurrence(
      version: row.version,
      rule: row.ruleJson == null ? null : _decode(row.ruleJson!),
    );
  }

  /// A null [expectedVersion] permits creation only. Removal retains a
  /// versioned tombstone so stale editors cannot recreate an old rule.
  Future<StoredTemplateRecurrence> save({
    required String templateId,
    required int expectedTemplateVersion,
    required int? expectedVersion,
    required TemplateRecurrence? rule,
  }) => _db.transaction(() async {
    final template =
        await (_db.select(_db.savedTemplates)..where(
              (row) => row.id.equals(templateId) & row.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (template == null || template.version != expectedTemplateVersion) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'This template changed. Review it again before saving recurrence.',
      );
    }
    final current = await get(templateId);
    if (current?.version != expectedVersion) {
      throw const PlanningFailure(
        PlanningFailureCode.staleProposal,
        'This recurrence changed. Review it again before saving.',
      );
    }
    if (current == null && rule == null) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'There is no recurrence to remove.',
      );
    }
    final encoded = rule == null ? null : _encode(rule);
    final nextVersion = (current?.version ?? 0) + 1;
    await _db
        .into(_db.templateRecurrences)
        .insertOnConflictUpdate(
          TemplateRecurrencesCompanion.insert(
            templateId: templateId,
            ruleJson: Value(encoded),
            version: Value(nextVersion),
            updatedAt: _now(),
          ),
        );
    return StoredTemplateRecurrence(version: nextVersion, rule: rule);
  });

  String _encode(TemplateRecurrence rule) {
    if (rule.exceptions.length > 5000) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'A recurrence can have at most 5,000 excluded dates.',
      );
    }
    final days = rule.weekdays.toList()..sort();
    final exceptions = rule.exceptions.map(_dateString).toList()..sort();
    return jsonEncode({
      'formatVersion': 1,
      'weekdays': days,
      'startsOn': _dateString(rule.startsOn),
      'endsOn': rule.endsOn == null ? null : _dateString(rule.endsOn!),
      'exceptions': exceptions,
    });
  }

  TemplateRecurrence _decode(String source) {
    try {
      final json = jsonDecode(source) as Map<String, dynamic>;
      if (json['formatVersion'] != 1) throw const FormatException();
      final weekdays = (json['weekdays'] as List).cast<int>();
      final exceptions = (json['exceptions'] as List).cast<String>();
      if (weekdays.length > 7 || exceptions.length > 5000) {
        throw const FormatException();
      }
      return TemplateRecurrence(
        weekdays: weekdays.toSet(),
        startsOn: _parseDate(json['startsOn'] as String),
        endsOn: json['endsOn'] == null
            ? null
            : _parseDate(json['endsOn'] as String),
        exceptions: exceptions.map(_parseDate),
      );
    } on Object {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'A saved recurrence could not be read. Your plans have not changed.',
      );
    }
  }

  String _dateString(DateTime date) {
    if (date.year < 1 || date.year > 9999) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Choose dates between years 1 and 9999.',
      );
    }
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  DateTime _parseDate(String value) {
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      throw const FormatException();
    }
    final parsed = DateTime.utc(
      int.parse(value.substring(0, 4)),
      int.parse(value.substring(5, 7)),
      int.parse(value.substring(8, 10)),
    );
    if (_dateString(parsed) != value) throw const FormatException();
    return parsed;
  }
}
