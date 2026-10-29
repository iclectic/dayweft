import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dayweft_domain/dayweft_domain.dart';

/// A single-day merge document, not a complete device backup.
class DayImport {
  DayImport._(this.blocks, this.tasks, this.day, this.fingerprint);

  factory DayImport.parse(String input) {
    Never invalid(String message) => throw FormatException(message);
    if (utf8.encode(input).length > 5 * 1024 * 1024) {
      invalid('Import up to 5 MB at a time.');
    }
    final Object? decoded = jsonDecode(input);
    if (decoded is! Map<String, Object?> ||
        decoded['product'] != 'Dayweft' ||
        decoded['schemaVersion'] != 1) {
      invalid('Use a Dayweft schema version 1 day export.');
    }
    List<Map<String, Object?>> rows(String name, int maximum) {
      final value = decoded[name];
      if (value is! List<Object?> ||
          value.length > maximum ||
          value.any((row) => row is! Map<String, Object?>)) {
        invalid(
          'Every $name entry must be an object; maximum $maximum entries.',
        );
      }
      return value.cast<Map<String, Object?>>();
    }

    String text(Map<String, Object?> row, String name, int maximum) {
      final value = row[name];
      if (value is! String || value.trim().isEmpty || value.length > maximum) {
        invalid('Invalid $name in the export.');
      }
      return value;
    }

    void optionalText(Map<String, Object?> row, String name, int maximum) {
      final value = row[name];
      if (value != null && (value is! String || value.length > maximum)) {
        invalid('Invalid $name in the export.');
      }
    }

    int integer(
      Map<String, Object?> row,
      String name,
      int minimum,
      int maximum, [
      int? fallback,
    ]) {
      final value = row[name] ?? fallback;
      if (value is! int || value < minimum || value > maximum) {
        invalid('Invalid $name in the export.');
      }
      return value;
    }

    void boolean(Map<String, Object?> row, String name) {
      if (row[name] != null && row[name] is! bool) {
        invalid('Invalid $name in the export.');
      }
    }

    DateTime date(Object? value) {
      if (value is! String ||
          !RegExp(r'^\d{4}-\d\d-\d\dT\d\d:\d\d').hasMatch(value)) {
        invalid('Invalid date in the export.');
      }
      final parsed = DateTime.tryParse(value);
      final year = int.parse(value.substring(0, 4));
      final month = int.parse(value.substring(5, 7));
      final day = int.parse(value.substring(8, 10));
      final civil = DateTime(year, month, day);
      if (parsed == null ||
          year < 1900 ||
          year > 2200 ||
          civil.year != year ||
          civil.month != month ||
          civil.day != day ||
          int.parse(value.substring(11, 13)) > 23 ||
          int.parse(value.substring(14, 16)) > 59) {
        invalid('Invalid date in the export.');
      }
      return parsed;
    }

    final plan = decoded['plan'];
    if (plan is! Map<String, Object?>) invalid('The export needs a plan date.');
    final planDate = date(plan['day']);
    final day = DateTime(planDate.year, planDate.month, planDate.day);
    final blocks = rows('blocks', 500);
    final tasks = rows('tasks', 2000);
    final blockIds = <String>{};
    for (final block in blocks) {
      if (!blockIds.add(text(block, 'id', 200))) {
        invalid('Imported block identities must be unique.');
      }
      text(block, 'title', 500);
      optionalText(block, 'category', 80);
      final start = date(block['startsAt']);
      final end = date(block['endsAt']);
      if (!end.isAfter(start) ||
          DateTime(start.year, start.month, start.day) != day ||
          !BlockType.values.any((type) => type.name == block['blockType'])) {
        invalid('Invalid block times, plan date or type.');
      }
      var buffers = 0;
      for (final name in [
        'travelBufferMinutes',
        'preparationBufferMinutes',
        'transitionBufferMinutes',
        'recoveryBufferMinutes',
      ]) {
        buffers += integer(block, name, 0, 1440, 0);
      }
      if (buffers > end.difference(start).inMinutes) {
        invalid('Block buffers exceed the available duration.');
      }
      integer(block, 'sortOrder', 0, 1000000, 0);
    }
    final dependencies = <String, List<String>>{};
    for (final task in tasks) {
      final id = text(task, 'id', 200);
      if (dependencies.containsKey(id)) {
        invalid('Imported task identities must be unique.');
      }
      final predecessorIds = task['dependencyIds'] ?? const <Object?>[];
      if (predecessorIds is! List<Object?> ||
          predecessorIds.any((id) => id is! String || id.length > 200)) {
        invalid('Invalid predecessor identities.');
      }
      dependencies[id] = predecessorIds.cast<String>();
      optionalText(task, 'notes', 20000);
      optionalText(task, 'category', 80);
      final priority = TaskPriority.values
          .where((value) => value.name == task['priority'])
          .firstOrNull;
      if (priority == null) invalid('Invalid task priority.');
      for (final entry in {
        'energyRequired': EnergyLevel.values.map((v) => v.name),
        'cognitiveLoad': CognitiveLoad.values.map((v) => v.name),
      }.entries) {
        if (task[entry.key] != null && !entry.value.contains(task[entry.key])) {
          invalid('Invalid ${entry.key}.');
        }
      }
      boolean(task, 'canSplit');
      boolean(task, 'approximateTime');
      final issue = TaskDetails(
        title: text(task, 'title', 500),
        estimatedMinutes: integer(task, 'estimatedMinutes', 1, 1440),
        priority: priority,
        canSplit: task['canSplit'] as bool? ?? false,
        minimumUsefulMinutes: integer(
          task,
          'minimumUsefulMinutes',
          1,
          1440,
          15,
        ),
        dependencyIds: dependencies[id]!,
      ).validationMessage;
      if (issue != null) invalid(issue);
      final status = task['status'];
      if (!['inbox', 'planned', 'completed', 'deferred'].contains(status)) {
        invalid('Invalid task status.');
      }
      final blockId = task['blockId'];
      if (blockId != null &&
          (blockId is! String || !blockIds.contains(blockId))) {
        invalid('A task refers to a missing block.');
      }
      if ((status == 'planned' && blockId == null) ||
          (status == 'inbox' && blockId != null)) {
        invalid('Task status does not match its placement.');
      }
      if (task['actualMinutes'] != null) {
        integer(task, 'actualMinutes', 0, 1000000);
      }
      integer(task, 'sortOrder', 0, 1000000, 0);
      if (task['deadline'] != null) date(task['deadline']);
      for (final key in ['requestedStartTime', 'requestedEndTime']) {
        final value = task[key];
        if (value != null &&
            (value is! String ||
                !RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$').hasMatch(value))) {
          invalid('Invalid requested time.');
        }
      }
      optionalText(task, 'requestedDay', 10);
    }
    for (final entry in dependencies.entries) {
      final issue = taskDependencyIssue(entry.key, entry.value, dependencies);
      if (issue != null) invalid(issue);
    }
    Object? canonical(Object? value) {
      if (value is Map<String, Object?>) {
        final keys = value.keys.toList()..sort();
        return {for (final key in keys) key: canonical(value[key])};
      }
      if (value is List<Object?>) return value.map(canonical).toList();
      return value;
    }

    final fingerprint = sha256
        .convert(
          utf8.encode(
            jsonEncode(
              canonical({
                'plan': decoded['plan'],
                'blocks': blocks,
                'tasks': tasks,
              }),
            ),
          ),
        )
        .toString();
    return DayImport._(
      List.unmodifiable(blocks),
      List.unmodifiable(tasks),
      day,
      fingerprint,
    );
  }

  final List<Map<String, Object?>> blocks;
  final List<Map<String, Object?>> tasks;
  final DateTime day;
  final String fingerprint;
}
