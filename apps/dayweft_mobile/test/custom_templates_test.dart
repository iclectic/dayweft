import 'dart:io';

import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/templates/application/template_library_controller.dart';
import 'package:dayweft_mobile/features/templates/data/custom_template_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _block = domain.TemplateBlock(
  title: 'Prepare',
  startTime: '09:00',
  endTime: '10:00',
  blockType: 'flexible',
  category: 'work',
  preparationBufferMinutes: 10,
);

void main() {
  late DayweftDatabase database;
  late CustomTemplateRepository templates;
  late LocalPlanningRepository planning;
  setUp(() {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    templates = CustomTemplateRepository(
      database,
      now: () => DateTime(2026, 10, 29, 8),
    );
    planning = LocalPlanningRepository(
      database,
      now: () => DateTime(2026, 10, 29, 8),
    );
  });
  tearDown(() => database.close());

  test(
    'custom blocks retain stable identities, buffers and versions',
    () async {
      final saved = await templates.create(
        name: 'My working day',
        blocks: [_block],
      );
      final restored = await CustomTemplateRepository(database).get(saved.id);
      expect(restored.name, 'My working day');
      expect(restored.version, 1);
      expect(restored.blocks.single.id, isNotEmpty);
      expect(restored.blocks.single.preparationBufferMinutes, 10);
      expect(() => restored.blocks.clear(), throwsUnsupportedError);
      expect((await templates.loadAll()).single.id, saved.id);
    },
  );

  test(
    'template edits and deletion undo survive closing the SQLite file',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'dayweft-template-',
      );
      final file = File('${directory.path}/templates.sqlite');
      var connection = DayweftDatabase.forTesting(NativeDatabase(file));
      try {
        var repository = CustomTemplateRepository(connection);
        final saved = await repository.create(
          name: 'Persistent',
          blocks: [_block],
        );
        final deletedVersion = await repository.delete(
          saved.id,
          expectedVersion: 1,
        );
        await connection.close();
        connection = DayweftDatabase.forTesting(NativeDatabase(file));
        repository = CustomTemplateRepository(connection);
        expect(await repository.loadAll(), isEmpty);
        await repository.restore(saved.id, expectedVersion: deletedVersion);
        final restored = await repository.get(saved.id);
        expect(restored.version, 3);
        expect(restored.blocks.single.id, saved.blocks.single.id);
        expect(restored.blocks.single.preparationBufferMinutes, 10);
      } finally {
        await connection.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test(
    'stale deletion undo cannot change a restored or edited template',
    () async {
      final saved = await templates.create(name: 'Original', blocks: [_block]);
      final deletedVersion = await templates.delete(
        saved.id,
        expectedVersion: 1,
      );
      await expectLater(
        templates.restore(saved.id, expectedVersion: 1),
        throwsA(isA<PlanningFailure>()),
      );
      await templates.restore(saved.id, expectedVersion: deletedVersion);
      await templates.update(
        id: saved.id,
        expectedVersion: 3,
        name: 'Newer edit',
        blocks: saved.blocks,
      );
      await expectLater(
        templates.restore(saved.id, expectedVersion: deletedVersion),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await templates.get(saved.id)).name, 'Newer edit');
    },
  );

  test(
    'template capacity applies equally to creation and deletion undo',
    () async {
      final saved = await templates.create(
        name: 'Restore me',
        blocks: [_block],
      );
      final row = await database.select(database.savedTemplates).getSingle();
      final version = await templates.delete(saved.id, expectedVersion: 1);
      await database.batch(
        (batch) => batch.insertAll(database.savedTemplates, [
          for (var i = 0; i < 500; i++)
            SavedTemplatesCompanion.insert(
              id: 'capacity:$i',
              name: 'Fixture',
              blocksJson: row.blocksJson,
              createdAt: row.createdAt,
              updatedAt: row.updatedAt,
            ),
        ]),
      );
      await expectLater(
        templates.create(name: 'Over capacity', blocks: [_block]),
        throwsA(isA<PlanningFailure>()),
      );
      await expectLater(
        templates.restore(saved.id, expectedVersion: version),
        throwsA(isA<PlanningFailure>()),
      );
      expect(await templates.loadAll(), hasLength(500));
      await templates.delete('capacity:0', expectedVersion: 1);
      await templates.restore(saved.id, expectedVersion: version);
      expect((await templates.get(saved.id)).name, 'Restore me');
    },
  );

  test(
    'unreadable saved content fails safely without resetting user data',
    () async {
      final saved = await templates.create(name: 'Original', blocks: [_block]);
      await planning.addInboxTask(title: 'Keep my task');
      await (database.update(
        database.savedTemplates,
      )..where((t) => t.id.equals(saved.id))).write(
        const SavedTemplatesCompanion(blocksJson: Value('{malformed')),
      );
      await expectLater(templates.loadAll(), throwsA(isA<PlanningFailure>()));
      expect(
        (await planning.loadToday()).inboxTasks.single.title,
        'Keep my task',
      );
      expect(
        await database.select(database.savedTemplates).get(),
        hasLength(1),
      );
    },
  );

  test(
    'stale edits and deletions cannot overwrite the latest template',
    () async {
      final saved = await templates.create(name: 'Original', blocks: [_block]);
      final edited = await templates.update(
        id: saved.id,
        expectedVersion: saved.version!,
        name: 'Renamed',
        blocks: saved.blocks,
      );
      expect(edited.version, 2);
      await expectLater(
        templates.update(
          id: saved.id,
          expectedVersion: 1,
          name: 'Stale',
          blocks: saved.blocks,
        ),
        throwsA(isA<PlanningFailure>()),
      );
      await expectLater(
        templates.delete(saved.id, expectedVersion: 1),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await templates.get(saved.id)).name, 'Renamed');
    },
  );

  test(
    'duplicate uses separate identities and deletion can be restored durably',
    () async {
      final saved = await templates.create(name: 'Original', blocks: [_block]);
      final copy = await templates.duplicate(saved.id, expectedVersion: 1);
      expect(copy.id, isNot(saved.id));
      expect(copy.blocks.single.id, isNot(saved.blocks.single.id));
      final deletedVersion = await templates.delete(
        saved.id,
        expectedVersion: 1,
      );
      expect(await templates.loadAll(), hasLength(1));
      await expectLater(
        templates.get(saved.id),
        throwsA(isA<PlanningFailure>()),
      );
      await CustomTemplateRepository(
        database,
      ).restore(saved.id, expectedVersion: deletedVersion);
      expect(await templates.loadAll(), hasLength(2));
      expect(
        (await templates.get(saved.id)).blocks.single.id,
        saved.blocks.single.id,
      );
    },
  );

  test(
    'saving a day copies reviewed block settings without task content',
    () async {
      await planning.addBlock(
        title: 'Night shift',
        startsAt: DateTime(2026, 10, 29, 22),
        endsAt: DateTime(2026, 10, 30, 1),
        blockType: 'fixed',
        recoveryBufferMinutes: 15,
      );
      final snapshot = await planning.loadToday();
      await planning.addTaskToBlock(
        blockId: snapshot.blocks.single.id,
        title: 'Private task detail',
        estimatedMinutes: 30,
      );
      final saved = await templates.createFromBlocks(
        name: 'My shift',
        blocks: snapshot.blocks,
      );
      expect(saved.blocks.single.startTime, '22:00');
      expect(saved.blocks.single.endTime, '01:00');
      expect(saved.blocks.single.recoveryBufferMinutes, 15);
      final stored = await database.select(database.savedTemplates).getSingle();
      expect(stored.blocksJson, isNot(contains('Private task detail')));
      expect(
        (await planning.loadToday()).tasks.single.title,
        'Private task detail',
      );
    },
  );

  test(
    'edited or deleted custom templates invalidate their application preview',
    () async {
      var saved = await templates.create(name: 'My work', blocks: [_block]);
      final preview = await planning.previewTemplate(saved);
      saved = await templates.update(
        id: saved.id,
        expectedVersion: 1,
        name: 'Changed name',
        blocks: saved.blocks,
      );
      await expectLater(
        planning.applyTemplatePreview(preview),
        throwsA(isA<PlanningFailure>()),
      );
      final second = await planning.previewTemplate(saved);
      await templates.delete(saved.id, expectedVersion: saved.version!);
      await expectLater(
        planning.applyTemplatePreview(second),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await planning.loadToday()).blocks, isEmpty);
    },
  );

  test(
    'applying a custom template retains buffers and duplicate protection after rename',
    () async {
      var saved = await templates.create(name: 'My work', blocks: [_block]);
      await planning.applyTemplate(saved);
      expect(
        (await planning.loadToday()).blocks.single.preparationBufferMinutes,
        10,
      );
      saved = await templates.update(
        id: saved.id,
        expectedVersion: 1,
        name: 'Renamed',
        blocks: saved.blocks,
      );
      expect((await planning.previewTemplate(saved)).placements, isEmpty);
    },
  );

  test(
    'successful save is not reported as failed if another template cannot load',
    () async {
      final corrupt = await templates.create(
        name: 'Unreadable',
        blocks: [_block],
      );
      await (database.update(
        database.savedTemplates,
      )..where((row) => row.id.equals(corrupt.id))).write(
        const SavedTemplatesCompanion(blocksJson: Value('{malformed')),
      );
      final container = ProviderContainer(
        retry: (_, _) => null,
        overrides: [dayweftDatabaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);
      await expectLater(
        container.read(templateLibraryProvider.future),
        throwsA(isA<PlanningFailure>()),
      );
      final saved = await container
          .read(templateLibraryProvider.notifier)
          .save(name: 'Saved once', blocks: [_block]);
      expect(saved.name, 'Saved once');
      expect(container.read(templateLibraryProvider).hasError, isTrue);
      expect(
        await database.select(database.savedTemplates).get(),
        hasLength(2),
      );
    },
  );

  test(
    'invalid template content is rejected without persisting any row',
    () async {
      await expectLater(
        templates.create(name: '', blocks: [_block]),
        throwsA(isA<PlanningFailure>()),
      );
      await expectLater(
        templates.create(name: 'Empty', blocks: []),
        throwsA(isA<PlanningFailure>()),
      );
      await expectLater(
        templates.create(
          name: 'Invalid',
          blocks: [
            const domain.TemplateBlock(
              title: 'Too much buffer',
              startTime: '09:00',
              endTime: '10:00',
              blockType: 'flexible',
              category: 'work',
              travelBufferMinutes: 90,
            ),
          ],
        ),
        throwsA(isA<PlanningFailure>()),
      );
      expect(await templates.loadAll(), isEmpty);
    },
  );
}
