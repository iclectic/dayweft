import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('database schema starts at version 3 and creates core tables', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    expect(database.schemaVersion, 3);

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
  });
}
