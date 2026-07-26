import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'dayweft_database.g.dart';

enum SyncState {
  localOnly,
  pendingCreate,
  pendingUpdate,
  pendingDelete,
  synced,
}

class DayPlans extends Table {
  TextColumn get id => text()();
  DateTimeColumn get day => dateTime()();
  TextColumn get timeZone => text()();
  IntColumn get revision => integer().withDefault(const Constant(0))();
  TextColumn get syncState => textEnum<SyncState>()();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();
  IntColumn get remoteVersion => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TimeBlocks extends Table {
  TextColumn get id => text()();
  TextColumn get dayPlanId => text().references(DayPlans, #id)();
  TextColumn get title => text()();
  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime()();
  TextColumn get blockType => text()();
  TextColumn get category => text().nullable()();
  TextColumn get sourceId => text().nullable()();
  IntColumn get sortOrder => integer()();
  TextColumn get syncState => textEnum<SyncState>()();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();
  IntColumn get remoteVersion => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get dayPlanId => text().references(DayPlans, #id).nullable()();
  TextColumn get blockId => text().references(TimeBlocks, #id).nullable()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get estimatedMinutes => integer()();
  IntColumn get actualMinutes => integer().nullable()();
  TextColumn get priority => text()();
  TextColumn get status => text()();
  DateTimeColumn get deadline => dateTime().nullable()();
  BoolColumn get canSplit => boolean().withDefault(const Constant(false))();
  IntColumn get minimumUsefulMinutes =>
      integer().withDefault(const Constant(15))();
  IntColumn get sortOrder => integer()();
  TextColumn get syncState => textEnum<SyncState>()();
  IntColumn get localVersion => integer().withDefault(const Constant(1))();
  IntColumn get remoteVersion => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ScheduleRevisions extends Table {
  TextColumn get id => text()();
  TextColumn get dayPlanId => text().references(DayPlans, #id)();
  IntColumn get revisionNumber => integer()();
  TextColumn get reason => text()();
  TextColumn get reversibleChangeSetJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SyncOperations extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operationType => text()();
  TextColumn get payloadJson => text()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: <Type>[
    DayPlans,
    TimeBlocks,
    Tasks,
    ScheduleRevisions,
    SyncOperations,
  ],
)
class DayweftDatabase extends _$DayweftDatabase {
  DayweftDatabase() : super(_openConnection());

  DayweftDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (migrator) => migrator.createAll());
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'dayweft.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
