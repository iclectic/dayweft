import 'dart:io';

import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'database schema starts at version 11 and creates core tables',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);

      expect(database.schemaVersion, 11);

      final tables = await database
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
          .get();

      final tableNames = tables.map((row) => row.read<String>('name'));
      expect(tableNames, contains('day_plans'));
      expect(tableNames, contains('user_preferences'));
      expect(tableNames, contains('time_blocks'));
      expect(tableNames, contains('tasks'));
      expect(tableNames, contains('schedule_revisions'));
      expect(tableNames, contains('sync_operations'));
      expect(tableNames, contains('estimation_records'));
      expect(tableNames, contains('energy_check_ins'));
      expect(tableNames, contains('focus_sessions'));
      expect(tableNames, contains('share_links'));
      expect(tableNames, contains('calendar_connections'));
    },
  );

  test('version 5 preferences migrate without losing local choices', () async {
    final executor = NativeDatabase.memory(
      setup: (raw) {
        raw.execute('''CREATE TABLE user_preferences (
        id TEXT NOT NULL PRIMARY KEY,
        onboarding_completed INTEGER NOT NULL DEFAULT 0,
        sample_data_enabled INTEGER NOT NULL DEFAULT 0,
        wake_time TEXT NOT NULL DEFAULT '07:00',
        wind_down_time TEXT NOT NULL DEFAULT '22:00',
        work_start_time TEXT NOT NULL DEFAULT '09:00',
        work_end_time TEXT NOT NULL DEFAULT '17:00',
        planning_style TEXT NOT NULL DEFAULT 'balanced',
        preferred_break_minutes INTEGER NOT NULL DEFAULT 20,
        contingency_minutes INTEGER NOT NULL DEFAULT 30,
        transition_minutes INTEGER NOT NULL DEFAULT 10,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )''');
        raw.execute(
          "INSERT INTO user_preferences (id, onboarding_completed, wake_time, created_at, updated_at) VALUES ('local-user', 1, '06:30', 0, 0)",
        );
        raw.execute('PRAGMA user_version = 5');
        raw.execute('CREATE TABLE tasks (id TEXT NOT NULL PRIMARY KEY)');
        raw.execute('''CREATE TABLE estimation_records (
        id TEXT NOT NULL PRIMARY KEY, task_id TEXT, category TEXT,
        estimated_minutes INTEGER NOT NULL, actual_minutes INTEGER NOT NULL,
        time_of_day TEXT NOT NULL, day_of_week INTEGER NOT NULL,
        interruption_count INTEGER NOT NULL DEFAULT 0, was_split INTEGER NOT NULL DEFAULT 0,
        difficulty INTEGER, excluded INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL, deleted_at INTEGER
      )''');
        raw.execute(
          "INSERT INTO estimation_records (id, estimated_minutes, actual_minutes, time_of_day, day_of_week, created_at) VALUES ('legacy', 20, 20, 'morning', 1, 0)",
        );
      },
    );
    final database = DayweftDatabase.forTesting(executor);
    addTearDown(database.close);
    final preferences = await database
        .select(database.userPreferences)
        .getSingle();
    expect(preferences.wakeTime, '06:30');
    expect(preferences.onboardingCompleted, isTrue);
    expect(preferences.workingPattern, 'flexible');
    expect(preferences.calendarPreference, 'later');
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.read<int>('user_version'), 11);
    final legacy = await database
        .select(database.estimationRecords)
        .getSingle();
    expect(legacy.measurementSource, 'legacy_unknown');
    expect(preferences.energyEnabled, isFalse);
  });

  test('version 8 task rows survive addition of capture fields', () async {
    final directory = await Directory.systemTemp.createTemp(
      'calm-time-migration-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/migration.sqlite');
    final previous = DayweftDatabase.forTesting(NativeDatabase(file));
    final now = DateTime.now();
    await previous
        .into(previous.tasks)
        .insert(
          TasksCompanion.insert(
            id: 'existing',
            title: 'Keep my task',
            estimatedMinutes: 45,
            priority: 'high',
            status: 'inbox',
            sortOrder: 0,
            syncState: SyncState.localOnly,
            createdAt: now,
            updatedAt: now,
          ),
        );
    for (final column in [
      'cognitive_load',
      'dependency_ids_json',
      'energy_required',
      'requested_day',
      'requested_start_time',
      'requested_end_time',
      'approximate_time',
    ]) {
      await previous.customStatement('ALTER TABLE tasks DROP COLUMN $column');
    }
    await previous.customStatement('DROP TABLE focus_session_states');
    await previous.customStatement('PRAGMA user_version = 8');
    await previous.close();
    final upgraded = DayweftDatabase.forTesting(NativeDatabase(file));
    addTearDown(upgraded.close);
    final task = await upgraded.select(upgraded.tasks).getSingle();
    expect(task.id, 'existing');
    expect(task.title, 'Keep my task');
    expect(task.estimatedMinutes, 45);
    expect(task.requestedDay, isNull);
    expect(task.approximateTime, isFalse);
    final tables = await upgraded
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
        .get();
    expect(
      tables.map((row) => row.read<String>('name')),
      contains('revision_undos'),
    );
  });

  test(
    'version 9 task details survive the cognitive-load/dependency upgrade',
    () async {
      final directory = await Directory.systemTemp.createTemp('calm-time-v9-');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/migration.sqlite');
      final previous = DayweftDatabase.forTesting(NativeDatabase(file));
      final now = DateTime.now();
      await previous
          .into(previous.tasks)
          .insert(
            TasksCompanion.insert(
              id: 'v9-task',
              title: 'Preserve existing details',
              estimatedMinutes: 45,
              priority: 'high',
              status: 'inbox',
              sortOrder: 0,
              notes: const Value('Personal notes'),
              energyRequired: const Value('low'),
              syncState: SyncState.localOnly,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await previous.customStatement(
        'ALTER TABLE tasks DROP COLUMN cognitive_load',
      );
      await previous.customStatement(
        'ALTER TABLE tasks DROP COLUMN dependency_ids_json',
      );
      await previous.customStatement('DROP TABLE focus_session_states');
      await previous.customStatement('PRAGMA user_version = 9');
      await previous.close();
      final upgraded = DayweftDatabase.forTesting(NativeDatabase(file));
      addTearDown(upgraded.close);
      final task = await upgraded.select(upgraded.tasks).getSingle();
      expect(task.title, 'Preserve existing details');
      expect(task.notes, 'Personal notes');
      expect(task.energyRequired, 'low');
      expect(task.cognitiveLoad, isNull);
      expect(task.dependencyIdsJson, '[]');
      expect(task.localVersion, 1);
    },
  );

  test(
    'version 10 focus records survive durable-state table migration',
    () async {
      final directory = await Directory.systemTemp.createTemp('dayweft-v10-');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/migration.sqlite');
      final previous = DayweftDatabase.forTesting(NativeDatabase(file));
      final now = DateTime(2026, 10, 27);
      await previous
          .into(previous.focusSessions)
          .insert(
            FocusSessionsCompanion.insert(
              id: 'legacy-focus',
              title: 'Keep my record',
              startedAt: now,
              plannedMinutes: 25,
              actualMinutes: const Value(10),
              status: 'completed',
              createdAt: now,
            ),
          );
      await previous.customStatement('DROP TABLE focus_session_states');
      await previous.customStatement('PRAGMA user_version = 10');
      await previous.close();
      final upgraded = DayweftDatabase.forTesting(NativeDatabase(file));
      addTearDown(upgraded.close);
      final session = await upgraded.select(upgraded.focusSessions).getSingle();
      expect(session.actualMinutes, 10);
      expect(session.title, 'Keep my record');
      expect(await upgraded.select(upgraded.focusSessionStates).get(), isEmpty);
      expect(upgraded.schemaVersion, 11);
    },
  );
}
