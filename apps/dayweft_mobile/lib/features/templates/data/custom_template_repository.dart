import 'dart:convert';

import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class CustomTemplateRepository {
  CustomTemplateRepository(
    this._db, {
    DateTime Function()? now,
    Uuid uuid = const Uuid(),
  }) : _now = now ?? DateTime.now,
       _uuid = uuid;
  final DayweftDatabase _db;
  final DateTime Function() _now;
  final Uuid _uuid;

  Future<List<domain.DayTemplate>> loadAll() async =>
      (await (_db.select(_db.savedTemplates)
                ..where((row) => row.deletedAt.isNull())
                ..orderBy([
                  (row) => OrderingTerm.desc(row.updatedAt),
                  (row) => OrderingTerm(expression: row.id),
                ]))
              .get())
          .map(_decode)
          .toList();

  Future<domain.DayTemplate> get(String id) async =>
      _decode(await _require(id));

  Future<domain.DayTemplate> create({
    required String name,
    required List<domain.TemplateBlock> blocks,
  }) => _db.transaction(() async {
    final id = 'user:${_uuid.v4()}';
    final normalised = _normalise(blocks);
    _validate(id, name, normalised);
    await _checkCapacity();
    final now = _now();
    await _db
        .into(_db.savedTemplates)
        .insert(
          SavedTemplatesCompanion.insert(
            id: id,
            name: name.trim(),
            blocksJson: _encode(normalised),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return get(id);
  });

  Future<domain.DayTemplate> update({
    required String id,
    required int expectedVersion,
    required String name,
    required List<domain.TemplateBlock> blocks,
  }) => _db.transaction(() async {
    final current = await _require(id, expectedVersion: expectedVersion);
    final normalised = _normalise(blocks);
    _validate(id, name, normalised);
    await (_db.update(
      _db.savedTemplates,
    )..where((row) => row.id.equals(id))).write(
      SavedTemplatesCompanion(
        name: Value(name.trim()),
        blocksJson: Value(_encode(normalised)),
        version: Value(current.version + 1),
        updatedAt: Value(_now()),
      ),
    );
    return get(id);
  });

  Future<domain.DayTemplate> duplicate(
    String id, {
    required int expectedVersion,
  }) => _db.transaction(() async {
    final current = _decode(
      await _require(id, expectedVersion: expectedVersion),
    );
    final name = current.name.length > 70
        ? current.name.substring(0, 70)
        : current.name;
    return create(
      name: '$name (copy)',
      blocks: current.blocks.map((block) => _copy(block, _uuid.v4())).toList(),
    );
  });

  Future<int> delete(String id, {required int expectedVersion}) =>
      _db.transaction(() async {
        final current = await _require(id, expectedVersion: expectedVersion);
        await (_db.update(
          _db.savedTemplates,
        )..where((row) => row.id.equals(id))).write(
          SavedTemplatesCompanion(
            deletedAt: Value(_now()),
            updatedAt: Value(_now()),
            version: Value(current.version + 1),
          ),
        );
        return current.version + 1;
      });

  Future<void> restore(String id, {required int expectedVersion}) =>
      _db.transaction(() async {
        final current = await (_db.select(
          _db.savedTemplates,
        )..where((row) => row.id.equals(id))).getSingleOrNull();
        if (current == null ||
            current.deletedAt == null ||
            current.version != expectedVersion) {
          _stale();
        }
        await _checkCapacity();
        await (_db.update(
          _db.savedTemplates,
        )..where((row) => row.id.equals(id))).write(
          SavedTemplatesCompanion(
            deletedAt: const Value(null),
            version: Value(current.version + 1),
            updatedAt: Value(_now()),
          ),
        );
      });

  Future<domain.DayTemplate> createFromBlocks({
    required String name,
    required Iterable<TimeBlock> blocks,
  }) => create(name: name, blocks: blocksFromDay(blocks));

  List<domain.TemplateBlock> blocksFromDay(Iterable<TimeBlock> blocks) {
    final sorted = blocks.toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    String time(DateTime value) =>
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    if (sorted.any(
      (block) =>
          block.endsAt.difference(block.startsAt) <= Duration.zero ||
          block.endsAt.difference(block.startsAt) >= const Duration(days: 1),
    )) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Template blocks must last less than 24 hours. Review this day before saving it.',
      );
    }
    return [
      for (final block in sorted)
        domain.TemplateBlock(
          title: block.title,
          startTime: time(block.startsAt),
          endTime: time(block.endsAt),
          blockType: block.blockType,
          category: block.category ?? '',
          travelBufferMinutes: block.travelBufferMinutes,
          preparationBufferMinutes: block.preparationBufferMinutes,
          transitionBufferMinutes: block.transitionBufferMinutes,
          recoveryBufferMinutes: block.recoveryBufferMinutes,
        ),
    ];
  }

  Future<SavedTemplate> _require(String id, {int? expectedVersion}) async {
    final row =
        await (_db.select(_db.savedTemplates)
              ..where((row) => row.id.equals(id) & row.deletedAt.isNull()))
            .getSingleOrNull();
    if (row == null) {
      throw const PlanningFailure(
        PlanningFailureCode.notFound,
        'This template is no longer available.',
      );
    }
    if (expectedVersion != null && expectedVersion != row.version) _stale();
    return row;
  }

  Never _stale() => throw const PlanningFailure(
    PlanningFailureCode.staleProposal,
    'This template changed. Close the editor and review its latest version.',
  );

  Future<void> _checkCapacity() async {
    final count = _db.savedTemplates.id.count();
    final result =
        await (_db.selectOnly(_db.savedTemplates)
              ..addColumns([count])
              ..where(_db.savedTemplates.deletedAt.isNull()))
            .getSingle();
    if ((result.read(count) ?? 0) >= 500) {
      throw const PlanningFailure(
        PlanningFailureCode.invalidInput,
        'Keep up to 500 custom templates. Remove an unused template before adding or restoring another.',
      );
    }
  }

  List<domain.TemplateBlock> _normalise(List<domain.TemplateBlock> blocks) =>
      List.unmodifiable(
        blocks.map((block) => _copy(block, block.id ?? _uuid.v4())),
      );

  domain.TemplateBlock _copy(domain.TemplateBlock b, String id) =>
      domain.TemplateBlock(
        id: id,
        title: b.title.trim(),
        startTime: b.startTime,
        endTime: b.endTime,
        blockType: b.blockType,
        category: b.category.trim(),
        travelBufferMinutes: b.travelBufferMinutes,
        preparationBufferMinutes: b.preparationBufferMinutes,
        transitionBufferMinutes: b.transitionBufferMinutes,
        recoveryBufferMinutes: b.recoveryBufferMinutes,
      );

  void _validate(String id, String name, List<domain.TemplateBlock> blocks) {
    final issue = domain.templateDefinitionIssue(
      domain.DayTemplate(id: id, name: name, blocks: blocks),
    );
    if (issue != null) {
      throw PlanningFailure(PlanningFailureCode.invalidInput, issue);
    }
  }

  String _encode(List<domain.TemplateBlock> blocks) => jsonEncode([
    for (final b in blocks)
      {
        'id': b.id,
        'title': b.title,
        'startTime': b.startTime,
        'endTime': b.endTime,
        'blockType': b.blockType,
        'category': b.category,
        'travelBufferMinutes': b.travelBufferMinutes,
        'preparationBufferMinutes': b.preparationBufferMinutes,
        'transitionBufferMinutes': b.transitionBufferMinutes,
        'recoveryBufferMinutes': b.recoveryBufferMinutes,
      },
  ]);

  domain.DayTemplate _decode(SavedTemplate row) {
    try {
      if (row.formatVersion != 1) {
        throw const FormatException('Unsupported template format');
      }
      final values = (jsonDecode(row.blocksJson) as List<Object?>)
          .cast<Map<String, Object?>>();
      final blocks = List<domain.TemplateBlock>.unmodifiable(
        values.map(
          (b) => domain.TemplateBlock(
            id: b['id']! as String,
            title: b['title']! as String,
            startTime: b['startTime']! as String,
            endTime: b['endTime']! as String,
            blockType: b['blockType']! as String,
            category: b['category']! as String,
            travelBufferMinutes: b['travelBufferMinutes']! as int,
            preparationBufferMinutes: b['preparationBufferMinutes']! as int,
            transitionBufferMinutes: b['transitionBufferMinutes']! as int,
            recoveryBufferMinutes: b['recoveryBufferMinutes']! as int,
          ),
        ),
      );
      _validate(row.id, row.name, blocks);
      return domain.DayTemplate(
        id: row.id,
        name: row.name,
        blocks: blocks,
        version: row.version,
      );
    } on FormatException {
      return _invalidStored();
    } on TypeError {
      return _invalidStored();
    } on PlanningFailure {
      return _invalidStored();
    }
  }

  Never _invalidStored() => throw const PlanningFailure(
    PlanningFailureCode.invalidInput,
    'A saved template could not be read. Your plans have not been changed.',
  );
}
