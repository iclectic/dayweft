// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dayweft_database.dart';

// ignore_for_file: type=lint
class $DayPlansTable extends DayPlans with TableInfo<$DayPlansTable, DayPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<DateTime> day = GeneratedColumn<DateTime>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncState>($DayPlansTable.$convertersyncState);
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _remoteVersionMeta = const VerificationMeta(
    'remoteVersion',
  );
  @override
  late final GeneratedColumn<int> remoteVersion = GeneratedColumn<int>(
    'remote_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    timeZone,
    revision,
    syncState,
    localVersion,
    remoteVersion,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timeZoneMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    }
    if (data.containsKey('remote_version')) {
      context.handle(
        _remoteVersionMeta,
        remoteVersion.isAcceptableOrUnknown(
          data['remote_version']!,
          _remoteVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}day'],
      )!,
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      syncState: $DayPlansTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
      remoteVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $DayPlansTable createAlias(String alias) {
    return $DayPlansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class DayPlan extends DataClass implements Insertable<DayPlan> {
  final String id;
  final DateTime day;
  final String timeZone;
  final int revision;
  final SyncState syncState;
  final int localVersion;
  final int? remoteVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const DayPlan({
    required this.id,
    required this.day,
    required this.timeZone,
    required this.revision,
    required this.syncState,
    required this.localVersion,
    this.remoteVersion,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day'] = Variable<DateTime>(day);
    map['time_zone'] = Variable<String>(timeZone);
    map['revision'] = Variable<int>(revision);
    {
      map['sync_state'] = Variable<String>(
        $DayPlansTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_version'] = Variable<int>(localVersion);
    if (!nullToAbsent || remoteVersion != null) {
      map['remote_version'] = Variable<int>(remoteVersion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  DayPlansCompanion toCompanion(bool nullToAbsent) {
    return DayPlansCompanion(
      id: Value(id),
      day: Value(day),
      timeZone: Value(timeZone),
      revision: Value(revision),
      syncState: Value(syncState),
      localVersion: Value(localVersion),
      remoteVersion: remoteVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory DayPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayPlan(
      id: serializer.fromJson<String>(json['id']),
      day: serializer.fromJson<DateTime>(json['day']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      revision: serializer.fromJson<int>(json['revision']),
      syncState: $DayPlansTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      remoteVersion: serializer.fromJson<int?>(json['remoteVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'day': serializer.toJson<DateTime>(day),
      'timeZone': serializer.toJson<String>(timeZone),
      'revision': serializer.toJson<int>(revision),
      'syncState': serializer.toJson<String>(
        $DayPlansTable.$convertersyncState.toJson(syncState),
      ),
      'localVersion': serializer.toJson<int>(localVersion),
      'remoteVersion': serializer.toJson<int?>(remoteVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  DayPlan copyWith({
    String? id,
    DateTime? day,
    String? timeZone,
    int? revision,
    SyncState? syncState,
    int? localVersion,
    Value<int?> remoteVersion = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => DayPlan(
    id: id ?? this.id,
    day: day ?? this.day,
    timeZone: timeZone ?? this.timeZone,
    revision: revision ?? this.revision,
    syncState: syncState ?? this.syncState,
    localVersion: localVersion ?? this.localVersion,
    remoteVersion: remoteVersion.present
        ? remoteVersion.value
        : this.remoteVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  DayPlan copyWithCompanion(DayPlansCompanion data) {
    return DayPlan(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      revision: data.revision.present ? data.revision.value : this.revision,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      remoteVersion: data.remoteVersion.present
          ? data.remoteVersion.value
          : this.remoteVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayPlan(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('timeZone: $timeZone, ')
          ..write('revision: $revision, ')
          ..write('syncState: $syncState, ')
          ..write('localVersion: $localVersion, ')
          ..write('remoteVersion: $remoteVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    timeZone,
    revision,
    syncState,
    localVersion,
    remoteVersion,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayPlan &&
          other.id == this.id &&
          other.day == this.day &&
          other.timeZone == this.timeZone &&
          other.revision == this.revision &&
          other.syncState == this.syncState &&
          other.localVersion == this.localVersion &&
          other.remoteVersion == this.remoteVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class DayPlansCompanion extends UpdateCompanion<DayPlan> {
  final Value<String> id;
  final Value<DateTime> day;
  final Value<String> timeZone;
  final Value<int> revision;
  final Value<SyncState> syncState;
  final Value<int> localVersion;
  final Value<int?> remoteVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const DayPlansCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.revision = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.remoteVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayPlansCompanion.insert({
    required String id,
    required DateTime day,
    required String timeZone,
    this.revision = const Value.absent(),
    required SyncState syncState,
    this.localVersion = const Value.absent(),
    this.remoteVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       day = Value(day),
       timeZone = Value(timeZone),
       syncState = Value(syncState),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DayPlan> custom({
    Expression<String>? id,
    Expression<DateTime>? day,
    Expression<String>? timeZone,
    Expression<int>? revision,
    Expression<String>? syncState,
    Expression<int>? localVersion,
    Expression<int>? remoteVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (timeZone != null) 'time_zone': timeZone,
      if (revision != null) 'revision': revision,
      if (syncState != null) 'sync_state': syncState,
      if (localVersion != null) 'local_version': localVersion,
      if (remoteVersion != null) 'remote_version': remoteVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayPlansCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? day,
    Value<String>? timeZone,
    Value<int>? revision,
    Value<SyncState>? syncState,
    Value<int>? localVersion,
    Value<int?>? remoteVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return DayPlansCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      timeZone: timeZone ?? this.timeZone,
      revision: revision ?? this.revision,
      syncState: syncState ?? this.syncState,
      localVersion: localVersion ?? this.localVersion,
      remoteVersion: remoteVersion ?? this.remoteVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<DateTime>(day.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $DayPlansTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (remoteVersion.present) {
      map['remote_version'] = Variable<int>(remoteVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayPlansCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('timeZone: $timeZone, ')
          ..write('revision: $revision, ')
          ..write('syncState: $syncState, ')
          ..write('localVersion: $localVersion, ')
          ..write('remoteVersion: $remoteVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sampleDataEnabledMeta = const VerificationMeta(
    'sampleDataEnabled',
  );
  @override
  late final GeneratedColumn<bool> sampleDataEnabled = GeneratedColumn<bool>(
    'sample_data_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sample_data_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<String> wakeTime = GeneratedColumn<String>(
    'wake_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('07:00'),
  );
  static const VerificationMeta _windDownTimeMeta = const VerificationMeta(
    'windDownTime',
  );
  @override
  late final GeneratedColumn<String> windDownTime = GeneratedColumn<String>(
    'wind_down_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('22:00'),
  );
  static const VerificationMeta _workStartTimeMeta = const VerificationMeta(
    'workStartTime',
  );
  @override
  late final GeneratedColumn<String> workStartTime = GeneratedColumn<String>(
    'work_start_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('09:00'),
  );
  static const VerificationMeta _workEndTimeMeta = const VerificationMeta(
    'workEndTime',
  );
  @override
  late final GeneratedColumn<String> workEndTime = GeneratedColumn<String>(
    'work_end_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('17:00'),
  );
  static const VerificationMeta _planningStyleMeta = const VerificationMeta(
    'planningStyle',
  );
  @override
  late final GeneratedColumn<String> planningStyle = GeneratedColumn<String>(
    'planning_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('balanced'),
  );
  static const VerificationMeta _workingPatternMeta = const VerificationMeta(
    'workingPattern',
  );
  @override
  late final GeneratedColumn<String> workingPattern = GeneratedColumn<String>(
    'working_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('flexible'),
  );
  static const VerificationMeta _calendarPreferenceMeta =
      const VerificationMeta('calendarPreference');
  @override
  late final GeneratedColumn<String> calendarPreference =
      GeneratedColumn<String>(
        'calendar_preference',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('later'),
      );
  static const VerificationMeta _energyEnabledMeta = const VerificationMeta(
    'energyEnabled',
  );
  @override
  late final GeneratedColumn<bool> energyEnabled = GeneratedColumn<bool>(
    'energy_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("energy_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _preferredBreakMinutesMeta =
      const VerificationMeta('preferredBreakMinutes');
  @override
  late final GeneratedColumn<int> preferredBreakMinutes = GeneratedColumn<int>(
    'preferred_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _contingencyMinutesMeta =
      const VerificationMeta('contingencyMinutes');
  @override
  late final GeneratedColumn<int> contingencyMinutes = GeneratedColumn<int>(
    'contingency_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _transitionMinutesMeta = const VerificationMeta(
    'transitionMinutes',
  );
  @override
  late final GeneratedColumn<int> transitionMinutes = GeneratedColumn<int>(
    'transition_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    onboardingCompleted,
    sampleDataEnabled,
    wakeTime,
    windDownTime,
    workStartTime,
    workEndTime,
    planningStyle,
    workingPattern,
    calendarPreference,
    energyEnabled,
    preferredBreakMinutes,
    contingencyMinutes,
    transitionMinutes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('sample_data_enabled')) {
      context.handle(
        _sampleDataEnabledMeta,
        sampleDataEnabled.isAcceptableOrUnknown(
          data['sample_data_enabled']!,
          _sampleDataEnabledMeta,
        ),
      );
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    }
    if (data.containsKey('wind_down_time')) {
      context.handle(
        _windDownTimeMeta,
        windDownTime.isAcceptableOrUnknown(
          data['wind_down_time']!,
          _windDownTimeMeta,
        ),
      );
    }
    if (data.containsKey('work_start_time')) {
      context.handle(
        _workStartTimeMeta,
        workStartTime.isAcceptableOrUnknown(
          data['work_start_time']!,
          _workStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('work_end_time')) {
      context.handle(
        _workEndTimeMeta,
        workEndTime.isAcceptableOrUnknown(
          data['work_end_time']!,
          _workEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('planning_style')) {
      context.handle(
        _planningStyleMeta,
        planningStyle.isAcceptableOrUnknown(
          data['planning_style']!,
          _planningStyleMeta,
        ),
      );
    }
    if (data.containsKey('working_pattern')) {
      context.handle(
        _workingPatternMeta,
        workingPattern.isAcceptableOrUnknown(
          data['working_pattern']!,
          _workingPatternMeta,
        ),
      );
    }
    if (data.containsKey('calendar_preference')) {
      context.handle(
        _calendarPreferenceMeta,
        calendarPreference.isAcceptableOrUnknown(
          data['calendar_preference']!,
          _calendarPreferenceMeta,
        ),
      );
    }
    if (data.containsKey('energy_enabled')) {
      context.handle(
        _energyEnabledMeta,
        energyEnabled.isAcceptableOrUnknown(
          data['energy_enabled']!,
          _energyEnabledMeta,
        ),
      );
    }
    if (data.containsKey('preferred_break_minutes')) {
      context.handle(
        _preferredBreakMinutesMeta,
        preferredBreakMinutes.isAcceptableOrUnknown(
          data['preferred_break_minutes']!,
          _preferredBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('contingency_minutes')) {
      context.handle(
        _contingencyMinutesMeta,
        contingencyMinutes.isAcceptableOrUnknown(
          data['contingency_minutes']!,
          _contingencyMinutesMeta,
        ),
      );
    }
    if (data.containsKey('transition_minutes')) {
      context.handle(
        _transitionMinutesMeta,
        transitionMinutes.isAcceptableOrUnknown(
          data['transition_minutes']!,
          _transitionMinutesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      sampleDataEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sample_data_enabled'],
      )!,
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_time'],
      )!,
      windDownTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wind_down_time'],
      )!,
      workStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_start_time'],
      )!,
      workEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_end_time'],
      )!,
      planningStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planning_style'],
      )!,
      workingPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}working_pattern'],
      )!,
      calendarPreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_preference'],
      )!,
      energyEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}energy_enabled'],
      )!,
      preferredBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preferred_break_minutes'],
      )!,
      contingencyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contingency_minutes'],
      )!,
      transitionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transition_minutes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final String id;
  final bool onboardingCompleted;
  final bool sampleDataEnabled;
  final String wakeTime;
  final String windDownTime;
  final String workStartTime;
  final String workEndTime;
  final String planningStyle;
  final String workingPattern;
  final String calendarPreference;
  final bool energyEnabled;
  final int preferredBreakMinutes;
  final int contingencyMinutes;
  final int transitionMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserPreference({
    required this.id,
    required this.onboardingCompleted,
    required this.sampleDataEnabled,
    required this.wakeTime,
    required this.windDownTime,
    required this.workStartTime,
    required this.workEndTime,
    required this.planningStyle,
    required this.workingPattern,
    required this.calendarPreference,
    required this.energyEnabled,
    required this.preferredBreakMinutes,
    required this.contingencyMinutes,
    required this.transitionMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['sample_data_enabled'] = Variable<bool>(sampleDataEnabled);
    map['wake_time'] = Variable<String>(wakeTime);
    map['wind_down_time'] = Variable<String>(windDownTime);
    map['work_start_time'] = Variable<String>(workStartTime);
    map['work_end_time'] = Variable<String>(workEndTime);
    map['planning_style'] = Variable<String>(planningStyle);
    map['working_pattern'] = Variable<String>(workingPattern);
    map['calendar_preference'] = Variable<String>(calendarPreference);
    map['energy_enabled'] = Variable<bool>(energyEnabled);
    map['preferred_break_minutes'] = Variable<int>(preferredBreakMinutes);
    map['contingency_minutes'] = Variable<int>(contingencyMinutes);
    map['transition_minutes'] = Variable<int>(transitionMinutes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      onboardingCompleted: Value(onboardingCompleted),
      sampleDataEnabled: Value(sampleDataEnabled),
      wakeTime: Value(wakeTime),
      windDownTime: Value(windDownTime),
      workStartTime: Value(workStartTime),
      workEndTime: Value(workEndTime),
      planningStyle: Value(planningStyle),
      workingPattern: Value(workingPattern),
      calendarPreference: Value(calendarPreference),
      energyEnabled: Value(energyEnabled),
      preferredBreakMinutes: Value(preferredBreakMinutes),
      contingencyMinutes: Value(contingencyMinutes),
      transitionMinutes: Value(transitionMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      id: serializer.fromJson<String>(json['id']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      sampleDataEnabled: serializer.fromJson<bool>(json['sampleDataEnabled']),
      wakeTime: serializer.fromJson<String>(json['wakeTime']),
      windDownTime: serializer.fromJson<String>(json['windDownTime']),
      workStartTime: serializer.fromJson<String>(json['workStartTime']),
      workEndTime: serializer.fromJson<String>(json['workEndTime']),
      planningStyle: serializer.fromJson<String>(json['planningStyle']),
      workingPattern: serializer.fromJson<String>(json['workingPattern']),
      calendarPreference: serializer.fromJson<String>(
        json['calendarPreference'],
      ),
      energyEnabled: serializer.fromJson<bool>(json['energyEnabled']),
      preferredBreakMinutes: serializer.fromJson<int>(
        json['preferredBreakMinutes'],
      ),
      contingencyMinutes: serializer.fromJson<int>(json['contingencyMinutes']),
      transitionMinutes: serializer.fromJson<int>(json['transitionMinutes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'sampleDataEnabled': serializer.toJson<bool>(sampleDataEnabled),
      'wakeTime': serializer.toJson<String>(wakeTime),
      'windDownTime': serializer.toJson<String>(windDownTime),
      'workStartTime': serializer.toJson<String>(workStartTime),
      'workEndTime': serializer.toJson<String>(workEndTime),
      'planningStyle': serializer.toJson<String>(planningStyle),
      'workingPattern': serializer.toJson<String>(workingPattern),
      'calendarPreference': serializer.toJson<String>(calendarPreference),
      'energyEnabled': serializer.toJson<bool>(energyEnabled),
      'preferredBreakMinutes': serializer.toJson<int>(preferredBreakMinutes),
      'contingencyMinutes': serializer.toJson<int>(contingencyMinutes),
      'transitionMinutes': serializer.toJson<int>(transitionMinutes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreference copyWith({
    String? id,
    bool? onboardingCompleted,
    bool? sampleDataEnabled,
    String? wakeTime,
    String? windDownTime,
    String? workStartTime,
    String? workEndTime,
    String? planningStyle,
    String? workingPattern,
    String? calendarPreference,
    bool? energyEnabled,
    int? preferredBreakMinutes,
    int? contingencyMinutes,
    int? transitionMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserPreference(
    id: id ?? this.id,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    sampleDataEnabled: sampleDataEnabled ?? this.sampleDataEnabled,
    wakeTime: wakeTime ?? this.wakeTime,
    windDownTime: windDownTime ?? this.windDownTime,
    workStartTime: workStartTime ?? this.workStartTime,
    workEndTime: workEndTime ?? this.workEndTime,
    planningStyle: planningStyle ?? this.planningStyle,
    workingPattern: workingPattern ?? this.workingPattern,
    calendarPreference: calendarPreference ?? this.calendarPreference,
    energyEnabled: energyEnabled ?? this.energyEnabled,
    preferredBreakMinutes: preferredBreakMinutes ?? this.preferredBreakMinutes,
    contingencyMinutes: contingencyMinutes ?? this.contingencyMinutes,
    transitionMinutes: transitionMinutes ?? this.transitionMinutes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      id: data.id.present ? data.id.value : this.id,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      sampleDataEnabled: data.sampleDataEnabled.present
          ? data.sampleDataEnabled.value
          : this.sampleDataEnabled,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      windDownTime: data.windDownTime.present
          ? data.windDownTime.value
          : this.windDownTime,
      workStartTime: data.workStartTime.present
          ? data.workStartTime.value
          : this.workStartTime,
      workEndTime: data.workEndTime.present
          ? data.workEndTime.value
          : this.workEndTime,
      planningStyle: data.planningStyle.present
          ? data.planningStyle.value
          : this.planningStyle,
      workingPattern: data.workingPattern.present
          ? data.workingPattern.value
          : this.workingPattern,
      calendarPreference: data.calendarPreference.present
          ? data.calendarPreference.value
          : this.calendarPreference,
      energyEnabled: data.energyEnabled.present
          ? data.energyEnabled.value
          : this.energyEnabled,
      preferredBreakMinutes: data.preferredBreakMinutes.present
          ? data.preferredBreakMinutes.value
          : this.preferredBreakMinutes,
      contingencyMinutes: data.contingencyMinutes.present
          ? data.contingencyMinutes.value
          : this.contingencyMinutes,
      transitionMinutes: data.transitionMinutes.present
          ? data.transitionMinutes.value
          : this.transitionMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('id: $id, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('sampleDataEnabled: $sampleDataEnabled, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('windDownTime: $windDownTime, ')
          ..write('workStartTime: $workStartTime, ')
          ..write('workEndTime: $workEndTime, ')
          ..write('planningStyle: $planningStyle, ')
          ..write('workingPattern: $workingPattern, ')
          ..write('calendarPreference: $calendarPreference, ')
          ..write('energyEnabled: $energyEnabled, ')
          ..write('preferredBreakMinutes: $preferredBreakMinutes, ')
          ..write('contingencyMinutes: $contingencyMinutes, ')
          ..write('transitionMinutes: $transitionMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    onboardingCompleted,
    sampleDataEnabled,
    wakeTime,
    windDownTime,
    workStartTime,
    workEndTime,
    planningStyle,
    workingPattern,
    calendarPreference,
    energyEnabled,
    preferredBreakMinutes,
    contingencyMinutes,
    transitionMinutes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.id == this.id &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.sampleDataEnabled == this.sampleDataEnabled &&
          other.wakeTime == this.wakeTime &&
          other.windDownTime == this.windDownTime &&
          other.workStartTime == this.workStartTime &&
          other.workEndTime == this.workEndTime &&
          other.planningStyle == this.planningStyle &&
          other.workingPattern == this.workingPattern &&
          other.calendarPreference == this.calendarPreference &&
          other.energyEnabled == this.energyEnabled &&
          other.preferredBreakMinutes == this.preferredBreakMinutes &&
          other.contingencyMinutes == this.contingencyMinutes &&
          other.transitionMinutes == this.transitionMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<String> id;
  final Value<bool> onboardingCompleted;
  final Value<bool> sampleDataEnabled;
  final Value<String> wakeTime;
  final Value<String> windDownTime;
  final Value<String> workStartTime;
  final Value<String> workEndTime;
  final Value<String> planningStyle;
  final Value<String> workingPattern;
  final Value<String> calendarPreference;
  final Value<bool> energyEnabled;
  final Value<int> preferredBreakMinutes;
  final Value<int> contingencyMinutes;
  final Value<int> transitionMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.sampleDataEnabled = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.windDownTime = const Value.absent(),
    this.workStartTime = const Value.absent(),
    this.workEndTime = const Value.absent(),
    this.planningStyle = const Value.absent(),
    this.workingPattern = const Value.absent(),
    this.calendarPreference = const Value.absent(),
    this.energyEnabled = const Value.absent(),
    this.preferredBreakMinutes = const Value.absent(),
    this.contingencyMinutes = const Value.absent(),
    this.transitionMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    required String id,
    this.onboardingCompleted = const Value.absent(),
    this.sampleDataEnabled = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.windDownTime = const Value.absent(),
    this.workStartTime = const Value.absent(),
    this.workEndTime = const Value.absent(),
    this.planningStyle = const Value.absent(),
    this.workingPattern = const Value.absent(),
    this.calendarPreference = const Value.absent(),
    this.energyEnabled = const Value.absent(),
    this.preferredBreakMinutes = const Value.absent(),
    this.contingencyMinutes = const Value.absent(),
    this.transitionMinutes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserPreference> custom({
    Expression<String>? id,
    Expression<bool>? onboardingCompleted,
    Expression<bool>? sampleDataEnabled,
    Expression<String>? wakeTime,
    Expression<String>? windDownTime,
    Expression<String>? workStartTime,
    Expression<String>? workEndTime,
    Expression<String>? planningStyle,
    Expression<String>? workingPattern,
    Expression<String>? calendarPreference,
    Expression<bool>? energyEnabled,
    Expression<int>? preferredBreakMinutes,
    Expression<int>? contingencyMinutes,
    Expression<int>? transitionMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (sampleDataEnabled != null) 'sample_data_enabled': sampleDataEnabled,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (windDownTime != null) 'wind_down_time': windDownTime,
      if (workStartTime != null) 'work_start_time': workStartTime,
      if (workEndTime != null) 'work_end_time': workEndTime,
      if (planningStyle != null) 'planning_style': planningStyle,
      if (workingPattern != null) 'working_pattern': workingPattern,
      if (calendarPreference != null) 'calendar_preference': calendarPreference,
      if (energyEnabled != null) 'energy_enabled': energyEnabled,
      if (preferredBreakMinutes != null)
        'preferred_break_minutes': preferredBreakMinutes,
      if (contingencyMinutes != null) 'contingency_minutes': contingencyMinutes,
      if (transitionMinutes != null) 'transition_minutes': transitionMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesCompanion copyWith({
    Value<String>? id,
    Value<bool>? onboardingCompleted,
    Value<bool>? sampleDataEnabled,
    Value<String>? wakeTime,
    Value<String>? windDownTime,
    Value<String>? workStartTime,
    Value<String>? workEndTime,
    Value<String>? planningStyle,
    Value<String>? workingPattern,
    Value<String>? calendarPreference,
    Value<bool>? energyEnabled,
    Value<int>? preferredBreakMinutes,
    Value<int>? contingencyMinutes,
    Value<int>? transitionMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      sampleDataEnabled: sampleDataEnabled ?? this.sampleDataEnabled,
      wakeTime: wakeTime ?? this.wakeTime,
      windDownTime: windDownTime ?? this.windDownTime,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      planningStyle: planningStyle ?? this.planningStyle,
      workingPattern: workingPattern ?? this.workingPattern,
      calendarPreference: calendarPreference ?? this.calendarPreference,
      energyEnabled: energyEnabled ?? this.energyEnabled,
      preferredBreakMinutes:
          preferredBreakMinutes ?? this.preferredBreakMinutes,
      contingencyMinutes: contingencyMinutes ?? this.contingencyMinutes,
      transitionMinutes: transitionMinutes ?? this.transitionMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (sampleDataEnabled.present) {
      map['sample_data_enabled'] = Variable<bool>(sampleDataEnabled.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<String>(wakeTime.value);
    }
    if (windDownTime.present) {
      map['wind_down_time'] = Variable<String>(windDownTime.value);
    }
    if (workStartTime.present) {
      map['work_start_time'] = Variable<String>(workStartTime.value);
    }
    if (workEndTime.present) {
      map['work_end_time'] = Variable<String>(workEndTime.value);
    }
    if (planningStyle.present) {
      map['planning_style'] = Variable<String>(planningStyle.value);
    }
    if (workingPattern.present) {
      map['working_pattern'] = Variable<String>(workingPattern.value);
    }
    if (calendarPreference.present) {
      map['calendar_preference'] = Variable<String>(calendarPreference.value);
    }
    if (energyEnabled.present) {
      map['energy_enabled'] = Variable<bool>(energyEnabled.value);
    }
    if (preferredBreakMinutes.present) {
      map['preferred_break_minutes'] = Variable<int>(
        preferredBreakMinutes.value,
      );
    }
    if (contingencyMinutes.present) {
      map['contingency_minutes'] = Variable<int>(contingencyMinutes.value);
    }
    if (transitionMinutes.present) {
      map['transition_minutes'] = Variable<int>(transitionMinutes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('sampleDataEnabled: $sampleDataEnabled, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('windDownTime: $windDownTime, ')
          ..write('workStartTime: $workStartTime, ')
          ..write('workEndTime: $workEndTime, ')
          ..write('planningStyle: $planningStyle, ')
          ..write('workingPattern: $workingPattern, ')
          ..write('calendarPreference: $calendarPreference, ')
          ..write('energyEnabled: $energyEnabled, ')
          ..write('preferredBreakMinutes: $preferredBreakMinutes, ')
          ..write('contingencyMinutes: $contingencyMinutes, ')
          ..write('transitionMinutes: $transitionMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeBlocksTable extends TimeBlocks
    with TableInfo<$TimeBlocksTable, TimeBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayPlanIdMeta = const VerificationMeta(
    'dayPlanId',
  );
  @override
  late final GeneratedColumn<String> dayPlanId = GeneratedColumn<String>(
    'day_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES day_plans (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtMeta = const VerificationMeta('endsAt');
  @override
  late final GeneratedColumn<DateTime> endsAt = GeneratedColumn<DateTime>(
    'ends_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockTypeMeta = const VerificationMeta(
    'blockType',
  );
  @override
  late final GeneratedColumn<String> blockType = GeneratedColumn<String>(
    'block_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _travelBufferMinutesMeta =
      const VerificationMeta('travelBufferMinutes');
  @override
  late final GeneratedColumn<int> travelBufferMinutes = GeneratedColumn<int>(
    'travel_buffer_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _preparationBufferMinutesMeta =
      const VerificationMeta('preparationBufferMinutes');
  @override
  late final GeneratedColumn<int> preparationBufferMinutes =
      GeneratedColumn<int>(
        'preparation_buffer_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _transitionBufferMinutesMeta =
      const VerificationMeta('transitionBufferMinutes');
  @override
  late final GeneratedColumn<int> transitionBufferMinutes =
      GeneratedColumn<int>(
        'transition_buffer_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _recoveryBufferMinutesMeta =
      const VerificationMeta('recoveryBufferMinutes');
  @override
  late final GeneratedColumn<int> recoveryBufferMinutes = GeneratedColumn<int>(
    'recovery_buffer_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncState>($TimeBlocksTable.$convertersyncState);
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _remoteVersionMeta = const VerificationMeta(
    'remoteVersion',
  );
  @override
  late final GeneratedColumn<int> remoteVersion = GeneratedColumn<int>(
    'remote_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayPlanId,
    title,
    startsAt,
    endsAt,
    blockType,
    category,
    sourceId,
    travelBufferMinutes,
    preparationBufferMinutes,
    transitionBufferMinutes,
    recoveryBufferMinutes,
    sortOrder,
    syncState,
    localVersion,
    remoteVersion,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_blocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeBlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_plan_id')) {
      context.handle(
        _dayPlanIdMeta,
        dayPlanId.isAcceptableOrUnknown(data['day_plan_id']!, _dayPlanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayPlanIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startsAtMeta);
    }
    if (data.containsKey('ends_at')) {
      context.handle(
        _endsAtMeta,
        endsAt.isAcceptableOrUnknown(data['ends_at']!, _endsAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endsAtMeta);
    }
    if (data.containsKey('block_type')) {
      context.handle(
        _blockTypeMeta,
        blockType.isAcceptableOrUnknown(data['block_type']!, _blockTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_blockTypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('travel_buffer_minutes')) {
      context.handle(
        _travelBufferMinutesMeta,
        travelBufferMinutes.isAcceptableOrUnknown(
          data['travel_buffer_minutes']!,
          _travelBufferMinutesMeta,
        ),
      );
    }
    if (data.containsKey('preparation_buffer_minutes')) {
      context.handle(
        _preparationBufferMinutesMeta,
        preparationBufferMinutes.isAcceptableOrUnknown(
          data['preparation_buffer_minutes']!,
          _preparationBufferMinutesMeta,
        ),
      );
    }
    if (data.containsKey('transition_buffer_minutes')) {
      context.handle(
        _transitionBufferMinutesMeta,
        transitionBufferMinutes.isAcceptableOrUnknown(
          data['transition_buffer_minutes']!,
          _transitionBufferMinutesMeta,
        ),
      );
    }
    if (data.containsKey('recovery_buffer_minutes')) {
      context.handle(
        _recoveryBufferMinutesMeta,
        recoveryBufferMinutes.isAcceptableOrUnknown(
          data['recovery_buffer_minutes']!,
          _recoveryBufferMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    }
    if (data.containsKey('remote_version')) {
      context.handle(
        _remoteVersionMeta,
        remoteVersion.isAcceptableOrUnknown(
          data['remote_version']!,
          _remoteVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeBlock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_plan_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      )!,
      endsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ends_at'],
      )!,
      blockType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}block_type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      travelBufferMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}travel_buffer_minutes'],
      )!,
      preparationBufferMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preparation_buffer_minutes'],
      )!,
      transitionBufferMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transition_buffer_minutes'],
      )!,
      recoveryBufferMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recovery_buffer_minutes'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      syncState: $TimeBlocksTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
      remoteVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TimeBlocksTable createAlias(String alias) {
    return $TimeBlocksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class TimeBlock extends DataClass implements Insertable<TimeBlock> {
  final String id;
  final String dayPlanId;
  final String title;
  final DateTime startsAt;
  final DateTime endsAt;
  final String blockType;
  final String? category;
  final String? sourceId;
  final int travelBufferMinutes;
  final int preparationBufferMinutes;
  final int transitionBufferMinutes;
  final int recoveryBufferMinutes;
  final int sortOrder;
  final SyncState syncState;
  final int localVersion;
  final int? remoteVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const TimeBlock({
    required this.id,
    required this.dayPlanId,
    required this.title,
    required this.startsAt,
    required this.endsAt,
    required this.blockType,
    this.category,
    this.sourceId,
    required this.travelBufferMinutes,
    required this.preparationBufferMinutes,
    required this.transitionBufferMinutes,
    required this.recoveryBufferMinutes,
    required this.sortOrder,
    required this.syncState,
    required this.localVersion,
    this.remoteVersion,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_plan_id'] = Variable<String>(dayPlanId);
    map['title'] = Variable<String>(title);
    map['starts_at'] = Variable<DateTime>(startsAt);
    map['ends_at'] = Variable<DateTime>(endsAt);
    map['block_type'] = Variable<String>(blockType);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['travel_buffer_minutes'] = Variable<int>(travelBufferMinutes);
    map['preparation_buffer_minutes'] = Variable<int>(preparationBufferMinutes);
    map['transition_buffer_minutes'] = Variable<int>(transitionBufferMinutes);
    map['recovery_buffer_minutes'] = Variable<int>(recoveryBufferMinutes);
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['sync_state'] = Variable<String>(
        $TimeBlocksTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_version'] = Variable<int>(localVersion);
    if (!nullToAbsent || remoteVersion != null) {
      map['remote_version'] = Variable<int>(remoteVersion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TimeBlocksCompanion toCompanion(bool nullToAbsent) {
    return TimeBlocksCompanion(
      id: Value(id),
      dayPlanId: Value(dayPlanId),
      title: Value(title),
      startsAt: Value(startsAt),
      endsAt: Value(endsAt),
      blockType: Value(blockType),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      travelBufferMinutes: Value(travelBufferMinutes),
      preparationBufferMinutes: Value(preparationBufferMinutes),
      transitionBufferMinutes: Value(transitionBufferMinutes),
      recoveryBufferMinutes: Value(recoveryBufferMinutes),
      sortOrder: Value(sortOrder),
      syncState: Value(syncState),
      localVersion: Value(localVersion),
      remoteVersion: remoteVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TimeBlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeBlock(
      id: serializer.fromJson<String>(json['id']),
      dayPlanId: serializer.fromJson<String>(json['dayPlanId']),
      title: serializer.fromJson<String>(json['title']),
      startsAt: serializer.fromJson<DateTime>(json['startsAt']),
      endsAt: serializer.fromJson<DateTime>(json['endsAt']),
      blockType: serializer.fromJson<String>(json['blockType']),
      category: serializer.fromJson<String?>(json['category']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      travelBufferMinutes: serializer.fromJson<int>(
        json['travelBufferMinutes'],
      ),
      preparationBufferMinutes: serializer.fromJson<int>(
        json['preparationBufferMinutes'],
      ),
      transitionBufferMinutes: serializer.fromJson<int>(
        json['transitionBufferMinutes'],
      ),
      recoveryBufferMinutes: serializer.fromJson<int>(
        json['recoveryBufferMinutes'],
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      syncState: $TimeBlocksTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      remoteVersion: serializer.fromJson<int?>(json['remoteVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayPlanId': serializer.toJson<String>(dayPlanId),
      'title': serializer.toJson<String>(title),
      'startsAt': serializer.toJson<DateTime>(startsAt),
      'endsAt': serializer.toJson<DateTime>(endsAt),
      'blockType': serializer.toJson<String>(blockType),
      'category': serializer.toJson<String?>(category),
      'sourceId': serializer.toJson<String?>(sourceId),
      'travelBufferMinutes': serializer.toJson<int>(travelBufferMinutes),
      'preparationBufferMinutes': serializer.toJson<int>(
        preparationBufferMinutes,
      ),
      'transitionBufferMinutes': serializer.toJson<int>(
        transitionBufferMinutes,
      ),
      'recoveryBufferMinutes': serializer.toJson<int>(recoveryBufferMinutes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'syncState': serializer.toJson<String>(
        $TimeBlocksTable.$convertersyncState.toJson(syncState),
      ),
      'localVersion': serializer.toJson<int>(localVersion),
      'remoteVersion': serializer.toJson<int?>(remoteVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TimeBlock copyWith({
    String? id,
    String? dayPlanId,
    String? title,
    DateTime? startsAt,
    DateTime? endsAt,
    String? blockType,
    Value<String?> category = const Value.absent(),
    Value<String?> sourceId = const Value.absent(),
    int? travelBufferMinutes,
    int? preparationBufferMinutes,
    int? transitionBufferMinutes,
    int? recoveryBufferMinutes,
    int? sortOrder,
    SyncState? syncState,
    int? localVersion,
    Value<int?> remoteVersion = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TimeBlock(
    id: id ?? this.id,
    dayPlanId: dayPlanId ?? this.dayPlanId,
    title: title ?? this.title,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt ?? this.endsAt,
    blockType: blockType ?? this.blockType,
    category: category.present ? category.value : this.category,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    travelBufferMinutes: travelBufferMinutes ?? this.travelBufferMinutes,
    preparationBufferMinutes:
        preparationBufferMinutes ?? this.preparationBufferMinutes,
    transitionBufferMinutes:
        transitionBufferMinutes ?? this.transitionBufferMinutes,
    recoveryBufferMinutes: recoveryBufferMinutes ?? this.recoveryBufferMinutes,
    sortOrder: sortOrder ?? this.sortOrder,
    syncState: syncState ?? this.syncState,
    localVersion: localVersion ?? this.localVersion,
    remoteVersion: remoteVersion.present
        ? remoteVersion.value
        : this.remoteVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TimeBlock copyWithCompanion(TimeBlocksCompanion data) {
    return TimeBlock(
      id: data.id.present ? data.id.value : this.id,
      dayPlanId: data.dayPlanId.present ? data.dayPlanId.value : this.dayPlanId,
      title: data.title.present ? data.title.value : this.title,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      endsAt: data.endsAt.present ? data.endsAt.value : this.endsAt,
      blockType: data.blockType.present ? data.blockType.value : this.blockType,
      category: data.category.present ? data.category.value : this.category,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      travelBufferMinutes: data.travelBufferMinutes.present
          ? data.travelBufferMinutes.value
          : this.travelBufferMinutes,
      preparationBufferMinutes: data.preparationBufferMinutes.present
          ? data.preparationBufferMinutes.value
          : this.preparationBufferMinutes,
      transitionBufferMinutes: data.transitionBufferMinutes.present
          ? data.transitionBufferMinutes.value
          : this.transitionBufferMinutes,
      recoveryBufferMinutes: data.recoveryBufferMinutes.present
          ? data.recoveryBufferMinutes.value
          : this.recoveryBufferMinutes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      remoteVersion: data.remoteVersion.present
          ? data.remoteVersion.value
          : this.remoteVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeBlock(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('blockType: $blockType, ')
          ..write('category: $category, ')
          ..write('sourceId: $sourceId, ')
          ..write('travelBufferMinutes: $travelBufferMinutes, ')
          ..write('preparationBufferMinutes: $preparationBufferMinutes, ')
          ..write('transitionBufferMinutes: $transitionBufferMinutes, ')
          ..write('recoveryBufferMinutes: $recoveryBufferMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('syncState: $syncState, ')
          ..write('localVersion: $localVersion, ')
          ..write('remoteVersion: $remoteVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayPlanId,
    title,
    startsAt,
    endsAt,
    blockType,
    category,
    sourceId,
    travelBufferMinutes,
    preparationBufferMinutes,
    transitionBufferMinutes,
    recoveryBufferMinutes,
    sortOrder,
    syncState,
    localVersion,
    remoteVersion,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeBlock &&
          other.id == this.id &&
          other.dayPlanId == this.dayPlanId &&
          other.title == this.title &&
          other.startsAt == this.startsAt &&
          other.endsAt == this.endsAt &&
          other.blockType == this.blockType &&
          other.category == this.category &&
          other.sourceId == this.sourceId &&
          other.travelBufferMinutes == this.travelBufferMinutes &&
          other.preparationBufferMinutes == this.preparationBufferMinutes &&
          other.transitionBufferMinutes == this.transitionBufferMinutes &&
          other.recoveryBufferMinutes == this.recoveryBufferMinutes &&
          other.sortOrder == this.sortOrder &&
          other.syncState == this.syncState &&
          other.localVersion == this.localVersion &&
          other.remoteVersion == this.remoteVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TimeBlocksCompanion extends UpdateCompanion<TimeBlock> {
  final Value<String> id;
  final Value<String> dayPlanId;
  final Value<String> title;
  final Value<DateTime> startsAt;
  final Value<DateTime> endsAt;
  final Value<String> blockType;
  final Value<String?> category;
  final Value<String?> sourceId;
  final Value<int> travelBufferMinutes;
  final Value<int> preparationBufferMinutes;
  final Value<int> transitionBufferMinutes;
  final Value<int> recoveryBufferMinutes;
  final Value<int> sortOrder;
  final Value<SyncState> syncState;
  final Value<int> localVersion;
  final Value<int?> remoteVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TimeBlocksCompanion({
    this.id = const Value.absent(),
    this.dayPlanId = const Value.absent(),
    this.title = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.endsAt = const Value.absent(),
    this.blockType = const Value.absent(),
    this.category = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.travelBufferMinutes = const Value.absent(),
    this.preparationBufferMinutes = const Value.absent(),
    this.transitionBufferMinutes = const Value.absent(),
    this.recoveryBufferMinutes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.remoteVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeBlocksCompanion.insert({
    required String id,
    required String dayPlanId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
    this.category = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.travelBufferMinutes = const Value.absent(),
    this.preparationBufferMinutes = const Value.absent(),
    this.transitionBufferMinutes = const Value.absent(),
    this.recoveryBufferMinutes = const Value.absent(),
    required int sortOrder,
    required SyncState syncState,
    this.localVersion = const Value.absent(),
    this.remoteVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayPlanId = Value(dayPlanId),
       title = Value(title),
       startsAt = Value(startsAt),
       endsAt = Value(endsAt),
       blockType = Value(blockType),
       sortOrder = Value(sortOrder),
       syncState = Value(syncState),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TimeBlock> custom({
    Expression<String>? id,
    Expression<String>? dayPlanId,
    Expression<String>? title,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? endsAt,
    Expression<String>? blockType,
    Expression<String>? category,
    Expression<String>? sourceId,
    Expression<int>? travelBufferMinutes,
    Expression<int>? preparationBufferMinutes,
    Expression<int>? transitionBufferMinutes,
    Expression<int>? recoveryBufferMinutes,
    Expression<int>? sortOrder,
    Expression<String>? syncState,
    Expression<int>? localVersion,
    Expression<int>? remoteVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayPlanId != null) 'day_plan_id': dayPlanId,
      if (title != null) 'title': title,
      if (startsAt != null) 'starts_at': startsAt,
      if (endsAt != null) 'ends_at': endsAt,
      if (blockType != null) 'block_type': blockType,
      if (category != null) 'category': category,
      if (sourceId != null) 'source_id': sourceId,
      if (travelBufferMinutes != null)
        'travel_buffer_minutes': travelBufferMinutes,
      if (preparationBufferMinutes != null)
        'preparation_buffer_minutes': preparationBufferMinutes,
      if (transitionBufferMinutes != null)
        'transition_buffer_minutes': transitionBufferMinutes,
      if (recoveryBufferMinutes != null)
        'recovery_buffer_minutes': recoveryBufferMinutes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (syncState != null) 'sync_state': syncState,
      if (localVersion != null) 'local_version': localVersion,
      if (remoteVersion != null) 'remote_version': remoteVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeBlocksCompanion copyWith({
    Value<String>? id,
    Value<String>? dayPlanId,
    Value<String>? title,
    Value<DateTime>? startsAt,
    Value<DateTime>? endsAt,
    Value<String>? blockType,
    Value<String?>? category,
    Value<String?>? sourceId,
    Value<int>? travelBufferMinutes,
    Value<int>? preparationBufferMinutes,
    Value<int>? transitionBufferMinutes,
    Value<int>? recoveryBufferMinutes,
    Value<int>? sortOrder,
    Value<SyncState>? syncState,
    Value<int>? localVersion,
    Value<int?>? remoteVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TimeBlocksCompanion(
      id: id ?? this.id,
      dayPlanId: dayPlanId ?? this.dayPlanId,
      title: title ?? this.title,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      blockType: blockType ?? this.blockType,
      category: category ?? this.category,
      sourceId: sourceId ?? this.sourceId,
      travelBufferMinutes: travelBufferMinutes ?? this.travelBufferMinutes,
      preparationBufferMinutes:
          preparationBufferMinutes ?? this.preparationBufferMinutes,
      transitionBufferMinutes:
          transitionBufferMinutes ?? this.transitionBufferMinutes,
      recoveryBufferMinutes:
          recoveryBufferMinutes ?? this.recoveryBufferMinutes,
      sortOrder: sortOrder ?? this.sortOrder,
      syncState: syncState ?? this.syncState,
      localVersion: localVersion ?? this.localVersion,
      remoteVersion: remoteVersion ?? this.remoteVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayPlanId.present) {
      map['day_plan_id'] = Variable<String>(dayPlanId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (endsAt.present) {
      map['ends_at'] = Variable<DateTime>(endsAt.value);
    }
    if (blockType.present) {
      map['block_type'] = Variable<String>(blockType.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (travelBufferMinutes.present) {
      map['travel_buffer_minutes'] = Variable<int>(travelBufferMinutes.value);
    }
    if (preparationBufferMinutes.present) {
      map['preparation_buffer_minutes'] = Variable<int>(
        preparationBufferMinutes.value,
      );
    }
    if (transitionBufferMinutes.present) {
      map['transition_buffer_minutes'] = Variable<int>(
        transitionBufferMinutes.value,
      );
    }
    if (recoveryBufferMinutes.present) {
      map['recovery_buffer_minutes'] = Variable<int>(
        recoveryBufferMinutes.value,
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $TimeBlocksTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (remoteVersion.present) {
      map['remote_version'] = Variable<int>(remoteVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeBlocksCompanion(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('title: $title, ')
          ..write('startsAt: $startsAt, ')
          ..write('endsAt: $endsAt, ')
          ..write('blockType: $blockType, ')
          ..write('category: $category, ')
          ..write('sourceId: $sourceId, ')
          ..write('travelBufferMinutes: $travelBufferMinutes, ')
          ..write('preparationBufferMinutes: $preparationBufferMinutes, ')
          ..write('transitionBufferMinutes: $transitionBufferMinutes, ')
          ..write('recoveryBufferMinutes: $recoveryBufferMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('syncState: $syncState, ')
          ..write('localVersion: $localVersion, ')
          ..write('remoteVersion: $remoteVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayPlanIdMeta = const VerificationMeta(
    'dayPlanId',
  );
  @override
  late final GeneratedColumn<String> dayPlanId = GeneratedColumn<String>(
    'day_plan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES day_plans (id)',
    ),
  );
  static const VerificationMeta _blockIdMeta = const VerificationMeta(
    'blockId',
  );
  @override
  late final GeneratedColumn<String> blockId = GeneratedColumn<String>(
    'block_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES time_blocks (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyRequiredMeta = const VerificationMeta(
    'energyRequired',
  );
  @override
  late final GeneratedColumn<String> energyRequired = GeneratedColumn<String>(
    'energy_required',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestedDayMeta = const VerificationMeta(
    'requestedDay',
  );
  @override
  late final GeneratedColumn<String> requestedDay = GeneratedColumn<String>(
    'requested_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestedStartTimeMeta =
      const VerificationMeta('requestedStartTime');
  @override
  late final GeneratedColumn<String> requestedStartTime =
      GeneratedColumn<String>(
        'requested_start_time',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _requestedEndTimeMeta = const VerificationMeta(
    'requestedEndTime',
  );
  @override
  late final GeneratedColumn<String> requestedEndTime = GeneratedColumn<String>(
    'requested_end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _approximateTimeMeta = const VerificationMeta(
    'approximateTime',
  );
  @override
  late final GeneratedColumn<bool> approximateTime = GeneratedColumn<bool>(
    'approximate_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("approximate_time" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualMinutesMeta = const VerificationMeta(
    'actualMinutes',
  );
  @override
  late final GeneratedColumn<int> actualMinutes = GeneratedColumn<int>(
    'actual_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canSplitMeta = const VerificationMeta(
    'canSplit',
  );
  @override
  late final GeneratedColumn<bool> canSplit = GeneratedColumn<bool>(
    'can_split',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("can_split" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _minimumUsefulMinutesMeta =
      const VerificationMeta('minimumUsefulMinutes');
  @override
  late final GeneratedColumn<int> minimumUsefulMinutes = GeneratedColumn<int>(
    'minimum_useful_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncState, String> syncState =
      GeneratedColumn<String>(
        'sync_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncState>($TasksTable.$convertersyncState);
  static const VerificationMeta _localVersionMeta = const VerificationMeta(
    'localVersion',
  );
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
    'local_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _remoteVersionMeta = const VerificationMeta(
    'remoteVersion',
  );
  @override
  late final GeneratedColumn<int> remoteVersion = GeneratedColumn<int>(
    'remote_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayPlanId,
    blockId,
    title,
    notes,
    energyRequired,
    requestedDay,
    requestedStartTime,
    requestedEndTime,
    approximateTime,
    estimatedMinutes,
    actualMinutes,
    priority,
    category,
    status,
    sourceId,
    deadline,
    canSplit,
    minimumUsefulMinutes,
    sortOrder,
    syncState,
    localVersion,
    remoteVersion,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_plan_id')) {
      context.handle(
        _dayPlanIdMeta,
        dayPlanId.isAcceptableOrUnknown(data['day_plan_id']!, _dayPlanIdMeta),
      );
    }
    if (data.containsKey('block_id')) {
      context.handle(
        _blockIdMeta,
        blockId.isAcceptableOrUnknown(data['block_id']!, _blockIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('energy_required')) {
      context.handle(
        _energyRequiredMeta,
        energyRequired.isAcceptableOrUnknown(
          data['energy_required']!,
          _energyRequiredMeta,
        ),
      );
    }
    if (data.containsKey('requested_day')) {
      context.handle(
        _requestedDayMeta,
        requestedDay.isAcceptableOrUnknown(
          data['requested_day']!,
          _requestedDayMeta,
        ),
      );
    }
    if (data.containsKey('requested_start_time')) {
      context.handle(
        _requestedStartTimeMeta,
        requestedStartTime.isAcceptableOrUnknown(
          data['requested_start_time']!,
          _requestedStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('requested_end_time')) {
      context.handle(
        _requestedEndTimeMeta,
        requestedEndTime.isAcceptableOrUnknown(
          data['requested_end_time']!,
          _requestedEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('approximate_time')) {
      context.handle(
        _approximateTimeMeta,
        approximateTime.isAcceptableOrUnknown(
          data['approximate_time']!,
          _approximateTimeMeta,
        ),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    if (data.containsKey('actual_minutes')) {
      context.handle(
        _actualMinutesMeta,
        actualMinutes.isAcceptableOrUnknown(
          data['actual_minutes']!,
          _actualMinutesMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('can_split')) {
      context.handle(
        _canSplitMeta,
        canSplit.isAcceptableOrUnknown(data['can_split']!, _canSplitMeta),
      );
    }
    if (data.containsKey('minimum_useful_minutes')) {
      context.handle(
        _minimumUsefulMinutesMeta,
        minimumUsefulMinutes.isAcceptableOrUnknown(
          data['minimum_useful_minutes']!,
          _minimumUsefulMinutesMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('local_version')) {
      context.handle(
        _localVersionMeta,
        localVersion.isAcceptableOrUnknown(
          data['local_version']!,
          _localVersionMeta,
        ),
      );
    }
    if (data.containsKey('remote_version')) {
      context.handle(
        _remoteVersionMeta,
        remoteVersion.isAcceptableOrUnknown(
          data['remote_version']!,
          _remoteVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_plan_id'],
      ),
      blockId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}block_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      energyRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}energy_required'],
      ),
      requestedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requested_day'],
      ),
      requestedStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requested_start_time'],
      ),
      requestedEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requested_end_time'],
      ),
      approximateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}approximate_time'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      actualMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_minutes'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      canSplit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}can_split'],
      )!,
      minimumUsefulMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_useful_minutes'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      syncState: $TasksTable.$convertersyncState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_state'],
        )!,
      ),
      localVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_version'],
      )!,
      remoteVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncState, String, String> $convertersyncState =
      const EnumNameConverter<SyncState>(SyncState.values);
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String? dayPlanId;
  final String? blockId;
  final String title;
  final String? notes;
  final String? energyRequired;
  final String? requestedDay;
  final String? requestedStartTime;
  final String? requestedEndTime;
  final bool approximateTime;
  final int estimatedMinutes;
  final int? actualMinutes;
  final String priority;
  final String? category;
  final String status;
  final String? sourceId;
  final DateTime? deadline;
  final bool canSplit;
  final int minimumUsefulMinutes;
  final int sortOrder;
  final SyncState syncState;
  final int localVersion;
  final int? remoteVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Task({
    required this.id,
    this.dayPlanId,
    this.blockId,
    required this.title,
    this.notes,
    this.energyRequired,
    this.requestedDay,
    this.requestedStartTime,
    this.requestedEndTime,
    required this.approximateTime,
    required this.estimatedMinutes,
    this.actualMinutes,
    required this.priority,
    this.category,
    required this.status,
    this.sourceId,
    this.deadline,
    required this.canSplit,
    required this.minimumUsefulMinutes,
    required this.sortOrder,
    required this.syncState,
    required this.localVersion,
    this.remoteVersion,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || dayPlanId != null) {
      map['day_plan_id'] = Variable<String>(dayPlanId);
    }
    if (!nullToAbsent || blockId != null) {
      map['block_id'] = Variable<String>(blockId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || energyRequired != null) {
      map['energy_required'] = Variable<String>(energyRequired);
    }
    if (!nullToAbsent || requestedDay != null) {
      map['requested_day'] = Variable<String>(requestedDay);
    }
    if (!nullToAbsent || requestedStartTime != null) {
      map['requested_start_time'] = Variable<String>(requestedStartTime);
    }
    if (!nullToAbsent || requestedEndTime != null) {
      map['requested_end_time'] = Variable<String>(requestedEndTime);
    }
    map['approximate_time'] = Variable<bool>(approximateTime);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    if (!nullToAbsent || actualMinutes != null) {
      map['actual_minutes'] = Variable<int>(actualMinutes);
    }
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['can_split'] = Variable<bool>(canSplit);
    map['minimum_useful_minutes'] = Variable<int>(minimumUsefulMinutes);
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['sync_state'] = Variable<String>(
        $TasksTable.$convertersyncState.toSql(syncState),
      );
    }
    map['local_version'] = Variable<int>(localVersion);
    if (!nullToAbsent || remoteVersion != null) {
      map['remote_version'] = Variable<int>(remoteVersion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      dayPlanId: dayPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(dayPlanId),
      blockId: blockId == null && nullToAbsent
          ? const Value.absent()
          : Value(blockId),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      energyRequired: energyRequired == null && nullToAbsent
          ? const Value.absent()
          : Value(energyRequired),
      requestedDay: requestedDay == null && nullToAbsent
          ? const Value.absent()
          : Value(requestedDay),
      requestedStartTime: requestedStartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(requestedStartTime),
      requestedEndTime: requestedEndTime == null && nullToAbsent
          ? const Value.absent()
          : Value(requestedEndTime),
      approximateTime: Value(approximateTime),
      estimatedMinutes: Value(estimatedMinutes),
      actualMinutes: actualMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(actualMinutes),
      priority: Value(priority),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      status: Value(status),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      canSplit: Value(canSplit),
      minimumUsefulMinutes: Value(minimumUsefulMinutes),
      sortOrder: Value(sortOrder),
      syncState: Value(syncState),
      localVersion: Value(localVersion),
      remoteVersion: remoteVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      dayPlanId: serializer.fromJson<String?>(json['dayPlanId']),
      blockId: serializer.fromJson<String?>(json['blockId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      energyRequired: serializer.fromJson<String?>(json['energyRequired']),
      requestedDay: serializer.fromJson<String?>(json['requestedDay']),
      requestedStartTime: serializer.fromJson<String?>(
        json['requestedStartTime'],
      ),
      requestedEndTime: serializer.fromJson<String?>(json['requestedEndTime']),
      approximateTime: serializer.fromJson<bool>(json['approximateTime']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      actualMinutes: serializer.fromJson<int?>(json['actualMinutes']),
      priority: serializer.fromJson<String>(json['priority']),
      category: serializer.fromJson<String?>(json['category']),
      status: serializer.fromJson<String>(json['status']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      canSplit: serializer.fromJson<bool>(json['canSplit']),
      minimumUsefulMinutes: serializer.fromJson<int>(
        json['minimumUsefulMinutes'],
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      syncState: $TasksTable.$convertersyncState.fromJson(
        serializer.fromJson<String>(json['syncState']),
      ),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      remoteVersion: serializer.fromJson<int?>(json['remoteVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayPlanId': serializer.toJson<String?>(dayPlanId),
      'blockId': serializer.toJson<String?>(blockId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'energyRequired': serializer.toJson<String?>(energyRequired),
      'requestedDay': serializer.toJson<String?>(requestedDay),
      'requestedStartTime': serializer.toJson<String?>(requestedStartTime),
      'requestedEndTime': serializer.toJson<String?>(requestedEndTime),
      'approximateTime': serializer.toJson<bool>(approximateTime),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'actualMinutes': serializer.toJson<int?>(actualMinutes),
      'priority': serializer.toJson<String>(priority),
      'category': serializer.toJson<String?>(category),
      'status': serializer.toJson<String>(status),
      'sourceId': serializer.toJson<String?>(sourceId),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'canSplit': serializer.toJson<bool>(canSplit),
      'minimumUsefulMinutes': serializer.toJson<int>(minimumUsefulMinutes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'syncState': serializer.toJson<String>(
        $TasksTable.$convertersyncState.toJson(syncState),
      ),
      'localVersion': serializer.toJson<int>(localVersion),
      'remoteVersion': serializer.toJson<int?>(remoteVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Task copyWith({
    String? id,
    Value<String?> dayPlanId = const Value.absent(),
    Value<String?> blockId = const Value.absent(),
    String? title,
    Value<String?> notes = const Value.absent(),
    Value<String?> energyRequired = const Value.absent(),
    Value<String?> requestedDay = const Value.absent(),
    Value<String?> requestedStartTime = const Value.absent(),
    Value<String?> requestedEndTime = const Value.absent(),
    bool? approximateTime,
    int? estimatedMinutes,
    Value<int?> actualMinutes = const Value.absent(),
    String? priority,
    Value<String?> category = const Value.absent(),
    String? status,
    Value<String?> sourceId = const Value.absent(),
    Value<DateTime?> deadline = const Value.absent(),
    bool? canSplit,
    int? minimumUsefulMinutes,
    int? sortOrder,
    SyncState? syncState,
    int? localVersion,
    Value<int?> remoteVersion = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Task(
    id: id ?? this.id,
    dayPlanId: dayPlanId.present ? dayPlanId.value : this.dayPlanId,
    blockId: blockId.present ? blockId.value : this.blockId,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    energyRequired: energyRequired.present
        ? energyRequired.value
        : this.energyRequired,
    requestedDay: requestedDay.present ? requestedDay.value : this.requestedDay,
    requestedStartTime: requestedStartTime.present
        ? requestedStartTime.value
        : this.requestedStartTime,
    requestedEndTime: requestedEndTime.present
        ? requestedEndTime.value
        : this.requestedEndTime,
    approximateTime: approximateTime ?? this.approximateTime,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    actualMinutes: actualMinutes.present
        ? actualMinutes.value
        : this.actualMinutes,
    priority: priority ?? this.priority,
    category: category.present ? category.value : this.category,
    status: status ?? this.status,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    deadline: deadline.present ? deadline.value : this.deadline,
    canSplit: canSplit ?? this.canSplit,
    minimumUsefulMinutes: minimumUsefulMinutes ?? this.minimumUsefulMinutes,
    sortOrder: sortOrder ?? this.sortOrder,
    syncState: syncState ?? this.syncState,
    localVersion: localVersion ?? this.localVersion,
    remoteVersion: remoteVersion.present
        ? remoteVersion.value
        : this.remoteVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      dayPlanId: data.dayPlanId.present ? data.dayPlanId.value : this.dayPlanId,
      blockId: data.blockId.present ? data.blockId.value : this.blockId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      energyRequired: data.energyRequired.present
          ? data.energyRequired.value
          : this.energyRequired,
      requestedDay: data.requestedDay.present
          ? data.requestedDay.value
          : this.requestedDay,
      requestedStartTime: data.requestedStartTime.present
          ? data.requestedStartTime.value
          : this.requestedStartTime,
      requestedEndTime: data.requestedEndTime.present
          ? data.requestedEndTime.value
          : this.requestedEndTime,
      approximateTime: data.approximateTime.present
          ? data.approximateTime.value
          : this.approximateTime,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      actualMinutes: data.actualMinutes.present
          ? data.actualMinutes.value
          : this.actualMinutes,
      priority: data.priority.present ? data.priority.value : this.priority,
      category: data.category.present ? data.category.value : this.category,
      status: data.status.present ? data.status.value : this.status,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      canSplit: data.canSplit.present ? data.canSplit.value : this.canSplit,
      minimumUsefulMinutes: data.minimumUsefulMinutes.present
          ? data.minimumUsefulMinutes.value
          : this.minimumUsefulMinutes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      remoteVersion: data.remoteVersion.present
          ? data.remoteVersion.value
          : this.remoteVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('blockId: $blockId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('energyRequired: $energyRequired, ')
          ..write('requestedDay: $requestedDay, ')
          ..write('requestedStartTime: $requestedStartTime, ')
          ..write('requestedEndTime: $requestedEndTime, ')
          ..write('approximateTime: $approximateTime, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('priority: $priority, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('sourceId: $sourceId, ')
          ..write('deadline: $deadline, ')
          ..write('canSplit: $canSplit, ')
          ..write('minimumUsefulMinutes: $minimumUsefulMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('syncState: $syncState, ')
          ..write('localVersion: $localVersion, ')
          ..write('remoteVersion: $remoteVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    dayPlanId,
    blockId,
    title,
    notes,
    energyRequired,
    requestedDay,
    requestedStartTime,
    requestedEndTime,
    approximateTime,
    estimatedMinutes,
    actualMinutes,
    priority,
    category,
    status,
    sourceId,
    deadline,
    canSplit,
    minimumUsefulMinutes,
    sortOrder,
    syncState,
    localVersion,
    remoteVersion,
    createdAt,
    updatedAt,
    deletedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.dayPlanId == this.dayPlanId &&
          other.blockId == this.blockId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.energyRequired == this.energyRequired &&
          other.requestedDay == this.requestedDay &&
          other.requestedStartTime == this.requestedStartTime &&
          other.requestedEndTime == this.requestedEndTime &&
          other.approximateTime == this.approximateTime &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.actualMinutes == this.actualMinutes &&
          other.priority == this.priority &&
          other.category == this.category &&
          other.status == this.status &&
          other.sourceId == this.sourceId &&
          other.deadline == this.deadline &&
          other.canSplit == this.canSplit &&
          other.minimumUsefulMinutes == this.minimumUsefulMinutes &&
          other.sortOrder == this.sortOrder &&
          other.syncState == this.syncState &&
          other.localVersion == this.localVersion &&
          other.remoteVersion == this.remoteVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String?> dayPlanId;
  final Value<String?> blockId;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String?> energyRequired;
  final Value<String?> requestedDay;
  final Value<String?> requestedStartTime;
  final Value<String?> requestedEndTime;
  final Value<bool> approximateTime;
  final Value<int> estimatedMinutes;
  final Value<int?> actualMinutes;
  final Value<String> priority;
  final Value<String?> category;
  final Value<String> status;
  final Value<String?> sourceId;
  final Value<DateTime?> deadline;
  final Value<bool> canSplit;
  final Value<int> minimumUsefulMinutes;
  final Value<int> sortOrder;
  final Value<SyncState> syncState;
  final Value<int> localVersion;
  final Value<int?> remoteVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.dayPlanId = const Value.absent(),
    this.blockId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.energyRequired = const Value.absent(),
    this.requestedDay = const Value.absent(),
    this.requestedStartTime = const Value.absent(),
    this.requestedEndTime = const Value.absent(),
    this.approximateTime = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.actualMinutes = const Value.absent(),
    this.priority = const Value.absent(),
    this.category = const Value.absent(),
    this.status = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.canSplit = const Value.absent(),
    this.minimumUsefulMinutes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.remoteVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    this.dayPlanId = const Value.absent(),
    this.blockId = const Value.absent(),
    required String title,
    this.notes = const Value.absent(),
    this.energyRequired = const Value.absent(),
    this.requestedDay = const Value.absent(),
    this.requestedStartTime = const Value.absent(),
    this.requestedEndTime = const Value.absent(),
    this.approximateTime = const Value.absent(),
    required int estimatedMinutes,
    this.actualMinutes = const Value.absent(),
    required String priority,
    this.category = const Value.absent(),
    required String status,
    this.sourceId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.canSplit = const Value.absent(),
    this.minimumUsefulMinutes = const Value.absent(),
    required int sortOrder,
    required SyncState syncState,
    this.localVersion = const Value.absent(),
    this.remoteVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       estimatedMinutes = Value(estimatedMinutes),
       priority = Value(priority),
       status = Value(status),
       sortOrder = Value(sortOrder),
       syncState = Value(syncState),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? dayPlanId,
    Expression<String>? blockId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? energyRequired,
    Expression<String>? requestedDay,
    Expression<String>? requestedStartTime,
    Expression<String>? requestedEndTime,
    Expression<bool>? approximateTime,
    Expression<int>? estimatedMinutes,
    Expression<int>? actualMinutes,
    Expression<String>? priority,
    Expression<String>? category,
    Expression<String>? status,
    Expression<String>? sourceId,
    Expression<DateTime>? deadline,
    Expression<bool>? canSplit,
    Expression<int>? minimumUsefulMinutes,
    Expression<int>? sortOrder,
    Expression<String>? syncState,
    Expression<int>? localVersion,
    Expression<int>? remoteVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayPlanId != null) 'day_plan_id': dayPlanId,
      if (blockId != null) 'block_id': blockId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (energyRequired != null) 'energy_required': energyRequired,
      if (requestedDay != null) 'requested_day': requestedDay,
      if (requestedStartTime != null)
        'requested_start_time': requestedStartTime,
      if (requestedEndTime != null) 'requested_end_time': requestedEndTime,
      if (approximateTime != null) 'approximate_time': approximateTime,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (actualMinutes != null) 'actual_minutes': actualMinutes,
      if (priority != null) 'priority': priority,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (sourceId != null) 'source_id': sourceId,
      if (deadline != null) 'deadline': deadline,
      if (canSplit != null) 'can_split': canSplit,
      if (minimumUsefulMinutes != null)
        'minimum_useful_minutes': minimumUsefulMinutes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (syncState != null) 'sync_state': syncState,
      if (localVersion != null) 'local_version': localVersion,
      if (remoteVersion != null) 'remote_version': remoteVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String?>? dayPlanId,
    Value<String?>? blockId,
    Value<String>? title,
    Value<String?>? notes,
    Value<String?>? energyRequired,
    Value<String?>? requestedDay,
    Value<String?>? requestedStartTime,
    Value<String?>? requestedEndTime,
    Value<bool>? approximateTime,
    Value<int>? estimatedMinutes,
    Value<int?>? actualMinutes,
    Value<String>? priority,
    Value<String?>? category,
    Value<String>? status,
    Value<String?>? sourceId,
    Value<DateTime?>? deadline,
    Value<bool>? canSplit,
    Value<int>? minimumUsefulMinutes,
    Value<int>? sortOrder,
    Value<SyncState>? syncState,
    Value<int>? localVersion,
    Value<int?>? remoteVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      dayPlanId: dayPlanId ?? this.dayPlanId,
      blockId: blockId ?? this.blockId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      energyRequired: energyRequired ?? this.energyRequired,
      requestedDay: requestedDay ?? this.requestedDay,
      requestedStartTime: requestedStartTime ?? this.requestedStartTime,
      requestedEndTime: requestedEndTime ?? this.requestedEndTime,
      approximateTime: approximateTime ?? this.approximateTime,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      sourceId: sourceId ?? this.sourceId,
      deadline: deadline ?? this.deadline,
      canSplit: canSplit ?? this.canSplit,
      minimumUsefulMinutes: minimumUsefulMinutes ?? this.minimumUsefulMinutes,
      sortOrder: sortOrder ?? this.sortOrder,
      syncState: syncState ?? this.syncState,
      localVersion: localVersion ?? this.localVersion,
      remoteVersion: remoteVersion ?? this.remoteVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayPlanId.present) {
      map['day_plan_id'] = Variable<String>(dayPlanId.value);
    }
    if (blockId.present) {
      map['block_id'] = Variable<String>(blockId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (energyRequired.present) {
      map['energy_required'] = Variable<String>(energyRequired.value);
    }
    if (requestedDay.present) {
      map['requested_day'] = Variable<String>(requestedDay.value);
    }
    if (requestedStartTime.present) {
      map['requested_start_time'] = Variable<String>(requestedStartTime.value);
    }
    if (requestedEndTime.present) {
      map['requested_end_time'] = Variable<String>(requestedEndTime.value);
    }
    if (approximateTime.present) {
      map['approximate_time'] = Variable<bool>(approximateTime.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (actualMinutes.present) {
      map['actual_minutes'] = Variable<int>(actualMinutes.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (canSplit.present) {
      map['can_split'] = Variable<bool>(canSplit.value);
    }
    if (minimumUsefulMinutes.present) {
      map['minimum_useful_minutes'] = Variable<int>(minimumUsefulMinutes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(
        $TasksTable.$convertersyncState.toSql(syncState.value),
      );
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (remoteVersion.present) {
      map['remote_version'] = Variable<int>(remoteVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('blockId: $blockId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('energyRequired: $energyRequired, ')
          ..write('requestedDay: $requestedDay, ')
          ..write('requestedStartTime: $requestedStartTime, ')
          ..write('requestedEndTime: $requestedEndTime, ')
          ..write('approximateTime: $approximateTime, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('priority: $priority, ')
          ..write('category: $category, ')
          ..write('status: $status, ')
          ..write('sourceId: $sourceId, ')
          ..write('deadline: $deadline, ')
          ..write('canSplit: $canSplit, ')
          ..write('minimumUsefulMinutes: $minimumUsefulMinutes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('syncState: $syncState, ')
          ..write('localVersion: $localVersion, ')
          ..write('remoteVersion: $remoteVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleRevisionsTable extends ScheduleRevisions
    with TableInfo<$ScheduleRevisionsTable, ScheduleRevision> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleRevisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayPlanIdMeta = const VerificationMeta(
    'dayPlanId',
  );
  @override
  late final GeneratedColumn<String> dayPlanId = GeneratedColumn<String>(
    'day_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES day_plans (id)',
    ),
  );
  static const VerificationMeta _revisionNumberMeta = const VerificationMeta(
    'revisionNumber',
  );
  @override
  late final GeneratedColumn<int> revisionNumber = GeneratedColumn<int>(
    'revision_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reversibleChangeSetJsonMeta =
      const VerificationMeta('reversibleChangeSetJson');
  @override
  late final GeneratedColumn<String> reversibleChangeSetJson =
      GeneratedColumn<String>(
        'reversible_change_set_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayPlanId,
    revisionNumber,
    reason,
    reversibleChangeSetJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_revisions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleRevision> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_plan_id')) {
      context.handle(
        _dayPlanIdMeta,
        dayPlanId.isAcceptableOrUnknown(data['day_plan_id']!, _dayPlanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayPlanIdMeta);
    }
    if (data.containsKey('revision_number')) {
      context.handle(
        _revisionNumberMeta,
        revisionNumber.isAcceptableOrUnknown(
          data['revision_number']!,
          _revisionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_revisionNumberMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('reversible_change_set_json')) {
      context.handle(
        _reversibleChangeSetJsonMeta,
        reversibleChangeSetJson.isAcceptableOrUnknown(
          data['reversible_change_set_json']!,
          _reversibleChangeSetJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reversibleChangeSetJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleRevision map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleRevision(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_plan_id'],
      )!,
      revisionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision_number'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      reversibleChangeSetJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reversible_change_set_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ScheduleRevisionsTable createAlias(String alias) {
    return $ScheduleRevisionsTable(attachedDatabase, alias);
  }
}

class ScheduleRevision extends DataClass
    implements Insertable<ScheduleRevision> {
  final String id;
  final String dayPlanId;
  final int revisionNumber;
  final String reason;
  final String reversibleChangeSetJson;
  final DateTime createdAt;
  const ScheduleRevision({
    required this.id,
    required this.dayPlanId,
    required this.revisionNumber,
    required this.reason,
    required this.reversibleChangeSetJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_plan_id'] = Variable<String>(dayPlanId);
    map['revision_number'] = Variable<int>(revisionNumber);
    map['reason'] = Variable<String>(reason);
    map['reversible_change_set_json'] = Variable<String>(
      reversibleChangeSetJson,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScheduleRevisionsCompanion toCompanion(bool nullToAbsent) {
    return ScheduleRevisionsCompanion(
      id: Value(id),
      dayPlanId: Value(dayPlanId),
      revisionNumber: Value(revisionNumber),
      reason: Value(reason),
      reversibleChangeSetJson: Value(reversibleChangeSetJson),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduleRevision.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleRevision(
      id: serializer.fromJson<String>(json['id']),
      dayPlanId: serializer.fromJson<String>(json['dayPlanId']),
      revisionNumber: serializer.fromJson<int>(json['revisionNumber']),
      reason: serializer.fromJson<String>(json['reason']),
      reversibleChangeSetJson: serializer.fromJson<String>(
        json['reversibleChangeSetJson'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayPlanId': serializer.toJson<String>(dayPlanId),
      'revisionNumber': serializer.toJson<int>(revisionNumber),
      'reason': serializer.toJson<String>(reason),
      'reversibleChangeSetJson': serializer.toJson<String>(
        reversibleChangeSetJson,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScheduleRevision copyWith({
    String? id,
    String? dayPlanId,
    int? revisionNumber,
    String? reason,
    String? reversibleChangeSetJson,
    DateTime? createdAt,
  }) => ScheduleRevision(
    id: id ?? this.id,
    dayPlanId: dayPlanId ?? this.dayPlanId,
    revisionNumber: revisionNumber ?? this.revisionNumber,
    reason: reason ?? this.reason,
    reversibleChangeSetJson:
        reversibleChangeSetJson ?? this.reversibleChangeSetJson,
    createdAt: createdAt ?? this.createdAt,
  );
  ScheduleRevision copyWithCompanion(ScheduleRevisionsCompanion data) {
    return ScheduleRevision(
      id: data.id.present ? data.id.value : this.id,
      dayPlanId: data.dayPlanId.present ? data.dayPlanId.value : this.dayPlanId,
      revisionNumber: data.revisionNumber.present
          ? data.revisionNumber.value
          : this.revisionNumber,
      reason: data.reason.present ? data.reason.value : this.reason,
      reversibleChangeSetJson: data.reversibleChangeSetJson.present
          ? data.reversibleChangeSetJson.value
          : this.reversibleChangeSetJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRevision(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('revisionNumber: $revisionNumber, ')
          ..write('reason: $reason, ')
          ..write('reversibleChangeSetJson: $reversibleChangeSetJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayPlanId,
    revisionNumber,
    reason,
    reversibleChangeSetJson,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRevision &&
          other.id == this.id &&
          other.dayPlanId == this.dayPlanId &&
          other.revisionNumber == this.revisionNumber &&
          other.reason == this.reason &&
          other.reversibleChangeSetJson == this.reversibleChangeSetJson &&
          other.createdAt == this.createdAt);
}

class ScheduleRevisionsCompanion extends UpdateCompanion<ScheduleRevision> {
  final Value<String> id;
  final Value<String> dayPlanId;
  final Value<int> revisionNumber;
  final Value<String> reason;
  final Value<String> reversibleChangeSetJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ScheduleRevisionsCompanion({
    this.id = const Value.absent(),
    this.dayPlanId = const Value.absent(),
    this.revisionNumber = const Value.absent(),
    this.reason = const Value.absent(),
    this.reversibleChangeSetJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleRevisionsCompanion.insert({
    required String id,
    required String dayPlanId,
    required int revisionNumber,
    required String reason,
    required String reversibleChangeSetJson,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayPlanId = Value(dayPlanId),
       revisionNumber = Value(revisionNumber),
       reason = Value(reason),
       reversibleChangeSetJson = Value(reversibleChangeSetJson),
       createdAt = Value(createdAt);
  static Insertable<ScheduleRevision> custom({
    Expression<String>? id,
    Expression<String>? dayPlanId,
    Expression<int>? revisionNumber,
    Expression<String>? reason,
    Expression<String>? reversibleChangeSetJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayPlanId != null) 'day_plan_id': dayPlanId,
      if (revisionNumber != null) 'revision_number': revisionNumber,
      if (reason != null) 'reason': reason,
      if (reversibleChangeSetJson != null)
        'reversible_change_set_json': reversibleChangeSetJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleRevisionsCompanion copyWith({
    Value<String>? id,
    Value<String>? dayPlanId,
    Value<int>? revisionNumber,
    Value<String>? reason,
    Value<String>? reversibleChangeSetJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ScheduleRevisionsCompanion(
      id: id ?? this.id,
      dayPlanId: dayPlanId ?? this.dayPlanId,
      revisionNumber: revisionNumber ?? this.revisionNumber,
      reason: reason ?? this.reason,
      reversibleChangeSetJson:
          reversibleChangeSetJson ?? this.reversibleChangeSetJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayPlanId.present) {
      map['day_plan_id'] = Variable<String>(dayPlanId.value);
    }
    if (revisionNumber.present) {
      map['revision_number'] = Variable<int>(revisionNumber.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (reversibleChangeSetJson.present) {
      map['reversible_change_set_json'] = Variable<String>(
        reversibleChangeSetJson.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRevisionsCompanion(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('revisionNumber: $revisionNumber, ')
          ..write('reason: $reason, ')
          ..write('reversibleChangeSetJson: $reversibleChangeSetJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RevisionUndosTable extends RevisionUndos
    with TableInfo<$RevisionUndosTable, RevisionUndo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RevisionUndosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionIdMeta = const VerificationMeta(
    'revisionId',
  );
  @override
  late final GeneratedColumn<String> revisionId = GeneratedColumn<String>(
    'revision_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES schedule_revisions (id)',
    ),
  );
  static const VerificationMeta _undoneAtMeta = const VerificationMeta(
    'undoneAt',
  );
  @override
  late final GeneratedColumn<DateTime> undoneAt = GeneratedColumn<DateTime>(
    'undone_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, revisionId, undoneAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'revision_undos';
  @override
  VerificationContext validateIntegrity(
    Insertable<RevisionUndo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('revision_id')) {
      context.handle(
        _revisionIdMeta,
        revisionId.isAcceptableOrUnknown(data['revision_id']!, _revisionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_revisionIdMeta);
    }
    if (data.containsKey('undone_at')) {
      context.handle(
        _undoneAtMeta,
        undoneAt.isAcceptableOrUnknown(data['undone_at']!, _undoneAtMeta),
      );
    } else if (isInserting) {
      context.missing(_undoneAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RevisionUndo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RevisionUndo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      revisionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_id'],
      )!,
      undoneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}undone_at'],
      )!,
    );
  }

  @override
  $RevisionUndosTable createAlias(String alias) {
    return $RevisionUndosTable(attachedDatabase, alias);
  }
}

class RevisionUndo extends DataClass implements Insertable<RevisionUndo> {
  final String id;
  final String revisionId;
  final DateTime undoneAt;
  const RevisionUndo({
    required this.id,
    required this.revisionId,
    required this.undoneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['revision_id'] = Variable<String>(revisionId);
    map['undone_at'] = Variable<DateTime>(undoneAt);
    return map;
  }

  RevisionUndosCompanion toCompanion(bool nullToAbsent) {
    return RevisionUndosCompanion(
      id: Value(id),
      revisionId: Value(revisionId),
      undoneAt: Value(undoneAt),
    );
  }

  factory RevisionUndo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RevisionUndo(
      id: serializer.fromJson<String>(json['id']),
      revisionId: serializer.fromJson<String>(json['revisionId']),
      undoneAt: serializer.fromJson<DateTime>(json['undoneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'revisionId': serializer.toJson<String>(revisionId),
      'undoneAt': serializer.toJson<DateTime>(undoneAt),
    };
  }

  RevisionUndo copyWith({String? id, String? revisionId, DateTime? undoneAt}) =>
      RevisionUndo(
        id: id ?? this.id,
        revisionId: revisionId ?? this.revisionId,
        undoneAt: undoneAt ?? this.undoneAt,
      );
  RevisionUndo copyWithCompanion(RevisionUndosCompanion data) {
    return RevisionUndo(
      id: data.id.present ? data.id.value : this.id,
      revisionId: data.revisionId.present
          ? data.revisionId.value
          : this.revisionId,
      undoneAt: data.undoneAt.present ? data.undoneAt.value : this.undoneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RevisionUndo(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('undoneAt: $undoneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, revisionId, undoneAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RevisionUndo &&
          other.id == this.id &&
          other.revisionId == this.revisionId &&
          other.undoneAt == this.undoneAt);
}

class RevisionUndosCompanion extends UpdateCompanion<RevisionUndo> {
  final Value<String> id;
  final Value<String> revisionId;
  final Value<DateTime> undoneAt;
  final Value<int> rowid;
  const RevisionUndosCompanion({
    this.id = const Value.absent(),
    this.revisionId = const Value.absent(),
    this.undoneAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RevisionUndosCompanion.insert({
    required String id,
    required String revisionId,
    required DateTime undoneAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       revisionId = Value(revisionId),
       undoneAt = Value(undoneAt);
  static Insertable<RevisionUndo> custom({
    Expression<String>? id,
    Expression<String>? revisionId,
    Expression<DateTime>? undoneAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (revisionId != null) 'revision_id': revisionId,
      if (undoneAt != null) 'undone_at': undoneAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RevisionUndosCompanion copyWith({
    Value<String>? id,
    Value<String>? revisionId,
    Value<DateTime>? undoneAt,
    Value<int>? rowid,
  }) {
    return RevisionUndosCompanion(
      id: id ?? this.id,
      revisionId: revisionId ?? this.revisionId,
      undoneAt: undoneAt ?? this.undoneAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (revisionId.present) {
      map['revision_id'] = Variable<String>(revisionId.value);
    }
    if (undoneAt.present) {
      map['undone_at'] = Variable<DateTime>(undoneAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RevisionUndosCompanion(')
          ..write('id: $id, ')
          ..write('revisionId: $revisionId, ')
          ..write('undoneAt: $undoneAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTable extends SyncOperations
    with TableInfo<$SyncOperationsTable, SyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operationType,
    payloadJson,
    attemptCount,
    nextAttemptAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextAttemptAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncOperationsTable createAlias(String alias) {
    return $SyncOperationsTable(attachedDatabase, alias);
  }
}

class SyncOperation extends DataClass implements Insertable<SyncOperation> {
  final String id;
  final String entityType;
  final String entityId;
  final String operationType;
  final String payloadJson;
  final int attemptCount;
  final DateTime nextAttemptAt;
  final DateTime createdAt;
  const SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payloadJson,
    required this.attemptCount,
    required this.nextAttemptAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation_type'] = Variable<String>(operationType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['attempt_count'] = Variable<int>(attemptCount);
    map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operationType: Value(operationType),
      payloadJson: Value(payloadJson),
      attemptCount: Value(attemptCount),
      nextAttemptAt: Value(nextAttemptAt),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperation(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextAttemptAt: serializer.fromJson<DateTime>(json['nextAttemptAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operationType': serializer.toJson<String>(operationType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextAttemptAt': serializer.toJson<DateTime>(nextAttemptAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOperation copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operationType,
    String? payloadJson,
    int? attemptCount,
    DateTime? nextAttemptAt,
    DateTime? createdAt,
  }) => SyncOperation(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operationType: operationType ?? this.operationType,
    payloadJson: payloadJson ?? this.payloadJson,
    attemptCount: attemptCount ?? this.attemptCount,
    nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncOperation copyWithCompanion(SyncOperationsCompanion data) {
    return SyncOperation(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperation(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operationType,
    payloadJson,
    attemptCount,
    nextAttemptAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperation &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operationType == this.operationType &&
          other.payloadJson == this.payloadJson &&
          other.attemptCount == this.attemptCount &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.createdAt == this.createdAt);
}

class SyncOperationsCompanion extends UpdateCompanion<SyncOperation> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operationType;
  final Value<String> payloadJson;
  final Value<int> attemptCount;
  final Value<DateTime> nextAttemptAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncOperationsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOperationsCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operationType,
    required String payloadJson,
    this.attemptCount = const Value.absent(),
    required DateTime nextAttemptAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operationType = Value(operationType),
       payloadJson = Value(payloadJson),
       nextAttemptAt = Value(nextAttemptAt),
       createdAt = Value(createdAt);
  static Insertable<SyncOperation> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operationType,
    Expression<String>? payloadJson,
    Expression<int>? attemptCount,
    Expression<DateTime>? nextAttemptAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operationType != null) 'operation_type': operationType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operationType,
    Value<String>? payloadJson,
    Value<int>? attemptCount,
    Value<DateTime>? nextAttemptAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncOperationsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payloadJson: payloadJson ?? this.payloadJson,
      attemptCount: attemptCount ?? this.attemptCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EstimationRecordsTable extends EstimationRecords
    with TableInfo<$EstimationRecordsTable, EstimationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EstimationRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualMinutesMeta = const VerificationMeta(
    'actualMinutes',
  );
  @override
  late final GeneratedColumn<int> actualMinutes = GeneratedColumn<int>(
    'actual_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementSourceMeta = const VerificationMeta(
    'measurementSource',
  );
  @override
  late final GeneratedColumn<String> measurementSource =
      GeneratedColumn<String>(
        'measurement_source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('legacy_unknown'),
      );
  static const VerificationMeta _timeOfDayMeta = const VerificationMeta(
    'timeOfDay',
  );
  @override
  late final GeneratedColumn<String> timeOfDay = GeneratedColumn<String>(
    'time_of_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interruptionCountMeta = const VerificationMeta(
    'interruptionCount',
  );
  @override
  late final GeneratedColumn<int> interruptionCount = GeneratedColumn<int>(
    'interruption_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wasSplitMeta = const VerificationMeta(
    'wasSplit',
  );
  @override
  late final GeneratedColumn<bool> wasSplit = GeneratedColumn<bool>(
    'was_split',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_split" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _excludedMeta = const VerificationMeta(
    'excluded',
  );
  @override
  late final GeneratedColumn<bool> excluded = GeneratedColumn<bool>(
    'excluded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("excluded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    category,
    estimatedMinutes,
    actualMinutes,
    measurementSource,
    timeOfDay,
    dayOfWeek,
    interruptionCount,
    wasSplit,
    difficulty,
    excluded,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'estimation_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<EstimationRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedMinutesMeta);
    }
    if (data.containsKey('actual_minutes')) {
      context.handle(
        _actualMinutesMeta,
        actualMinutes.isAcceptableOrUnknown(
          data['actual_minutes']!,
          _actualMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualMinutesMeta);
    }
    if (data.containsKey('measurement_source')) {
      context.handle(
        _measurementSourceMeta,
        measurementSource.isAcceptableOrUnknown(
          data['measurement_source']!,
          _measurementSourceMeta,
        ),
      );
    }
    if (data.containsKey('time_of_day')) {
      context.handle(
        _timeOfDayMeta,
        timeOfDay.isAcceptableOrUnknown(data['time_of_day']!, _timeOfDayMeta),
      );
    } else if (isInserting) {
      context.missing(_timeOfDayMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('interruption_count')) {
      context.handle(
        _interruptionCountMeta,
        interruptionCount.isAcceptableOrUnknown(
          data['interruption_count']!,
          _interruptionCountMeta,
        ),
      );
    }
    if (data.containsKey('was_split')) {
      context.handle(
        _wasSplitMeta,
        wasSplit.isAcceptableOrUnknown(data['was_split']!, _wasSplitMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('excluded')) {
      context.handle(
        _excludedMeta,
        excluded.isAcceptableOrUnknown(data['excluded']!, _excludedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EstimationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EstimationRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      actualMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_minutes'],
      )!,
      measurementSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_source'],
      )!,
      timeOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_of_day'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      interruptionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interruption_count'],
      )!,
      wasSplit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_split'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      ),
      excluded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}excluded'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EstimationRecordsTable createAlias(String alias) {
    return $EstimationRecordsTable(attachedDatabase, alias);
  }
}

class EstimationRecord extends DataClass
    implements Insertable<EstimationRecord> {
  final String id;
  final String? taskId;
  final String? category;
  final int estimatedMinutes;
  final int actualMinutes;
  final String measurementSource;
  final String timeOfDay;
  final int dayOfWeek;
  final int interruptionCount;
  final bool wasSplit;
  final int? difficulty;
  final bool excluded;
  final DateTime createdAt;
  final DateTime? deletedAt;
  const EstimationRecord({
    required this.id,
    this.taskId,
    this.category,
    required this.estimatedMinutes,
    required this.actualMinutes,
    required this.measurementSource,
    required this.timeOfDay,
    required this.dayOfWeek,
    required this.interruptionCount,
    required this.wasSplit,
    this.difficulty,
    required this.excluded,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['actual_minutes'] = Variable<int>(actualMinutes);
    map['measurement_source'] = Variable<String>(measurementSource);
    map['time_of_day'] = Variable<String>(timeOfDay);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['interruption_count'] = Variable<int>(interruptionCount);
    map['was_split'] = Variable<bool>(wasSplit);
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<int>(difficulty);
    }
    map['excluded'] = Variable<bool>(excluded);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EstimationRecordsCompanion toCompanion(bool nullToAbsent) {
    return EstimationRecordsCompanion(
      id: Value(id),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      estimatedMinutes: Value(estimatedMinutes),
      actualMinutes: Value(actualMinutes),
      measurementSource: Value(measurementSource),
      timeOfDay: Value(timeOfDay),
      dayOfWeek: Value(dayOfWeek),
      interruptionCount: Value(interruptionCount),
      wasSplit: Value(wasSplit),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      excluded: Value(excluded),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EstimationRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EstimationRecord(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      category: serializer.fromJson<String?>(json['category']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      actualMinutes: serializer.fromJson<int>(json['actualMinutes']),
      measurementSource: serializer.fromJson<String>(json['measurementSource']),
      timeOfDay: serializer.fromJson<String>(json['timeOfDay']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      interruptionCount: serializer.fromJson<int>(json['interruptionCount']),
      wasSplit: serializer.fromJson<bool>(json['wasSplit']),
      difficulty: serializer.fromJson<int?>(json['difficulty']),
      excluded: serializer.fromJson<bool>(json['excluded']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'category': serializer.toJson<String?>(category),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'actualMinutes': serializer.toJson<int>(actualMinutes),
      'measurementSource': serializer.toJson<String>(measurementSource),
      'timeOfDay': serializer.toJson<String>(timeOfDay),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'interruptionCount': serializer.toJson<int>(interruptionCount),
      'wasSplit': serializer.toJson<bool>(wasSplit),
      'difficulty': serializer.toJson<int?>(difficulty),
      'excluded': serializer.toJson<bool>(excluded),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EstimationRecord copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    Value<String?> category = const Value.absent(),
    int? estimatedMinutes,
    int? actualMinutes,
    String? measurementSource,
    String? timeOfDay,
    int? dayOfWeek,
    int? interruptionCount,
    bool? wasSplit,
    Value<int?> difficulty = const Value.absent(),
    bool? excluded,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => EstimationRecord(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    category: category.present ? category.value : this.category,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    actualMinutes: actualMinutes ?? this.actualMinutes,
    measurementSource: measurementSource ?? this.measurementSource,
    timeOfDay: timeOfDay ?? this.timeOfDay,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    interruptionCount: interruptionCount ?? this.interruptionCount,
    wasSplit: wasSplit ?? this.wasSplit,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    excluded: excluded ?? this.excluded,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  EstimationRecord copyWithCompanion(EstimationRecordsCompanion data) {
    return EstimationRecord(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      category: data.category.present ? data.category.value : this.category,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      actualMinutes: data.actualMinutes.present
          ? data.actualMinutes.value
          : this.actualMinutes,
      measurementSource: data.measurementSource.present
          ? data.measurementSource.value
          : this.measurementSource,
      timeOfDay: data.timeOfDay.present ? data.timeOfDay.value : this.timeOfDay,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      interruptionCount: data.interruptionCount.present
          ? data.interruptionCount.value
          : this.interruptionCount,
      wasSplit: data.wasSplit.present ? data.wasSplit.value : this.wasSplit,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      excluded: data.excluded.present ? data.excluded.value : this.excluded,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EstimationRecord(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('category: $category, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('measurementSource: $measurementSource, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('interruptionCount: $interruptionCount, ')
          ..write('wasSplit: $wasSplit, ')
          ..write('difficulty: $difficulty, ')
          ..write('excluded: $excluded, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    category,
    estimatedMinutes,
    actualMinutes,
    measurementSource,
    timeOfDay,
    dayOfWeek,
    interruptionCount,
    wasSplit,
    difficulty,
    excluded,
    createdAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EstimationRecord &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.category == this.category &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.actualMinutes == this.actualMinutes &&
          other.measurementSource == this.measurementSource &&
          other.timeOfDay == this.timeOfDay &&
          other.dayOfWeek == this.dayOfWeek &&
          other.interruptionCount == this.interruptionCount &&
          other.wasSplit == this.wasSplit &&
          other.difficulty == this.difficulty &&
          other.excluded == this.excluded &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class EstimationRecordsCompanion extends UpdateCompanion<EstimationRecord> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String?> category;
  final Value<int> estimatedMinutes;
  final Value<int> actualMinutes;
  final Value<String> measurementSource;
  final Value<String> timeOfDay;
  final Value<int> dayOfWeek;
  final Value<int> interruptionCount;
  final Value<bool> wasSplit;
  final Value<int?> difficulty;
  final Value<bool> excluded;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EstimationRecordsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.category = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.actualMinutes = const Value.absent(),
    this.measurementSource = const Value.absent(),
    this.timeOfDay = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.interruptionCount = const Value.absent(),
    this.wasSplit = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.excluded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EstimationRecordsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    this.category = const Value.absent(),
    required int estimatedMinutes,
    required int actualMinutes,
    this.measurementSource = const Value.absent(),
    required String timeOfDay,
    required int dayOfWeek,
    this.interruptionCount = const Value.absent(),
    this.wasSplit = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.excluded = const Value.absent(),
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       estimatedMinutes = Value(estimatedMinutes),
       actualMinutes = Value(actualMinutes),
       timeOfDay = Value(timeOfDay),
       dayOfWeek = Value(dayOfWeek),
       createdAt = Value(createdAt);
  static Insertable<EstimationRecord> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? category,
    Expression<int>? estimatedMinutes,
    Expression<int>? actualMinutes,
    Expression<String>? measurementSource,
    Expression<String>? timeOfDay,
    Expression<int>? dayOfWeek,
    Expression<int>? interruptionCount,
    Expression<bool>? wasSplit,
    Expression<int>? difficulty,
    Expression<bool>? excluded,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (category != null) 'category': category,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (actualMinutes != null) 'actual_minutes': actualMinutes,
      if (measurementSource != null) 'measurement_source': measurementSource,
      if (timeOfDay != null) 'time_of_day': timeOfDay,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (interruptionCount != null) 'interruption_count': interruptionCount,
      if (wasSplit != null) 'was_split': wasSplit,
      if (difficulty != null) 'difficulty': difficulty,
      if (excluded != null) 'excluded': excluded,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EstimationRecordsCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<String?>? category,
    Value<int>? estimatedMinutes,
    Value<int>? actualMinutes,
    Value<String>? measurementSource,
    Value<String>? timeOfDay,
    Value<int>? dayOfWeek,
    Value<int>? interruptionCount,
    Value<bool>? wasSplit,
    Value<int?>? difficulty,
    Value<bool>? excluded,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EstimationRecordsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      category: category ?? this.category,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      measurementSource: measurementSource ?? this.measurementSource,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      interruptionCount: interruptionCount ?? this.interruptionCount,
      wasSplit: wasSplit ?? this.wasSplit,
      difficulty: difficulty ?? this.difficulty,
      excluded: excluded ?? this.excluded,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (actualMinutes.present) {
      map['actual_minutes'] = Variable<int>(actualMinutes.value);
    }
    if (measurementSource.present) {
      map['measurement_source'] = Variable<String>(measurementSource.value);
    }
    if (timeOfDay.present) {
      map['time_of_day'] = Variable<String>(timeOfDay.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (interruptionCount.present) {
      map['interruption_count'] = Variable<int>(interruptionCount.value);
    }
    if (wasSplit.present) {
      map['was_split'] = Variable<bool>(wasSplit.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (excluded.present) {
      map['excluded'] = Variable<bool>(excluded.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EstimationRecordsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('category: $category, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('measurementSource: $measurementSource, ')
          ..write('timeOfDay: $timeOfDay, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('interruptionCount: $interruptionCount, ')
          ..write('wasSplit: $wasSplit, ')
          ..write('difficulty: $difficulty, ')
          ..write('excluded: $excluded, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnergyCheckInsTable extends EnergyCheckIns
    with TableInfo<$EnergyCheckInsTable, EnergyCheckIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnergyCheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedAtMeta = const VerificationMeta(
    'checkedAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedAt = GeneratedColumn<DateTime>(
    'checked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, level, checkedAt, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'energy_check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnergyCheckIn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('checked_at')) {
      context.handle(
        _checkedAtMeta,
        checkedAt.isAcceptableOrUnknown(data['checked_at']!, _checkedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_checkedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnergyCheckIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnergyCheckIn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      checkedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EnergyCheckInsTable createAlias(String alias) {
    return $EnergyCheckInsTable(attachedDatabase, alias);
  }
}

class EnergyCheckIn extends DataClass implements Insertable<EnergyCheckIn> {
  final String id;
  final String level;
  final DateTime checkedAt;
  final DateTime? deletedAt;
  const EnergyCheckIn({
    required this.id,
    required this.level,
    required this.checkedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['level'] = Variable<String>(level);
    map['checked_at'] = Variable<DateTime>(checkedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EnergyCheckInsCompanion toCompanion(bool nullToAbsent) {
    return EnergyCheckInsCompanion(
      id: Value(id),
      level: Value(level),
      checkedAt: Value(checkedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory EnergyCheckIn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnergyCheckIn(
      id: serializer.fromJson<String>(json['id']),
      level: serializer.fromJson<String>(json['level']),
      checkedAt: serializer.fromJson<DateTime>(json['checkedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'level': serializer.toJson<String>(level),
      'checkedAt': serializer.toJson<DateTime>(checkedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  EnergyCheckIn copyWith({
    String? id,
    String? level,
    DateTime? checkedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => EnergyCheckIn(
    id: id ?? this.id,
    level: level ?? this.level,
    checkedAt: checkedAt ?? this.checkedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  EnergyCheckIn copyWithCompanion(EnergyCheckInsCompanion data) {
    return EnergyCheckIn(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      checkedAt: data.checkedAt.present ? data.checkedAt.value : this.checkedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnergyCheckIn(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, checkedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnergyCheckIn &&
          other.id == this.id &&
          other.level == this.level &&
          other.checkedAt == this.checkedAt &&
          other.deletedAt == this.deletedAt);
}

class EnergyCheckInsCompanion extends UpdateCompanion<EnergyCheckIn> {
  final Value<String> id;
  final Value<String> level;
  final Value<DateTime> checkedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EnergyCheckInsCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.checkedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnergyCheckInsCompanion.insert({
    required String id,
    required String level,
    required DateTime checkedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       level = Value(level),
       checkedAt = Value(checkedAt);
  static Insertable<EnergyCheckIn> custom({
    Expression<String>? id,
    Expression<String>? level,
    Expression<DateTime>? checkedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (checkedAt != null) 'checked_at': checkedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnergyCheckInsCompanion copyWith({
    Value<String>? id,
    Value<String>? level,
    Value<DateTime>? checkedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EnergyCheckInsCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      checkedAt: checkedAt ?? this.checkedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (checkedAt.present) {
      map['checked_at'] = Variable<DateTime>(checkedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnergyCheckInsCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('checkedAt: $checkedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta(
    'plannedMinutes',
  );
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualMinutesMeta = const VerificationMeta(
    'actualMinutes',
  );
  @override
  late final GeneratedColumn<int> actualMinutes = GeneratedColumn<int>(
    'actual_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interruptionCountMeta = const VerificationMeta(
    'interruptionCount',
  );
  @override
  late final GeneratedColumn<int> interruptionCount = GeneratedColumn<int>(
    'interruption_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    title,
    startedAt,
    endedAt,
    plannedMinutes,
    actualMinutes,
    interruptionCount,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(
          data['planned_minutes']!,
          _plannedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedMinutesMeta);
    }
    if (data.containsKey('actual_minutes')) {
      context.handle(
        _actualMinutesMeta,
        actualMinutes.isAcceptableOrUnknown(
          data['actual_minutes']!,
          _actualMinutesMeta,
        ),
      );
    }
    if (data.containsKey('interruption_count')) {
      context.handle(
        _interruptionCountMeta,
        interruptionCount.isAcceptableOrUnknown(
          data['interruption_count']!,
          _interruptionCountMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      plannedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minutes'],
      )!,
      actualMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_minutes'],
      ),
      interruptionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interruption_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final String id;
  final String? taskId;
  final String title;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int plannedMinutes;
  final int? actualMinutes;
  final int interruptionCount;
  final String status;
  final DateTime createdAt;
  const FocusSession({
    required this.id,
    this.taskId,
    required this.title,
    required this.startedAt,
    this.endedAt,
    required this.plannedMinutes,
    this.actualMinutes,
    required this.interruptionCount,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['title'] = Variable<String>(title);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['planned_minutes'] = Variable<int>(plannedMinutes);
    if (!nullToAbsent || actualMinutes != null) {
      map['actual_minutes'] = Variable<int>(actualMinutes);
    }
    map['interruption_count'] = Variable<int>(interruptionCount);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      title: Value(title),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      plannedMinutes: Value(plannedMinutes),
      actualMinutes: actualMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(actualMinutes),
      interruptionCount: Value(interruptionCount),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      plannedMinutes: serializer.fromJson<int>(json['plannedMinutes']),
      actualMinutes: serializer.fromJson<int?>(json['actualMinutes']),
      interruptionCount: serializer.fromJson<int>(json['interruptionCount']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'title': serializer.toJson<String>(title),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'plannedMinutes': serializer.toJson<int>(plannedMinutes),
      'actualMinutes': serializer.toJson<int?>(actualMinutes),
      'interruptionCount': serializer.toJson<int>(interruptionCount),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FocusSession copyWith({
    String? id,
    Value<String?> taskId = const Value.absent(),
    String? title,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? plannedMinutes,
    Value<int?> actualMinutes = const Value.absent(),
    int? interruptionCount,
    String? status,
    DateTime? createdAt,
  }) => FocusSession(
    id: id ?? this.id,
    taskId: taskId.present ? taskId.value : this.taskId,
    title: title ?? this.title,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    plannedMinutes: plannedMinutes ?? this.plannedMinutes,
    actualMinutes: actualMinutes.present
        ? actualMinutes.value
        : this.actualMinutes,
    interruptionCount: interruptionCount ?? this.interruptionCount,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedMinutes: data.plannedMinutes.present
          ? data.plannedMinutes.value
          : this.plannedMinutes,
      actualMinutes: data.actualMinutes.present
          ? data.actualMinutes.value
          : this.actualMinutes,
      interruptionCount: data.interruptionCount.present
          ? data.interruptionCount.value
          : this.interruptionCount,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('interruptionCount: $interruptionCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    title,
    startedAt,
    endedAt,
    plannedMinutes,
    actualMinutes,
    interruptionCount,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedMinutes == this.plannedMinutes &&
          other.actualMinutes == this.actualMinutes &&
          other.interruptionCount == this.interruptionCount &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String> title;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> plannedMinutes;
  final Value<int?> actualMinutes;
  final Value<int> interruptionCount;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.actualMinutes = const Value.absent(),
    this.interruptionCount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    required String title,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required int plannedMinutes,
    this.actualMinutes = const Value.absent(),
    this.interruptionCount = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       startedAt = Value(startedAt),
       plannedMinutes = Value(plannedMinutes),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<FocusSession> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedMinutes,
    Expression<int>? actualMinutes,
    Expression<int>? interruptionCount,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (actualMinutes != null) 'actual_minutes': actualMinutes,
      if (interruptionCount != null) 'interruption_count': interruptionCount,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? taskId,
    Value<String>? title,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? plannedMinutes,
    Value<int?>? actualMinutes,
    Value<int>? interruptionCount,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      interruptionCount: interruptionCount ?? this.interruptionCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (actualMinutes.present) {
      map['actual_minutes'] = Variable<int>(actualMinutes.value);
    }
    if (interruptionCount.present) {
      map['interruption_count'] = Variable<int>(interruptionCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('actualMinutes: $actualMinutes, ')
          ..write('interruptionCount: $interruptionCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShareLinksTable extends ShareLinks
    with TableInfo<$ShareLinksTable, ShareLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShareLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenHashMeta = const VerificationMeta(
    'tokenHash',
  );
  @override
  late final GeneratedColumn<String> tokenHash = GeneratedColumn<String>(
    'token_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _shareTypeMeta = const VerificationMeta(
    'shareType',
  );
  @override
  late final GeneratedColumn<String> shareType = GeneratedColumn<String>(
    'share_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revokedAtMeta = const VerificationMeta(
    'revokedAt',
  );
  @override
  late final GeneratedColumn<DateTime> revokedAt = GeneratedColumn<DateTime>(
    'revoked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokenHash,
    shareType,
    payloadJson,
    expiresAt,
    revokedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'share_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShareLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('token_hash')) {
      context.handle(
        _tokenHashMeta,
        tokenHash.isAcceptableOrUnknown(data['token_hash']!, _tokenHashMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenHashMeta);
    }
    if (data.containsKey('share_type')) {
      context.handle(
        _shareTypeMeta,
        shareType.isAcceptableOrUnknown(data['share_type']!, _shareTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_shareTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('revoked_at')) {
      context.handle(
        _revokedAtMeta,
        revokedAt.isAcceptableOrUnknown(data['revoked_at']!, _revokedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShareLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShareLink(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokenHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_hash'],
      )!,
      shareType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      revokedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revoked_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ShareLinksTable createAlias(String alias) {
    return $ShareLinksTable(attachedDatabase, alias);
  }
}

class ShareLink extends DataClass implements Insertable<ShareLink> {
  final String id;
  final String tokenHash;
  final String shareType;
  final String payloadJson;
  final DateTime expiresAt;
  final DateTime? revokedAt;
  final DateTime createdAt;
  const ShareLink({
    required this.id,
    required this.tokenHash,
    required this.shareType,
    required this.payloadJson,
    required this.expiresAt,
    this.revokedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['token_hash'] = Variable<String>(tokenHash);
    map['share_type'] = Variable<String>(shareType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    if (!nullToAbsent || revokedAt != null) {
      map['revoked_at'] = Variable<DateTime>(revokedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ShareLinksCompanion toCompanion(bool nullToAbsent) {
    return ShareLinksCompanion(
      id: Value(id),
      tokenHash: Value(tokenHash),
      shareType: Value(shareType),
      payloadJson: Value(payloadJson),
      expiresAt: Value(expiresAt),
      revokedAt: revokedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ShareLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShareLink(
      id: serializer.fromJson<String>(json['id']),
      tokenHash: serializer.fromJson<String>(json['tokenHash']),
      shareType: serializer.fromJson<String>(json['shareType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      revokedAt: serializer.fromJson<DateTime?>(json['revokedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokenHash': serializer.toJson<String>(tokenHash),
      'shareType': serializer.toJson<String>(shareType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'revokedAt': serializer.toJson<DateTime?>(revokedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ShareLink copyWith({
    String? id,
    String? tokenHash,
    String? shareType,
    String? payloadJson,
    DateTime? expiresAt,
    Value<DateTime?> revokedAt = const Value.absent(),
    DateTime? createdAt,
  }) => ShareLink(
    id: id ?? this.id,
    tokenHash: tokenHash ?? this.tokenHash,
    shareType: shareType ?? this.shareType,
    payloadJson: payloadJson ?? this.payloadJson,
    expiresAt: expiresAt ?? this.expiresAt,
    revokedAt: revokedAt.present ? revokedAt.value : this.revokedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ShareLink copyWithCompanion(ShareLinksCompanion data) {
    return ShareLink(
      id: data.id.present ? data.id.value : this.id,
      tokenHash: data.tokenHash.present ? data.tokenHash.value : this.tokenHash,
      shareType: data.shareType.present ? data.shareType.value : this.shareType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      revokedAt: data.revokedAt.present ? data.revokedAt.value : this.revokedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShareLink(')
          ..write('id: $id, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('shareType: $shareType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokenHash,
    shareType,
    payloadJson,
    expiresAt,
    revokedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShareLink &&
          other.id == this.id &&
          other.tokenHash == this.tokenHash &&
          other.shareType == this.shareType &&
          other.payloadJson == this.payloadJson &&
          other.expiresAt == this.expiresAt &&
          other.revokedAt == this.revokedAt &&
          other.createdAt == this.createdAt);
}

class ShareLinksCompanion extends UpdateCompanion<ShareLink> {
  final Value<String> id;
  final Value<String> tokenHash;
  final Value<String> shareType;
  final Value<String> payloadJson;
  final Value<DateTime> expiresAt;
  final Value<DateTime?> revokedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ShareLinksCompanion({
    this.id = const Value.absent(),
    this.tokenHash = const Value.absent(),
    this.shareType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShareLinksCompanion.insert({
    required String id,
    required String tokenHash,
    required String shareType,
    required String payloadJson,
    required DateTime expiresAt,
    this.revokedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokenHash = Value(tokenHash),
       shareType = Value(shareType),
       payloadJson = Value(payloadJson),
       expiresAt = Value(expiresAt),
       createdAt = Value(createdAt);
  static Insertable<ShareLink> custom({
    Expression<String>? id,
    Expression<String>? tokenHash,
    Expression<String>? shareType,
    Expression<String>? payloadJson,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? revokedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokenHash != null) 'token_hash': tokenHash,
      if (shareType != null) 'share_type': shareType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (revokedAt != null) 'revoked_at': revokedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShareLinksCompanion copyWith({
    Value<String>? id,
    Value<String>? tokenHash,
    Value<String>? shareType,
    Value<String>? payloadJson,
    Value<DateTime>? expiresAt,
    Value<DateTime?>? revokedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ShareLinksCompanion(
      id: id ?? this.id,
      tokenHash: tokenHash ?? this.tokenHash,
      shareType: shareType ?? this.shareType,
      payloadJson: payloadJson ?? this.payloadJson,
      expiresAt: expiresAt ?? this.expiresAt,
      revokedAt: revokedAt ?? this.revokedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tokenHash.present) {
      map['token_hash'] = Variable<String>(tokenHash.value);
    }
    if (shareType.present) {
      map['share_type'] = Variable<String>(shareType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (revokedAt.present) {
      map['revoked_at'] = Variable<DateTime>(revokedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShareLinksCompanion(')
          ..write('id: $id, ')
          ..write('tokenHash: $tokenHash, ')
          ..write('shareType: $shareType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarConnectionsTable extends CalendarConnections
    with TableInfo<$CalendarConnectionsTable, CalendarConnection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _permissionStateMeta = const VerificationMeta(
    'permissionState',
  );
  @override
  late final GeneratedColumn<String> permissionState = GeneratedColumn<String>(
    'permission_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readOnlyMeta = const VerificationMeta(
    'readOnly',
  );
  @override
  late final GeneratedColumn<bool> readOnly = GeneratedColumn<bool>(
    'read_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read_only" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    platform,
    permissionState,
    readOnly,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_connections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarConnection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('permission_state')) {
      context.handle(
        _permissionStateMeta,
        permissionState.isAcceptableOrUnknown(
          data['permission_state']!,
          _permissionStateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_permissionStateMeta);
    }
    if (data.containsKey('read_only')) {
      context.handle(
        _readOnlyMeta,
        readOnly.isAcceptableOrUnknown(data['read_only']!, _readOnlyMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarConnection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarConnection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      permissionState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}permission_state'],
      )!,
      readOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read_only'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CalendarConnectionsTable createAlias(String alias) {
    return $CalendarConnectionsTable(attachedDatabase, alias);
  }
}

class CalendarConnection extends DataClass
    implements Insertable<CalendarConnection> {
  final String id;
  final String platform;
  final String permissionState;
  final bool readOnly;
  final DateTime updatedAt;
  const CalendarConnection({
    required this.id,
    required this.platform,
    required this.permissionState,
    required this.readOnly,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['platform'] = Variable<String>(platform);
    map['permission_state'] = Variable<String>(permissionState);
    map['read_only'] = Variable<bool>(readOnly);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CalendarConnectionsCompanion toCompanion(bool nullToAbsent) {
    return CalendarConnectionsCompanion(
      id: Value(id),
      platform: Value(platform),
      permissionState: Value(permissionState),
      readOnly: Value(readOnly),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalendarConnection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarConnection(
      id: serializer.fromJson<String>(json['id']),
      platform: serializer.fromJson<String>(json['platform']),
      permissionState: serializer.fromJson<String>(json['permissionState']),
      readOnly: serializer.fromJson<bool>(json['readOnly']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'platform': serializer.toJson<String>(platform),
      'permissionState': serializer.toJson<String>(permissionState),
      'readOnly': serializer.toJson<bool>(readOnly),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalendarConnection copyWith({
    String? id,
    String? platform,
    String? permissionState,
    bool? readOnly,
    DateTime? updatedAt,
  }) => CalendarConnection(
    id: id ?? this.id,
    platform: platform ?? this.platform,
    permissionState: permissionState ?? this.permissionState,
    readOnly: readOnly ?? this.readOnly,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalendarConnection copyWithCompanion(CalendarConnectionsCompanion data) {
    return CalendarConnection(
      id: data.id.present ? data.id.value : this.id,
      platform: data.platform.present ? data.platform.value : this.platform,
      permissionState: data.permissionState.present
          ? data.permissionState.value
          : this.permissionState,
      readOnly: data.readOnly.present ? data.readOnly.value : this.readOnly,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarConnection(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('permissionState: $permissionState, ')
          ..write('readOnly: $readOnly, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, platform, permissionState, readOnly, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarConnection &&
          other.id == this.id &&
          other.platform == this.platform &&
          other.permissionState == this.permissionState &&
          other.readOnly == this.readOnly &&
          other.updatedAt == this.updatedAt);
}

class CalendarConnectionsCompanion extends UpdateCompanion<CalendarConnection> {
  final Value<String> id;
  final Value<String> platform;
  final Value<String> permissionState;
  final Value<bool> readOnly;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CalendarConnectionsCompanion({
    this.id = const Value.absent(),
    this.platform = const Value.absent(),
    this.permissionState = const Value.absent(),
    this.readOnly = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarConnectionsCompanion.insert({
    required String id,
    required String platform,
    required String permissionState,
    this.readOnly = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       platform = Value(platform),
       permissionState = Value(permissionState),
       updatedAt = Value(updatedAt);
  static Insertable<CalendarConnection> custom({
    Expression<String>? id,
    Expression<String>? platform,
    Expression<String>? permissionState,
    Expression<bool>? readOnly,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (platform != null) 'platform': platform,
      if (permissionState != null) 'permission_state': permissionState,
      if (readOnly != null) 'read_only': readOnly,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarConnectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? platform,
    Value<String>? permissionState,
    Value<bool>? readOnly,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CalendarConnectionsCompanion(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      permissionState: permissionState ?? this.permissionState,
      readOnly: readOnly ?? this.readOnly,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (permissionState.present) {
      map['permission_state'] = Variable<String>(permissionState.value);
    }
    if (readOnly.present) {
      map['read_only'] = Variable<bool>(readOnly.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('platform: $platform, ')
          ..write('permissionState: $permissionState, ')
          ..write('readOnly: $readOnly, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DayweftDatabase extends GeneratedDatabase {
  _$DayweftDatabase(QueryExecutor e) : super(e);
  $DayweftDatabaseManager get managers => $DayweftDatabaseManager(this);
  late final $DayPlansTable dayPlans = $DayPlansTable(this);
  late final $UserPreferencesTable userPreferences = $UserPreferencesTable(
    this,
  );
  late final $TimeBlocksTable timeBlocks = $TimeBlocksTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ScheduleRevisionsTable scheduleRevisions =
      $ScheduleRevisionsTable(this);
  late final $RevisionUndosTable revisionUndos = $RevisionUndosTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  late final $EstimationRecordsTable estimationRecords =
      $EstimationRecordsTable(this);
  late final $EnergyCheckInsTable energyCheckIns = $EnergyCheckInsTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $ShareLinksTable shareLinks = $ShareLinksTable(this);
  late final $CalendarConnectionsTable calendarConnections =
      $CalendarConnectionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dayPlans,
    userPreferences,
    timeBlocks,
    tasks,
    scheduleRevisions,
    revisionUndos,
    syncOperations,
    estimationRecords,
    energyCheckIns,
    focusSessions,
    shareLinks,
    calendarConnections,
  ];
}

typedef $$DayPlansTableCreateCompanionBuilder =
    DayPlansCompanion Function({
      required String id,
      required DateTime day,
      required String timeZone,
      Value<int> revision,
      required SyncState syncState,
      Value<int> localVersion,
      Value<int?> remoteVersion,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$DayPlansTableUpdateCompanionBuilder =
    DayPlansCompanion Function({
      Value<String> id,
      Value<DateTime> day,
      Value<String> timeZone,
      Value<int> revision,
      Value<SyncState> syncState,
      Value<int> localVersion,
      Value<int?> remoteVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$DayPlansTableReferences
    extends BaseReferences<_$DayweftDatabase, $DayPlansTable, DayPlan> {
  $$DayPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimeBlocksTable, List<TimeBlock>>
  _timeBlocksRefsTable(_$DayweftDatabase db) => MultiTypedResultKey.fromTable(
    db.timeBlocks,
    aliasName: 'day_plans__id__time_blocks__day_plan_id',
  );

  $$TimeBlocksTableProcessedTableManager get timeBlocksRefs {
    final manager = $$TimeBlocksTableTableManager(
      $_db,
      $_db.timeBlocks,
    ).filter((f) => f.dayPlanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$DayweftDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'day_plans__id__tasks__day_plan_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.dayPlanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScheduleRevisionsTable, List<ScheduleRevision>>
  _scheduleRevisionsRefsTable(_$DayweftDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.scheduleRevisions,
        aliasName: 'day_plans__id__schedule_revisions__day_plan_id',
      );

  $$ScheduleRevisionsTableProcessedTableManager get scheduleRevisionsRefs {
    final manager = $$ScheduleRevisionsTableTableManager(
      $_db,
      $_db.scheduleRevisions,
    ).filter((f) => f.dayPlanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _scheduleRevisionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DayPlansTableFilterComposer
    extends Composer<_$DayweftDatabase, $DayPlansTable> {
  $$DayPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timeBlocksRefs(
    Expression<bool> Function($$TimeBlocksTableFilterComposer f) f,
  ) {
    final $$TimeBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeBlocks,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeBlocksTableFilterComposer(
            $db: $db,
            $table: $db.timeBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scheduleRevisionsRefs(
    Expression<bool> Function($$ScheduleRevisionsTableFilterComposer f) f,
  ) {
    final $$ScheduleRevisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleRevisions,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRevisionsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleRevisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DayPlansTableOrderingComposer
    extends Composer<_$DayweftDatabase, $DayPlansTable> {
  $$DayPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayPlansTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $DayPlansTable> {
  $$DayPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> timeBlocksRefs<T extends Object>(
    Expression<T> Function($$TimeBlocksTableAnnotationComposer a) f,
  ) {
    final $$TimeBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeBlocks,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.timeBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scheduleRevisionsRefs<T extends Object>(
    Expression<T> Function($$ScheduleRevisionsTableAnnotationComposer a) f,
  ) {
    final $$ScheduleRevisionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.scheduleRevisions,
          getReferencedColumn: (t) => t.dayPlanId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScheduleRevisionsTableAnnotationComposer(
                $db: $db,
                $table: $db.scheduleRevisions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DayPlansTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $DayPlansTable,
          DayPlan,
          $$DayPlansTableFilterComposer,
          $$DayPlansTableOrderingComposer,
          $$DayPlansTableAnnotationComposer,
          $$DayPlansTableCreateCompanionBuilder,
          $$DayPlansTableUpdateCompanionBuilder,
          (DayPlan, $$DayPlansTableReferences),
          DayPlan,
          PrefetchHooks Function({
            bool timeBlocksRefs,
            bool tasksRefs,
            bool scheduleRevisionsRefs,
          })
        > {
  $$DayPlansTableTableManager(_$DayweftDatabase db, $DayPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int?> remoteVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayPlansCompanion(
                id: id,
                day: day,
                timeZone: timeZone,
                revision: revision,
                syncState: syncState,
                localVersion: localVersion,
                remoteVersion: remoteVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime day,
                required String timeZone,
                Value<int> revision = const Value.absent(),
                required SyncState syncState,
                Value<int> localVersion = const Value.absent(),
                Value<int?> remoteVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayPlansCompanion.insert(
                id: id,
                day: day,
                timeZone: timeZone,
                revision: revision,
                syncState: syncState,
                localVersion: localVersion,
                remoteVersion: remoteVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DayPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                timeBlocksRefs = false,
                tasksRefs = false,
                scheduleRevisionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (timeBlocksRefs) db.timeBlocks,
                    if (tasksRefs) db.tasks,
                    if (scheduleRevisionsRefs) db.scheduleRevisions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (timeBlocksRefs)
                        await $_getPrefetchedData<
                          DayPlan,
                          $DayPlansTable,
                          TimeBlock
                        >(
                          currentTable: table,
                          referencedTable: $$DayPlansTableReferences
                              ._timeBlocksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DayPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).timeBlocksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dayPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          DayPlan,
                          $DayPlansTable,
                          Task
                        >(
                          currentTable: table,
                          referencedTable: $$DayPlansTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DayPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dayPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (scheduleRevisionsRefs)
                        await $_getPrefetchedData<
                          DayPlan,
                          $DayPlansTable,
                          ScheduleRevision
                        >(
                          currentTable: table,
                          referencedTable: $$DayPlansTableReferences
                              ._scheduleRevisionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DayPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleRevisionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.dayPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DayPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $DayPlansTable,
      DayPlan,
      $$DayPlansTableFilterComposer,
      $$DayPlansTableOrderingComposer,
      $$DayPlansTableAnnotationComposer,
      $$DayPlansTableCreateCompanionBuilder,
      $$DayPlansTableUpdateCompanionBuilder,
      (DayPlan, $$DayPlansTableReferences),
      DayPlan,
      PrefetchHooks Function({
        bool timeBlocksRefs,
        bool tasksRefs,
        bool scheduleRevisionsRefs,
      })
    >;
typedef $$UserPreferencesTableCreateCompanionBuilder =
    UserPreferencesCompanion Function({
      required String id,
      Value<bool> onboardingCompleted,
      Value<bool> sampleDataEnabled,
      Value<String> wakeTime,
      Value<String> windDownTime,
      Value<String> workStartTime,
      Value<String> workEndTime,
      Value<String> planningStyle,
      Value<String> workingPattern,
      Value<String> calendarPreference,
      Value<bool> energyEnabled,
      Value<int> preferredBreakMinutes,
      Value<int> contingencyMinutes,
      Value<int> transitionMinutes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserPreferencesTableUpdateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<String> id,
      Value<bool> onboardingCompleted,
      Value<bool> sampleDataEnabled,
      Value<String> wakeTime,
      Value<String> windDownTime,
      Value<String> workStartTime,
      Value<String> workEndTime,
      Value<String> planningStyle,
      Value<String> workingPattern,
      Value<String> calendarPreference,
      Value<bool> energyEnabled,
      Value<int> preferredBreakMinutes,
      Value<int> contingencyMinutes,
      Value<int> transitionMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserPreferencesTableFilterComposer
    extends Composer<_$DayweftDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sampleDataEnabled => $composableBuilder(
    column: $table.sampleDataEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windDownTime => $composableBuilder(
    column: $table.windDownTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workStartTime => $composableBuilder(
    column: $table.workStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workEndTime => $composableBuilder(
    column: $table.workEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planningStyle => $composableBuilder(
    column: $table.planningStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workingPattern => $composableBuilder(
    column: $table.workingPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarPreference => $composableBuilder(
    column: $table.calendarPreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get energyEnabled => $composableBuilder(
    column: $table.energyEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preferredBreakMinutes => $composableBuilder(
    column: $table.preferredBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contingencyMinutes => $composableBuilder(
    column: $table.contingencyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transitionMinutes => $composableBuilder(
    column: $table.transitionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$DayweftDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sampleDataEnabled => $composableBuilder(
    column: $table.sampleDataEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windDownTime => $composableBuilder(
    column: $table.windDownTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workStartTime => $composableBuilder(
    column: $table.workStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workEndTime => $composableBuilder(
    column: $table.workEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planningStyle => $composableBuilder(
    column: $table.planningStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workingPattern => $composableBuilder(
    column: $table.workingPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarPreference => $composableBuilder(
    column: $table.calendarPreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get energyEnabled => $composableBuilder(
    column: $table.energyEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preferredBreakMinutes => $composableBuilder(
    column: $table.preferredBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contingencyMinutes => $composableBuilder(
    column: $table.contingencyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transitionMinutes => $composableBuilder(
    column: $table.transitionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sampleDataEnabled => $composableBuilder(
    column: $table.sampleDataEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<String> get windDownTime => $composableBuilder(
    column: $table.windDownTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workStartTime => $composableBuilder(
    column: $table.workStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workEndTime => $composableBuilder(
    column: $table.workEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planningStyle => $composableBuilder(
    column: $table.planningStyle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workingPattern => $composableBuilder(
    column: $table.workingPattern,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calendarPreference => $composableBuilder(
    column: $table.calendarPreference,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get energyEnabled => $composableBuilder(
    column: $table.energyEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preferredBreakMinutes => $composableBuilder(
    column: $table.preferredBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contingencyMinutes => $composableBuilder(
    column: $table.contingencyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get transitionMinutes => $composableBuilder(
    column: $table.transitionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPreferencesTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $UserPreferencesTable,
          UserPreference,
          $$UserPreferencesTableFilterComposer,
          $$UserPreferencesTableOrderingComposer,
          $$UserPreferencesTableAnnotationComposer,
          $$UserPreferencesTableCreateCompanionBuilder,
          $$UserPreferencesTableUpdateCompanionBuilder,
          (
            UserPreference,
            BaseReferences<
              _$DayweftDatabase,
              $UserPreferencesTable,
              UserPreference
            >,
          ),
          UserPreference,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableManager(
    _$DayweftDatabase db,
    $UserPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> sampleDataEnabled = const Value.absent(),
                Value<String> wakeTime = const Value.absent(),
                Value<String> windDownTime = const Value.absent(),
                Value<String> workStartTime = const Value.absent(),
                Value<String> workEndTime = const Value.absent(),
                Value<String> planningStyle = const Value.absent(),
                Value<String> workingPattern = const Value.absent(),
                Value<String> calendarPreference = const Value.absent(),
                Value<bool> energyEnabled = const Value.absent(),
                Value<int> preferredBreakMinutes = const Value.absent(),
                Value<int> contingencyMinutes = const Value.absent(),
                Value<int> transitionMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion(
                id: id,
                onboardingCompleted: onboardingCompleted,
                sampleDataEnabled: sampleDataEnabled,
                wakeTime: wakeTime,
                windDownTime: windDownTime,
                workStartTime: workStartTime,
                workEndTime: workEndTime,
                planningStyle: planningStyle,
                workingPattern: workingPattern,
                calendarPreference: calendarPreference,
                energyEnabled: energyEnabled,
                preferredBreakMinutes: preferredBreakMinutes,
                contingencyMinutes: contingencyMinutes,
                transitionMinutes: transitionMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> sampleDataEnabled = const Value.absent(),
                Value<String> wakeTime = const Value.absent(),
                Value<String> windDownTime = const Value.absent(),
                Value<String> workStartTime = const Value.absent(),
                Value<String> workEndTime = const Value.absent(),
                Value<String> planningStyle = const Value.absent(),
                Value<String> workingPattern = const Value.absent(),
                Value<String> calendarPreference = const Value.absent(),
                Value<bool> energyEnabled = const Value.absent(),
                Value<int> preferredBreakMinutes = const Value.absent(),
                Value<int> contingencyMinutes = const Value.absent(),
                Value<int> transitionMinutes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion.insert(
                id: id,
                onboardingCompleted: onboardingCompleted,
                sampleDataEnabled: sampleDataEnabled,
                wakeTime: wakeTime,
                windDownTime: windDownTime,
                workStartTime: workStartTime,
                workEndTime: workEndTime,
                planningStyle: planningStyle,
                workingPattern: workingPattern,
                calendarPreference: calendarPreference,
                energyEnabled: energyEnabled,
                preferredBreakMinutes: preferredBreakMinutes,
                contingencyMinutes: contingencyMinutes,
                transitionMinutes: transitionMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $UserPreferencesTable,
      UserPreference,
      $$UserPreferencesTableFilterComposer,
      $$UserPreferencesTableOrderingComposer,
      $$UserPreferencesTableAnnotationComposer,
      $$UserPreferencesTableCreateCompanionBuilder,
      $$UserPreferencesTableUpdateCompanionBuilder,
      (
        UserPreference,
        BaseReferences<
          _$DayweftDatabase,
          $UserPreferencesTable,
          UserPreference
        >,
      ),
      UserPreference,
      PrefetchHooks Function()
    >;
typedef $$TimeBlocksTableCreateCompanionBuilder =
    TimeBlocksCompanion Function({
      required String id,
      required String dayPlanId,
      required String title,
      required DateTime startsAt,
      required DateTime endsAt,
      required String blockType,
      Value<String?> category,
      Value<String?> sourceId,
      Value<int> travelBufferMinutes,
      Value<int> preparationBufferMinutes,
      Value<int> transitionBufferMinutes,
      Value<int> recoveryBufferMinutes,
      required int sortOrder,
      required SyncState syncState,
      Value<int> localVersion,
      Value<int?> remoteVersion,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TimeBlocksTableUpdateCompanionBuilder =
    TimeBlocksCompanion Function({
      Value<String> id,
      Value<String> dayPlanId,
      Value<String> title,
      Value<DateTime> startsAt,
      Value<DateTime> endsAt,
      Value<String> blockType,
      Value<String?> category,
      Value<String?> sourceId,
      Value<int> travelBufferMinutes,
      Value<int> preparationBufferMinutes,
      Value<int> transitionBufferMinutes,
      Value<int> recoveryBufferMinutes,
      Value<int> sortOrder,
      Value<SyncState> syncState,
      Value<int> localVersion,
      Value<int?> remoteVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$TimeBlocksTableReferences
    extends BaseReferences<_$DayweftDatabase, $TimeBlocksTable, TimeBlock> {
  $$TimeBlocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DayPlansTable _dayPlanIdTable(_$DayweftDatabase db) =>
      db.dayPlans.createAlias('time_blocks__day_plan_id__day_plans__id');

  $$DayPlansTableProcessedTableManager get dayPlanId {
    final $_column = $_itemColumn<String>('day_plan_id')!;

    final manager = $$DayPlansTableTableManager(
      $_db,
      $_db.dayPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
    _$DayweftDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: 'time_blocks__id__tasks__block_id',
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.blockId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TimeBlocksTableFilterComposer
    extends Composer<_$DayweftDatabase, $TimeBlocksTable> {
  $$TimeBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blockType => $composableBuilder(
    column: $table.blockType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get travelBufferMinutes => $composableBuilder(
    column: $table.travelBufferMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preparationBufferMinutes => $composableBuilder(
    column: $table.preparationBufferMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get transitionBufferMinutes => $composableBuilder(
    column: $table.transitionBufferMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recoveryBufferMinutes => $composableBuilder(
    column: $table.recoveryBufferMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DayPlansTableFilterComposer get dayPlanId {
    final $$DayPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableFilterComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimeBlocksTableOrderingComposer
    extends Composer<_$DayweftDatabase, $TimeBlocksTable> {
  $$TimeBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endsAt => $composableBuilder(
    column: $table.endsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blockType => $composableBuilder(
    column: $table.blockType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get travelBufferMinutes => $composableBuilder(
    column: $table.travelBufferMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preparationBufferMinutes => $composableBuilder(
    column: $table.preparationBufferMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get transitionBufferMinutes => $composableBuilder(
    column: $table.transitionBufferMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recoveryBufferMinutes => $composableBuilder(
    column: $table.recoveryBufferMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DayPlansTableOrderingComposer get dayPlanId {
    final $$DayPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableOrderingComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeBlocksTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $TimeBlocksTable> {
  $$TimeBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endsAt =>
      $composableBuilder(column: $table.endsAt, builder: (column) => column);

  GeneratedColumn<String> get blockType =>
      $composableBuilder(column: $table.blockType, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<int> get travelBufferMinutes => $composableBuilder(
    column: $table.travelBufferMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preparationBufferMinutes => $composableBuilder(
    column: $table.preparationBufferMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get transitionBufferMinutes => $composableBuilder(
    column: $table.transitionBufferMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recoveryBufferMinutes => $composableBuilder(
    column: $table.recoveryBufferMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$DayPlansTableAnnotationComposer get dayPlanId {
    final $$DayPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.blockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimeBlocksTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $TimeBlocksTable,
          TimeBlock,
          $$TimeBlocksTableFilterComposer,
          $$TimeBlocksTableOrderingComposer,
          $$TimeBlocksTableAnnotationComposer,
          $$TimeBlocksTableCreateCompanionBuilder,
          $$TimeBlocksTableUpdateCompanionBuilder,
          (TimeBlock, $$TimeBlocksTableReferences),
          TimeBlock,
          PrefetchHooks Function({bool dayPlanId, bool tasksRefs})
        > {
  $$TimeBlocksTableTableManager(_$DayweftDatabase db, $TimeBlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayPlanId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startsAt = const Value.absent(),
                Value<DateTime> endsAt = const Value.absent(),
                Value<String> blockType = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<int> travelBufferMinutes = const Value.absent(),
                Value<int> preparationBufferMinutes = const Value.absent(),
                Value<int> transitionBufferMinutes = const Value.absent(),
                Value<int> recoveryBufferMinutes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int?> remoteVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeBlocksCompanion(
                id: id,
                dayPlanId: dayPlanId,
                title: title,
                startsAt: startsAt,
                endsAt: endsAt,
                blockType: blockType,
                category: category,
                sourceId: sourceId,
                travelBufferMinutes: travelBufferMinutes,
                preparationBufferMinutes: preparationBufferMinutes,
                transitionBufferMinutes: transitionBufferMinutes,
                recoveryBufferMinutes: recoveryBufferMinutes,
                sortOrder: sortOrder,
                syncState: syncState,
                localVersion: localVersion,
                remoteVersion: remoteVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayPlanId,
                required String title,
                required DateTime startsAt,
                required DateTime endsAt,
                required String blockType,
                Value<String?> category = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<int> travelBufferMinutes = const Value.absent(),
                Value<int> preparationBufferMinutes = const Value.absent(),
                Value<int> transitionBufferMinutes = const Value.absent(),
                Value<int> recoveryBufferMinutes = const Value.absent(),
                required int sortOrder,
                required SyncState syncState,
                Value<int> localVersion = const Value.absent(),
                Value<int?> remoteVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeBlocksCompanion.insert(
                id: id,
                dayPlanId: dayPlanId,
                title: title,
                startsAt: startsAt,
                endsAt: endsAt,
                blockType: blockType,
                category: category,
                sourceId: sourceId,
                travelBufferMinutes: travelBufferMinutes,
                preparationBufferMinutes: preparationBufferMinutes,
                transitionBufferMinutes: transitionBufferMinutes,
                recoveryBufferMinutes: recoveryBufferMinutes,
                sortOrder: sortOrder,
                syncState: syncState,
                localVersion: localVersion,
                remoteVersion: remoteVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dayPlanId = false, tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksRefs) db.tasks],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dayPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dayPlanId,
                                referencedTable: $$TimeBlocksTableReferences
                                    ._dayPlanIdTable(db),
                                referencedColumn: $$TimeBlocksTableReferences
                                    ._dayPlanIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedData<
                      TimeBlock,
                      $TimeBlocksTable,
                      Task
                    >(
                      currentTable: table,
                      referencedTable: $$TimeBlocksTableReferences
                          ._tasksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TimeBlocksTableReferences(db, table, p0).tasksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.blockId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TimeBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $TimeBlocksTable,
      TimeBlock,
      $$TimeBlocksTableFilterComposer,
      $$TimeBlocksTableOrderingComposer,
      $$TimeBlocksTableAnnotationComposer,
      $$TimeBlocksTableCreateCompanionBuilder,
      $$TimeBlocksTableUpdateCompanionBuilder,
      (TimeBlock, $$TimeBlocksTableReferences),
      TimeBlock,
      PrefetchHooks Function({bool dayPlanId, bool tasksRefs})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      Value<String?> dayPlanId,
      Value<String?> blockId,
      required String title,
      Value<String?> notes,
      Value<String?> energyRequired,
      Value<String?> requestedDay,
      Value<String?> requestedStartTime,
      Value<String?> requestedEndTime,
      Value<bool> approximateTime,
      required int estimatedMinutes,
      Value<int?> actualMinutes,
      required String priority,
      Value<String?> category,
      required String status,
      Value<String?> sourceId,
      Value<DateTime?> deadline,
      Value<bool> canSplit,
      Value<int> minimumUsefulMinutes,
      required int sortOrder,
      required SyncState syncState,
      Value<int> localVersion,
      Value<int?> remoteVersion,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String?> dayPlanId,
      Value<String?> blockId,
      Value<String> title,
      Value<String?> notes,
      Value<String?> energyRequired,
      Value<String?> requestedDay,
      Value<String?> requestedStartTime,
      Value<String?> requestedEndTime,
      Value<bool> approximateTime,
      Value<int> estimatedMinutes,
      Value<int?> actualMinutes,
      Value<String> priority,
      Value<String?> category,
      Value<String> status,
      Value<String?> sourceId,
      Value<DateTime?> deadline,
      Value<bool> canSplit,
      Value<int> minimumUsefulMinutes,
      Value<int> sortOrder,
      Value<SyncState> syncState,
      Value<int> localVersion,
      Value<int?> remoteVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$DayweftDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DayPlansTable _dayPlanIdTable(_$DayweftDatabase db) =>
      db.dayPlans.createAlias('tasks__day_plan_id__day_plans__id');

  $$DayPlansTableProcessedTableManager? get dayPlanId {
    final $_column = $_itemColumn<String>('day_plan_id');
    if ($_column == null) return null;
    final manager = $$DayPlansTableTableManager(
      $_db,
      $_db.dayPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TimeBlocksTable _blockIdTable(_$DayweftDatabase db) =>
      db.timeBlocks.createAlias('tasks__block_id__time_blocks__id');

  $$TimeBlocksTableProcessedTableManager? get blockId {
    final $_column = $_itemColumn<String>('block_id');
    if ($_column == null) return null;
    final manager = $$TimeBlocksTableTableManager(
      $_db,
      $_db.timeBlocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_blockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EstimationRecordsTable, List<EstimationRecord>>
  _estimationRecordsRefsTable(_$DayweftDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.estimationRecords,
        aliasName: 'tasks__id__estimation_records__task_id',
      );

  $$EstimationRecordsTableProcessedTableManager get estimationRecordsRefs {
    final manager = $$EstimationRecordsTableTableManager(
      $_db,
      $_db.estimationRecords,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _estimationRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$DayweftDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.focusSessions,
        aliasName: 'tasks__id__focus_sessions__task_id',
      );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer
    extends Composer<_$DayweftDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get energyRequired => $composableBuilder(
    column: $table.energyRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestedDay => $composableBuilder(
    column: $table.requestedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestedStartTime => $composableBuilder(
    column: $table.requestedStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestedEndTime => $composableBuilder(
    column: $table.requestedEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get approximateTime => $composableBuilder(
    column: $table.approximateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get canSplit => $composableBuilder(
    column: $table.canSplit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumUsefulMinutes => $composableBuilder(
    column: $table.minimumUsefulMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncState, SyncState, String> get syncState =>
      $composableBuilder(
        column: $table.syncState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DayPlansTableFilterComposer get dayPlanId {
    final $$DayPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableFilterComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TimeBlocksTableFilterComposer get blockId {
    final $$TimeBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.timeBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeBlocksTableFilterComposer(
            $db: $db,
            $table: $db.timeBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> estimationRecordsRefs(
    Expression<bool> Function($$EstimationRecordsTableFilterComposer f) f,
  ) {
    final $$EstimationRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.estimationRecords,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EstimationRecordsTableFilterComposer(
            $db: $db,
            $table: $db.estimationRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$DayweftDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energyRequired => $composableBuilder(
    column: $table.energyRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestedDay => $composableBuilder(
    column: $table.requestedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestedStartTime => $composableBuilder(
    column: $table.requestedStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestedEndTime => $composableBuilder(
    column: $table.requestedEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get approximateTime => $composableBuilder(
    column: $table.approximateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get canSplit => $composableBuilder(
    column: $table.canSplit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumUsefulMinutes => $composableBuilder(
    column: $table.minimumUsefulMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DayPlansTableOrderingComposer get dayPlanId {
    final $$DayPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableOrderingComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TimeBlocksTableOrderingComposer get blockId {
    final $$TimeBlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.timeBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeBlocksTableOrderingComposer(
            $db: $db,
            $table: $db.timeBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get energyRequired => $composableBuilder(
    column: $table.energyRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestedDay => $composableBuilder(
    column: $table.requestedDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestedStartTime => $composableBuilder(
    column: $table.requestedStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestedEndTime => $composableBuilder(
    column: $table.requestedEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get approximateTime => $composableBuilder(
    column: $table.approximateTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<bool> get canSplit =>
      $composableBuilder(column: $table.canSplit, builder: (column) => column);

  GeneratedColumn<int> get minimumUsefulMinutes => $composableBuilder(
    column: $table.minimumUsefulMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncState, String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
    column: $table.localVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remoteVersion => $composableBuilder(
    column: $table.remoteVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$DayPlansTableAnnotationComposer get dayPlanId {
    final $$DayPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TimeBlocksTableAnnotationComposer get blockId {
    final $$TimeBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.blockId,
      referencedTable: $db.timeBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.timeBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> estimationRecordsRefs<T extends Object>(
    Expression<T> Function($$EstimationRecordsTableAnnotationComposer a) f,
  ) {
    final $$EstimationRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.estimationRecords,
          getReferencedColumn: (t) => t.taskId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EstimationRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.estimationRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, $$TasksTableReferences),
          Task,
          PrefetchHooks Function({
            bool dayPlanId,
            bool blockId,
            bool estimationRecordsRefs,
            bool focusSessionsRefs,
          })
        > {
  $$TasksTableTableManager(_$DayweftDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> dayPlanId = const Value.absent(),
                Value<String?> blockId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> energyRequired = const Value.absent(),
                Value<String?> requestedDay = const Value.absent(),
                Value<String?> requestedStartTime = const Value.absent(),
                Value<String?> requestedEndTime = const Value.absent(),
                Value<bool> approximateTime = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<int?> actualMinutes = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<bool> canSplit = const Value.absent(),
                Value<int> minimumUsefulMinutes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<SyncState> syncState = const Value.absent(),
                Value<int> localVersion = const Value.absent(),
                Value<int?> remoteVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                dayPlanId: dayPlanId,
                blockId: blockId,
                title: title,
                notes: notes,
                energyRequired: energyRequired,
                requestedDay: requestedDay,
                requestedStartTime: requestedStartTime,
                requestedEndTime: requestedEndTime,
                approximateTime: approximateTime,
                estimatedMinutes: estimatedMinutes,
                actualMinutes: actualMinutes,
                priority: priority,
                category: category,
                status: status,
                sourceId: sourceId,
                deadline: deadline,
                canSplit: canSplit,
                minimumUsefulMinutes: minimumUsefulMinutes,
                sortOrder: sortOrder,
                syncState: syncState,
                localVersion: localVersion,
                remoteVersion: remoteVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> dayPlanId = const Value.absent(),
                Value<String?> blockId = const Value.absent(),
                required String title,
                Value<String?> notes = const Value.absent(),
                Value<String?> energyRequired = const Value.absent(),
                Value<String?> requestedDay = const Value.absent(),
                Value<String?> requestedStartTime = const Value.absent(),
                Value<String?> requestedEndTime = const Value.absent(),
                Value<bool> approximateTime = const Value.absent(),
                required int estimatedMinutes,
                Value<int?> actualMinutes = const Value.absent(),
                required String priority,
                Value<String?> category = const Value.absent(),
                required String status,
                Value<String?> sourceId = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<bool> canSplit = const Value.absent(),
                Value<int> minimumUsefulMinutes = const Value.absent(),
                required int sortOrder,
                required SyncState syncState,
                Value<int> localVersion = const Value.absent(),
                Value<int?> remoteVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                dayPlanId: dayPlanId,
                blockId: blockId,
                title: title,
                notes: notes,
                energyRequired: energyRequired,
                requestedDay: requestedDay,
                requestedStartTime: requestedStartTime,
                requestedEndTime: requestedEndTime,
                approximateTime: approximateTime,
                estimatedMinutes: estimatedMinutes,
                actualMinutes: actualMinutes,
                priority: priority,
                category: category,
                status: status,
                sourceId: sourceId,
                deadline: deadline,
                canSplit: canSplit,
                minimumUsefulMinutes: minimumUsefulMinutes,
                sortOrder: sortOrder,
                syncState: syncState,
                localVersion: localVersion,
                remoteVersion: remoteVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                dayPlanId = false,
                blockId = false,
                estimationRecordsRefs = false,
                focusSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (estimationRecordsRefs) db.estimationRecords,
                    if (focusSessionsRefs) db.focusSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (dayPlanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.dayPlanId,
                                    referencedTable: $$TasksTableReferences
                                        ._dayPlanIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._dayPlanIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (blockId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.blockId,
                                    referencedTable: $$TasksTableReferences
                                        ._blockIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._blockIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (estimationRecordsRefs)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          EstimationRecord
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._estimationRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).estimationRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (focusSessionsRefs)
                        await $_getPrefetchedData<
                          Task,
                          $TasksTable,
                          FocusSession
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, $$TasksTableReferences),
      Task,
      PrefetchHooks Function({
        bool dayPlanId,
        bool blockId,
        bool estimationRecordsRefs,
        bool focusSessionsRefs,
      })
    >;
typedef $$ScheduleRevisionsTableCreateCompanionBuilder =
    ScheduleRevisionsCompanion Function({
      required String id,
      required String dayPlanId,
      required int revisionNumber,
      required String reason,
      required String reversibleChangeSetJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ScheduleRevisionsTableUpdateCompanionBuilder =
    ScheduleRevisionsCompanion Function({
      Value<String> id,
      Value<String> dayPlanId,
      Value<int> revisionNumber,
      Value<String> reason,
      Value<String> reversibleChangeSetJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ScheduleRevisionsTableReferences
    extends
        BaseReferences<
          _$DayweftDatabase,
          $ScheduleRevisionsTable,
          ScheduleRevision
        > {
  $$ScheduleRevisionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DayPlansTable _dayPlanIdTable(_$DayweftDatabase db) =>
      db.dayPlans.createAlias('schedule_revisions__day_plan_id__day_plans__id');

  $$DayPlansTableProcessedTableManager get dayPlanId {
    final $_column = $_itemColumn<String>('day_plan_id')!;

    final manager = $$DayPlansTableTableManager(
      $_db,
      $_db.dayPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RevisionUndosTable, List<RevisionUndo>>
  _revisionUndosRefsTable(_$DayweftDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.revisionUndos,
        aliasName: 'schedule_revisions__id__revision_undos__revision_id',
      );

  $$RevisionUndosTableProcessedTableManager get revisionUndosRefs {
    final manager = $$RevisionUndosTableTableManager(
      $_db,
      $_db.revisionUndos,
    ).filter((f) => f.revisionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_revisionUndosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScheduleRevisionsTableFilterComposer
    extends Composer<_$DayweftDatabase, $ScheduleRevisionsTable> {
  $$ScheduleRevisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reversibleChangeSetJson => $composableBuilder(
    column: $table.reversibleChangeSetJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DayPlansTableFilterComposer get dayPlanId {
    final $$DayPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableFilterComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> revisionUndosRefs(
    Expression<bool> Function($$RevisionUndosTableFilterComposer f) f,
  ) {
    final $$RevisionUndosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.revisionUndos,
      getReferencedColumn: (t) => t.revisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RevisionUndosTableFilterComposer(
            $db: $db,
            $table: $db.revisionUndos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleRevisionsTableOrderingComposer
    extends Composer<_$DayweftDatabase, $ScheduleRevisionsTable> {
  $$ScheduleRevisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reversibleChangeSetJson => $composableBuilder(
    column: $table.reversibleChangeSetJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DayPlansTableOrderingComposer get dayPlanId {
    final $$DayPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableOrderingComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleRevisionsTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $ScheduleRevisionsTable> {
  $$ScheduleRevisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get reversibleChangeSetJson => $composableBuilder(
    column: $table.reversibleChangeSetJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DayPlansTableAnnotationComposer get dayPlanId {
    final $$DayPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> revisionUndosRefs<T extends Object>(
    Expression<T> Function($$RevisionUndosTableAnnotationComposer a) f,
  ) {
    final $$RevisionUndosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.revisionUndos,
      getReferencedColumn: (t) => t.revisionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RevisionUndosTableAnnotationComposer(
            $db: $db,
            $table: $db.revisionUndos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleRevisionsTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $ScheduleRevisionsTable,
          ScheduleRevision,
          $$ScheduleRevisionsTableFilterComposer,
          $$ScheduleRevisionsTableOrderingComposer,
          $$ScheduleRevisionsTableAnnotationComposer,
          $$ScheduleRevisionsTableCreateCompanionBuilder,
          $$ScheduleRevisionsTableUpdateCompanionBuilder,
          (ScheduleRevision, $$ScheduleRevisionsTableReferences),
          ScheduleRevision,
          PrefetchHooks Function({bool dayPlanId, bool revisionUndosRefs})
        > {
  $$ScheduleRevisionsTableTableManager(
    _$DayweftDatabase db,
    $ScheduleRevisionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleRevisionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleRevisionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleRevisionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayPlanId = const Value.absent(),
                Value<int> revisionNumber = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> reversibleChangeSetJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleRevisionsCompanion(
                id: id,
                dayPlanId: dayPlanId,
                revisionNumber: revisionNumber,
                reason: reason,
                reversibleChangeSetJson: reversibleChangeSetJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayPlanId,
                required int revisionNumber,
                required String reason,
                required String reversibleChangeSetJson,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ScheduleRevisionsCompanion.insert(
                id: id,
                dayPlanId: dayPlanId,
                revisionNumber: revisionNumber,
                reason: reason,
                reversibleChangeSetJson: reversibleChangeSetJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScheduleRevisionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({dayPlanId = false, revisionUndosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (revisionUndosRefs) db.revisionUndos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (dayPlanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.dayPlanId,
                                    referencedTable:
                                        $$ScheduleRevisionsTableReferences
                                            ._dayPlanIdTable(db),
                                    referencedColumn:
                                        $$ScheduleRevisionsTableReferences
                                            ._dayPlanIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (revisionUndosRefs)
                        await $_getPrefetchedData<
                          ScheduleRevision,
                          $ScheduleRevisionsTable,
                          RevisionUndo
                        >(
                          currentTable: table,
                          referencedTable: $$ScheduleRevisionsTableReferences
                              ._revisionUndosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ScheduleRevisionsTableReferences(
                                db,
                                table,
                                p0,
                              ).revisionUndosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.revisionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ScheduleRevisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $ScheduleRevisionsTable,
      ScheduleRevision,
      $$ScheduleRevisionsTableFilterComposer,
      $$ScheduleRevisionsTableOrderingComposer,
      $$ScheduleRevisionsTableAnnotationComposer,
      $$ScheduleRevisionsTableCreateCompanionBuilder,
      $$ScheduleRevisionsTableUpdateCompanionBuilder,
      (ScheduleRevision, $$ScheduleRevisionsTableReferences),
      ScheduleRevision,
      PrefetchHooks Function({bool dayPlanId, bool revisionUndosRefs})
    >;
typedef $$RevisionUndosTableCreateCompanionBuilder =
    RevisionUndosCompanion Function({
      required String id,
      required String revisionId,
      required DateTime undoneAt,
      Value<int> rowid,
    });
typedef $$RevisionUndosTableUpdateCompanionBuilder =
    RevisionUndosCompanion Function({
      Value<String> id,
      Value<String> revisionId,
      Value<DateTime> undoneAt,
      Value<int> rowid,
    });

final class $$RevisionUndosTableReferences
    extends
        BaseReferences<_$DayweftDatabase, $RevisionUndosTable, RevisionUndo> {
  $$RevisionUndosTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ScheduleRevisionsTable _revisionIdTable(_$DayweftDatabase db) => db
      .scheduleRevisions
      .createAlias('revision_undos__revision_id__schedule_revisions__id');

  $$ScheduleRevisionsTableProcessedTableManager get revisionId {
    final $_column = $_itemColumn<String>('revision_id')!;

    final manager = $$ScheduleRevisionsTableTableManager(
      $_db,
      $_db.scheduleRevisions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_revisionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RevisionUndosTableFilterComposer
    extends Composer<_$DayweftDatabase, $RevisionUndosTable> {
  $$RevisionUndosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get undoneAt => $composableBuilder(
    column: $table.undoneAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ScheduleRevisionsTableFilterComposer get revisionId {
    final $$ScheduleRevisionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.revisionId,
      referencedTable: $db.scheduleRevisions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRevisionsTableFilterComposer(
            $db: $db,
            $table: $db.scheduleRevisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RevisionUndosTableOrderingComposer
    extends Composer<_$DayweftDatabase, $RevisionUndosTable> {
  $$RevisionUndosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get undoneAt => $composableBuilder(
    column: $table.undoneAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ScheduleRevisionsTableOrderingComposer get revisionId {
    final $$ScheduleRevisionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.revisionId,
      referencedTable: $db.scheduleRevisions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRevisionsTableOrderingComposer(
            $db: $db,
            $table: $db.scheduleRevisions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RevisionUndosTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $RevisionUndosTable> {
  $$RevisionUndosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get undoneAt =>
      $composableBuilder(column: $table.undoneAt, builder: (column) => column);

  $$ScheduleRevisionsTableAnnotationComposer get revisionId {
    final $$ScheduleRevisionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.revisionId,
          referencedTable: $db.scheduleRevisions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ScheduleRevisionsTableAnnotationComposer(
                $db: $db,
                $table: $db.scheduleRevisions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RevisionUndosTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $RevisionUndosTable,
          RevisionUndo,
          $$RevisionUndosTableFilterComposer,
          $$RevisionUndosTableOrderingComposer,
          $$RevisionUndosTableAnnotationComposer,
          $$RevisionUndosTableCreateCompanionBuilder,
          $$RevisionUndosTableUpdateCompanionBuilder,
          (RevisionUndo, $$RevisionUndosTableReferences),
          RevisionUndo,
          PrefetchHooks Function({bool revisionId})
        > {
  $$RevisionUndosTableTableManager(
    _$DayweftDatabase db,
    $RevisionUndosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RevisionUndosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RevisionUndosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RevisionUndosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> revisionId = const Value.absent(),
                Value<DateTime> undoneAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RevisionUndosCompanion(
                id: id,
                revisionId: revisionId,
                undoneAt: undoneAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String revisionId,
                required DateTime undoneAt,
                Value<int> rowid = const Value.absent(),
              }) => RevisionUndosCompanion.insert(
                id: id,
                revisionId: revisionId,
                undoneAt: undoneAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RevisionUndosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({revisionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (revisionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.revisionId,
                                referencedTable: $$RevisionUndosTableReferences
                                    ._revisionIdTable(db),
                                referencedColumn: $$RevisionUndosTableReferences
                                    ._revisionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RevisionUndosTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $RevisionUndosTable,
      RevisionUndo,
      $$RevisionUndosTableFilterComposer,
      $$RevisionUndosTableOrderingComposer,
      $$RevisionUndosTableAnnotationComposer,
      $$RevisionUndosTableCreateCompanionBuilder,
      $$RevisionUndosTableUpdateCompanionBuilder,
      (RevisionUndo, $$RevisionUndosTableReferences),
      RevisionUndo,
      PrefetchHooks Function({bool revisionId})
    >;
typedef $$SyncOperationsTableCreateCompanionBuilder =
    SyncOperationsCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operationType,
      required String payloadJson,
      Value<int> attemptCount,
      required DateTime nextAttemptAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SyncOperationsTableUpdateCompanionBuilder =
    SyncOperationsCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operationType,
      Value<String> payloadJson,
      Value<int> attemptCount,
      Value<DateTime> nextAttemptAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SyncOperationsTableFilterComposer
    extends Composer<_$DayweftDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOperationsTableOrderingComposer
    extends Composer<_$DayweftDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOperationsTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOperationsTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $SyncOperationsTable,
          SyncOperation,
          $$SyncOperationsTableFilterComposer,
          $$SyncOperationsTableOrderingComposer,
          $$SyncOperationsTableAnnotationComposer,
          $$SyncOperationsTableCreateCompanionBuilder,
          $$SyncOperationsTableUpdateCompanionBuilder,
          (
            SyncOperation,
            BaseReferences<
              _$DayweftDatabase,
              $SyncOperationsTable,
              SyncOperation
            >,
          ),
          SyncOperation,
          PrefetchHooks Function()
        > {
  $$SyncOperationsTableTableManager(
    _$DayweftDatabase db,
    $SyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime> nextAttemptAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                payloadJson: payloadJson,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operationType,
                required String payloadJson,
                Value<int> attemptCount = const Value.absent(),
                required DateTime nextAttemptAt,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operationType: operationType,
                payloadJson: payloadJson,
                attemptCount: attemptCount,
                nextAttemptAt: nextAttemptAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $SyncOperationsTable,
      SyncOperation,
      $$SyncOperationsTableFilterComposer,
      $$SyncOperationsTableOrderingComposer,
      $$SyncOperationsTableAnnotationComposer,
      $$SyncOperationsTableCreateCompanionBuilder,
      $$SyncOperationsTableUpdateCompanionBuilder,
      (
        SyncOperation,
        BaseReferences<_$DayweftDatabase, $SyncOperationsTable, SyncOperation>,
      ),
      SyncOperation,
      PrefetchHooks Function()
    >;
typedef $$EstimationRecordsTableCreateCompanionBuilder =
    EstimationRecordsCompanion Function({
      required String id,
      Value<String?> taskId,
      Value<String?> category,
      required int estimatedMinutes,
      required int actualMinutes,
      Value<String> measurementSource,
      required String timeOfDay,
      required int dayOfWeek,
      Value<int> interruptionCount,
      Value<bool> wasSplit,
      Value<int?> difficulty,
      Value<bool> excluded,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$EstimationRecordsTableUpdateCompanionBuilder =
    EstimationRecordsCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<String?> category,
      Value<int> estimatedMinutes,
      Value<int> actualMinutes,
      Value<String> measurementSource,
      Value<String> timeOfDay,
      Value<int> dayOfWeek,
      Value<int> interruptionCount,
      Value<bool> wasSplit,
      Value<int?> difficulty,
      Value<bool> excluded,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$EstimationRecordsTableReferences
    extends
        BaseReferences<
          _$DayweftDatabase,
          $EstimationRecordsTable,
          EstimationRecord
        > {
  $$EstimationRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$DayweftDatabase db) =>
      db.tasks.createAlias('estimation_records__task_id__tasks__id');

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EstimationRecordsTableFilterComposer
    extends Composer<_$DayweftDatabase, $EstimationRecordsTable> {
  $$EstimationRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementSource => $composableBuilder(
    column: $table.measurementSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interruptionCount => $composableBuilder(
    column: $table.interruptionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasSplit => $composableBuilder(
    column: $table.wasSplit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get excluded => $composableBuilder(
    column: $table.excluded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EstimationRecordsTableOrderingComposer
    extends Composer<_$DayweftDatabase, $EstimationRecordsTable> {
  $$EstimationRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementSource => $composableBuilder(
    column: $table.measurementSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeOfDay => $composableBuilder(
    column: $table.timeOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interruptionCount => $composableBuilder(
    column: $table.interruptionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasSplit => $composableBuilder(
    column: $table.wasSplit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get excluded => $composableBuilder(
    column: $table.excluded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EstimationRecordsTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $EstimationRecordsTable> {
  $$EstimationRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementSource => $composableBuilder(
    column: $table.measurementSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeOfDay =>
      $composableBuilder(column: $table.timeOfDay, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<int> get interruptionCount => $composableBuilder(
    column: $table.interruptionCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wasSplit =>
      $composableBuilder(column: $table.wasSplit, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get excluded =>
      $composableBuilder(column: $table.excluded, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EstimationRecordsTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $EstimationRecordsTable,
          EstimationRecord,
          $$EstimationRecordsTableFilterComposer,
          $$EstimationRecordsTableOrderingComposer,
          $$EstimationRecordsTableAnnotationComposer,
          $$EstimationRecordsTableCreateCompanionBuilder,
          $$EstimationRecordsTableUpdateCompanionBuilder,
          (EstimationRecord, $$EstimationRecordsTableReferences),
          EstimationRecord,
          PrefetchHooks Function({bool taskId})
        > {
  $$EstimationRecordsTableTableManager(
    _$DayweftDatabase db,
    $EstimationRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EstimationRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EstimationRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EstimationRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<int> actualMinutes = const Value.absent(),
                Value<String> measurementSource = const Value.absent(),
                Value<String> timeOfDay = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<int> interruptionCount = const Value.absent(),
                Value<bool> wasSplit = const Value.absent(),
                Value<int?> difficulty = const Value.absent(),
                Value<bool> excluded = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EstimationRecordsCompanion(
                id: id,
                taskId: taskId,
                category: category,
                estimatedMinutes: estimatedMinutes,
                actualMinutes: actualMinutes,
                measurementSource: measurementSource,
                timeOfDay: timeOfDay,
                dayOfWeek: dayOfWeek,
                interruptionCount: interruptionCount,
                wasSplit: wasSplit,
                difficulty: difficulty,
                excluded: excluded,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                Value<String?> category = const Value.absent(),
                required int estimatedMinutes,
                required int actualMinutes,
                Value<String> measurementSource = const Value.absent(),
                required String timeOfDay,
                required int dayOfWeek,
                Value<int> interruptionCount = const Value.absent(),
                Value<bool> wasSplit = const Value.absent(),
                Value<int?> difficulty = const Value.absent(),
                Value<bool> excluded = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EstimationRecordsCompanion.insert(
                id: id,
                taskId: taskId,
                category: category,
                estimatedMinutes: estimatedMinutes,
                actualMinutes: actualMinutes,
                measurementSource: measurementSource,
                timeOfDay: timeOfDay,
                dayOfWeek: dayOfWeek,
                interruptionCount: interruptionCount,
                wasSplit: wasSplit,
                difficulty: difficulty,
                excluded: excluded,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EstimationRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$EstimationRecordsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$EstimationRecordsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EstimationRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $EstimationRecordsTable,
      EstimationRecord,
      $$EstimationRecordsTableFilterComposer,
      $$EstimationRecordsTableOrderingComposer,
      $$EstimationRecordsTableAnnotationComposer,
      $$EstimationRecordsTableCreateCompanionBuilder,
      $$EstimationRecordsTableUpdateCompanionBuilder,
      (EstimationRecord, $$EstimationRecordsTableReferences),
      EstimationRecord,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$EnergyCheckInsTableCreateCompanionBuilder =
    EnergyCheckInsCompanion Function({
      required String id,
      required String level,
      required DateTime checkedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$EnergyCheckInsTableUpdateCompanionBuilder =
    EnergyCheckInsCompanion Function({
      Value<String> id,
      Value<String> level,
      Value<DateTime> checkedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$EnergyCheckInsTableFilterComposer
    extends Composer<_$DayweftDatabase, $EnergyCheckInsTable> {
  $$EnergyCheckInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EnergyCheckInsTableOrderingComposer
    extends Composer<_$DayweftDatabase, $EnergyCheckInsTable> {
  $$EnergyCheckInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedAt => $composableBuilder(
    column: $table.checkedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnergyCheckInsTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $EnergyCheckInsTable> {
  $$EnergyCheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedAt =>
      $composableBuilder(column: $table.checkedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EnergyCheckInsTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $EnergyCheckInsTable,
          EnergyCheckIn,
          $$EnergyCheckInsTableFilterComposer,
          $$EnergyCheckInsTableOrderingComposer,
          $$EnergyCheckInsTableAnnotationComposer,
          $$EnergyCheckInsTableCreateCompanionBuilder,
          $$EnergyCheckInsTableUpdateCompanionBuilder,
          (
            EnergyCheckIn,
            BaseReferences<
              _$DayweftDatabase,
              $EnergyCheckInsTable,
              EnergyCheckIn
            >,
          ),
          EnergyCheckIn,
          PrefetchHooks Function()
        > {
  $$EnergyCheckInsTableTableManager(
    _$DayweftDatabase db,
    $EnergyCheckInsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnergyCheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnergyCheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnergyCheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<DateTime> checkedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnergyCheckInsCompanion(
                id: id,
                level: level,
                checkedAt: checkedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String level,
                required DateTime checkedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnergyCheckInsCompanion.insert(
                id: id,
                level: level,
                checkedAt: checkedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EnergyCheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $EnergyCheckInsTable,
      EnergyCheckIn,
      $$EnergyCheckInsTableFilterComposer,
      $$EnergyCheckInsTableOrderingComposer,
      $$EnergyCheckInsTableAnnotationComposer,
      $$EnergyCheckInsTableCreateCompanionBuilder,
      $$EnergyCheckInsTableUpdateCompanionBuilder,
      (
        EnergyCheckIn,
        BaseReferences<_$DayweftDatabase, $EnergyCheckInsTable, EnergyCheckIn>,
      ),
      EnergyCheckIn,
      PrefetchHooks Function()
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<String?> taskId,
      required String title,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required int plannedMinutes,
      Value<int?> actualMinutes,
      Value<int> interruptionCount,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<String?> taskId,
      Value<String> title,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> plannedMinutes,
      Value<int?> actualMinutes,
      Value<int> interruptionCount,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$FocusSessionsTableReferences
    extends
        BaseReferences<_$DayweftDatabase, $FocusSessionsTable, FocusSession> {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$DayweftDatabase db) =>
      db.tasks.createAlias('focus_sessions__task_id__tasks__id');

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$DayweftDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interruptionCount => $composableBuilder(
    column: $table.interruptionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$DayweftDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interruptionCount => $composableBuilder(
    column: $table.interruptionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualMinutes => $composableBuilder(
    column: $table.actualMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interruptionCount => $composableBuilder(
    column: $table.interruptionCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSession, $$FocusSessionsTableReferences),
          FocusSession,
          PrefetchHooks Function({bool taskId})
        > {
  $$FocusSessionsTableTableManager(
    _$DayweftDatabase db,
    $FocusSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> plannedMinutes = const Value.absent(),
                Value<int?> actualMinutes = const Value.absent(),
                Value<int> interruptionCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                taskId: taskId,
                title: title,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                actualMinutes: actualMinutes,
                interruptionCount: interruptionCount,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> taskId = const Value.absent(),
                required String title,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required int plannedMinutes,
                Value<int?> actualMinutes = const Value.absent(),
                Value<int> interruptionCount = const Value.absent(),
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                taskId: taskId,
                title: title,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedMinutes: plannedMinutes,
                actualMinutes: actualMinutes,
                interruptionCount: interruptionCount,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$FocusSessionsTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$FocusSessionsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSession, $$FocusSessionsTableReferences),
      FocusSession,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$ShareLinksTableCreateCompanionBuilder =
    ShareLinksCompanion Function({
      required String id,
      required String tokenHash,
      required String shareType,
      required String payloadJson,
      required DateTime expiresAt,
      Value<DateTime?> revokedAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ShareLinksTableUpdateCompanionBuilder =
    ShareLinksCompanion Function({
      Value<String> id,
      Value<String> tokenHash,
      Value<String> shareType,
      Value<String> payloadJson,
      Value<DateTime> expiresAt,
      Value<DateTime?> revokedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ShareLinksTableFilterComposer
    extends Composer<_$DayweftDatabase, $ShareLinksTable> {
  $$ShareLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shareType => $composableBuilder(
    column: $table.shareType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShareLinksTableOrderingComposer
    extends Composer<_$DayweftDatabase, $ShareLinksTable> {
  $$ShareLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenHash => $composableBuilder(
    column: $table.tokenHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareType => $composableBuilder(
    column: $table.shareType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShareLinksTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $ShareLinksTable> {
  $$ShareLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokenHash =>
      $composableBuilder(column: $table.tokenHash, builder: (column) => column);

  GeneratedColumn<String> get shareType =>
      $composableBuilder(column: $table.shareType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get revokedAt =>
      $composableBuilder(column: $table.revokedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ShareLinksTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $ShareLinksTable,
          ShareLink,
          $$ShareLinksTableFilterComposer,
          $$ShareLinksTableOrderingComposer,
          $$ShareLinksTableAnnotationComposer,
          $$ShareLinksTableCreateCompanionBuilder,
          $$ShareLinksTableUpdateCompanionBuilder,
          (
            ShareLink,
            BaseReferences<_$DayweftDatabase, $ShareLinksTable, ShareLink>,
          ),
          ShareLink,
          PrefetchHooks Function()
        > {
  $$ShareLinksTableTableManager(_$DayweftDatabase db, $ShareLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShareLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShareLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShareLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokenHash = const Value.absent(),
                Value<String> shareType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShareLinksCompanion(
                id: id,
                tokenHash: tokenHash,
                shareType: shareType,
                payloadJson: payloadJson,
                expiresAt: expiresAt,
                revokedAt: revokedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokenHash,
                required String shareType,
                required String payloadJson,
                required DateTime expiresAt,
                Value<DateTime?> revokedAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ShareLinksCompanion.insert(
                id: id,
                tokenHash: tokenHash,
                shareType: shareType,
                payloadJson: payloadJson,
                expiresAt: expiresAt,
                revokedAt: revokedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShareLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $ShareLinksTable,
      ShareLink,
      $$ShareLinksTableFilterComposer,
      $$ShareLinksTableOrderingComposer,
      $$ShareLinksTableAnnotationComposer,
      $$ShareLinksTableCreateCompanionBuilder,
      $$ShareLinksTableUpdateCompanionBuilder,
      (
        ShareLink,
        BaseReferences<_$DayweftDatabase, $ShareLinksTable, ShareLink>,
      ),
      ShareLink,
      PrefetchHooks Function()
    >;
typedef $$CalendarConnectionsTableCreateCompanionBuilder =
    CalendarConnectionsCompanion Function({
      required String id,
      required String platform,
      required String permissionState,
      Value<bool> readOnly,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CalendarConnectionsTableUpdateCompanionBuilder =
    CalendarConnectionsCompanion Function({
      Value<String> id,
      Value<String> platform,
      Value<String> permissionState,
      Value<bool> readOnly,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CalendarConnectionsTableFilterComposer
    extends Composer<_$DayweftDatabase, $CalendarConnectionsTable> {
  $$CalendarConnectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get permissionState => $composableBuilder(
    column: $table.permissionState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get readOnly => $composableBuilder(
    column: $table.readOnly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarConnectionsTableOrderingComposer
    extends Composer<_$DayweftDatabase, $CalendarConnectionsTable> {
  $$CalendarConnectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get permissionState => $composableBuilder(
    column: $table.permissionState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get readOnly => $composableBuilder(
    column: $table.readOnly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarConnectionsTableAnnotationComposer
    extends Composer<_$DayweftDatabase, $CalendarConnectionsTable> {
  $$CalendarConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get permissionState => $composableBuilder(
    column: $table.permissionState,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get readOnly =>
      $composableBuilder(column: $table.readOnly, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CalendarConnectionsTableTableManager
    extends
        RootTableManager<
          _$DayweftDatabase,
          $CalendarConnectionsTable,
          CalendarConnection,
          $$CalendarConnectionsTableFilterComposer,
          $$CalendarConnectionsTableOrderingComposer,
          $$CalendarConnectionsTableAnnotationComposer,
          $$CalendarConnectionsTableCreateCompanionBuilder,
          $$CalendarConnectionsTableUpdateCompanionBuilder,
          (
            CalendarConnection,
            BaseReferences<
              _$DayweftDatabase,
              $CalendarConnectionsTable,
              CalendarConnection
            >,
          ),
          CalendarConnection,
          PrefetchHooks Function()
        > {
  $$CalendarConnectionsTableTableManager(
    _$DayweftDatabase db,
    $CalendarConnectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarConnectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarConnectionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalendarConnectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> permissionState = const Value.absent(),
                Value<bool> readOnly = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarConnectionsCompanion(
                id: id,
                platform: platform,
                permissionState: permissionState,
                readOnly: readOnly,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String platform,
                required String permissionState,
                Value<bool> readOnly = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CalendarConnectionsCompanion.insert(
                id: id,
                platform: platform,
                permissionState: permissionState,
                readOnly: readOnly,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarConnectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$DayweftDatabase,
      $CalendarConnectionsTable,
      CalendarConnection,
      $$CalendarConnectionsTableFilterComposer,
      $$CalendarConnectionsTableOrderingComposer,
      $$CalendarConnectionsTableAnnotationComposer,
      $$CalendarConnectionsTableCreateCompanionBuilder,
      $$CalendarConnectionsTableUpdateCompanionBuilder,
      (
        CalendarConnection,
        BaseReferences<
          _$DayweftDatabase,
          $CalendarConnectionsTable,
          CalendarConnection
        >,
      ),
      CalendarConnection,
      PrefetchHooks Function()
    >;

class $DayweftDatabaseManager {
  final _$DayweftDatabase _db;
  $DayweftDatabaseManager(this._db);
  $$DayPlansTableTableManager get dayPlans =>
      $$DayPlansTableTableManager(_db, _db.dayPlans);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$TimeBlocksTableTableManager get timeBlocks =>
      $$TimeBlocksTableTableManager(_db, _db.timeBlocks);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ScheduleRevisionsTableTableManager get scheduleRevisions =>
      $$ScheduleRevisionsTableTableManager(_db, _db.scheduleRevisions);
  $$RevisionUndosTableTableManager get revisionUndos =>
      $$RevisionUndosTableTableManager(_db, _db.revisionUndos);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
  $$EstimationRecordsTableTableManager get estimationRecords =>
      $$EstimationRecordsTableTableManager(_db, _db.estimationRecords);
  $$EnergyCheckInsTableTableManager get energyCheckIns =>
      $$EnergyCheckInsTableTableManager(_db, _db.energyCheckIns);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$ShareLinksTableTableManager get shareLinks =>
      $$ShareLinksTableTableManager(_db, _db.shareLinks);
  $$CalendarConnectionsTableTableManager get calendarConnections =>
      $$CalendarConnectionsTableTableManager(_db, _db.calendarConnections);
}
