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

class UserPreferences extends Table {
  TextColumn get id => text()();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get sampleDataEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get wakeTime => text().withDefault(const Constant('07:00'))();
  TextColumn get windDownTime => text().withDefault(const Constant('22:00'))();
  TextColumn get workStartTime => text().withDefault(const Constant('09:00'))();
  TextColumn get workEndTime => text().withDefault(const Constant('17:00'))();
  TextColumn get planningStyle =>
      text().withDefault(const Constant('balanced'))();
  TextColumn get workingPattern =>
      text().withDefault(const Constant('flexible'))();
  TextColumn get calendarPreference =>
      text().withDefault(const Constant('later'))();
  BoolColumn get energyEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get preferredBreakMinutes =>
      integer().withDefault(const Constant(20))();
  IntColumn get contingencyMinutes =>
      integer().withDefault(const Constant(30))();
  IntColumn get transitionMinutes =>
      integer().withDefault(const Constant(10))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

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
  IntColumn get travelBufferMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get preparationBufferMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get transitionBufferMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get recoveryBufferMinutes =>
      integer().withDefault(const Constant(0))();
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
  TextColumn get energyRequired => text().nullable()();
  TextColumn get cognitiveLoad => text().nullable()();
  TextColumn get dependencyIdsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get requestedDay => text().nullable()();
  TextColumn get requestedStartTime => text().nullable()();
  TextColumn get requestedEndTime => text().nullable()();
  BoolColumn get approximateTime =>
      boolean().withDefault(const Constant(false))();
  IntColumn get estimatedMinutes => integer()();
  IntColumn get actualMinutes => integer().nullable()();
  TextColumn get priority => text()();
  TextColumn get category => text().nullable()();
  TextColumn get status => text()();
  TextColumn get sourceId => text().nullable()();
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

class RevisionUndos extends Table {
  TextColumn get id => text()();
  TextColumn get revisionId =>
      text().unique().references(ScheduleRevisions, #id)();
  DateTimeColumn get undoneAt => dateTime()();
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

class EstimationRecords extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable().references(Tasks, #id)();
  TextColumn get category => text().nullable()();
  IntColumn get estimatedMinutes => integer()();
  IntColumn get actualMinutes => integer()();
  TextColumn get measurementSource =>
      text().withDefault(const Constant('legacy_unknown'))();
  TextColumn get timeOfDay => text()();
  IntColumn get dayOfWeek => integer()();
  IntColumn get interruptionCount => integer().withDefault(const Constant(0))();
  BoolColumn get wasSplit => boolean().withDefault(const Constant(false))();
  IntColumn get difficulty => integer().nullable()();
  BoolColumn get excluded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class EnergyCheckIns extends Table {
  TextColumn get id => text()();
  TextColumn get level => text()();
  DateTimeColumn get checkedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get taskId => text().nullable().references(Tasks, #id)();
  TextColumn get title => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get plannedMinutes => integer()();
  IntColumn get actualMinutes => integer().nullable()();
  IntColumn get interruptionCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ShareLinks extends Table {
  TextColumn get id => text()();
  TextColumn get tokenHash => text().unique()();
  TextColumn get shareType => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get revokedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class FocusSessionStates extends Table {
  TextColumn get sessionId => text().references(FocusSessions, #id)();
  TextColumn get mode => text()();
  IntColumn get elapsedMilliseconds =>
      integer().withDefault(const Constant(0))();
  IntColumn get anchorMilliseconds => integer().nullable()();
  TextColumn get bootToken => text().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get estimateAtStart => integer().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  @override
  Set<Column<Object>> get primaryKey => {sessionId};
}

class CalendarConnections extends Table {
  TextColumn get id => text()();
  TextColumn get platform => text()();
  TextColumn get permissionState => text()();
  BoolColumn get readOnly => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: <Type>[
    DayPlans,
    UserPreferences,
    TimeBlocks,
    Tasks,
    ScheduleRevisions,
    RevisionUndos,
    SyncOperations,
    EstimationRecords,
    EnergyCheckIns,
    FocusSessions,
    FocusSessionStates,
    ShareLinks,
    CalendarConnections,
  ],
)
class DayweftDatabase extends _$DayweftDatabase {
  DayweftDatabase() : super(_openConnection());

  DayweftDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
        await _focusIndex();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(userPreferences);
        }
        if (from < 3) {
          await migrator.addColumn(tasks, tasks.category);
          await migrator.addColumn(tasks, tasks.sourceId);
        }
        if (from < 4) {
          await migrator.addColumn(
            userPreferences,
            userPreferences.preferredBreakMinutes,
          );
          await migrator.addColumn(
            userPreferences,
            userPreferences.contingencyMinutes,
          );
          await migrator.addColumn(
            userPreferences,
            userPreferences.transitionMinutes,
          );
          await migrator.addColumn(timeBlocks, timeBlocks.travelBufferMinutes);
          await migrator.addColumn(
            timeBlocks,
            timeBlocks.preparationBufferMinutes,
          );
          await migrator.addColumn(
            timeBlocks,
            timeBlocks.transitionBufferMinutes,
          );
          await migrator.addColumn(
            timeBlocks,
            timeBlocks.recoveryBufferMinutes,
          );
        }
        if (from < 5) {
          await migrator.createTable(estimationRecords);
          await migrator.createTable(energyCheckIns);
          await migrator.createTable(focusSessions);
          await migrator.createTable(shareLinks);
          await migrator.createTable(calendarConnections);
        }
        if (from < 6) {
          await migrator.addColumn(
            userPreferences,
            userPreferences.workingPattern,
          );
          await migrator.addColumn(
            userPreferences,
            userPreferences.calendarPreference,
          );
        }
        if (from < 7) {
          await migrator.addColumn(
            userPreferences,
            userPreferences.energyEnabled,
          );
          await migrator.addColumn(
            estimationRecords,
            estimationRecords.measurementSource,
          );
        }
        if (from < 8) {
          await migrator.createTable(revisionUndos);
        }
        if (from < 9) {
          await migrator.addColumn(tasks, tasks.energyRequired);
          await migrator.addColumn(tasks, tasks.requestedDay);
          await migrator.addColumn(tasks, tasks.requestedStartTime);
          await migrator.addColumn(tasks, tasks.requestedEndTime);
          await migrator.addColumn(tasks, tasks.approximateTime);
        }
        if (from < 10) {
          await migrator.addColumn(tasks, tasks.cognitiveLoad);
          await migrator.addColumn(tasks, tasks.dependencyIdsJson);
        }
        if (from < 11) {
          await migrator.createTable(focusSessionStates);
          await _focusIndex();
        }
      },
    );
  }

  Future<void> _focusIndex() => customStatement(
    'CREATE UNIQUE INDEX focus_one_active ON focus_session_states (active) WHERE active = 1',
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'dayweft.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
