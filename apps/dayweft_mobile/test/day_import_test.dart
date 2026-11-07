import 'dart:convert';

import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/data_management/domain/day_import.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DayweftDatabase database;
  late LocalPlanningRepository repository;
  late Map<String, Object?> document;
  setUp(() async {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    repository = LocalPlanningRepository(
      database,
      now: () => DateTime(2026, 10, 27, 8),
    );
    await repository.addBlock(
      title: 'Keep my day',
      startsAt: DateTime(2026, 10, 27, 9),
      endsAt: DateTime(2026, 10, 27, 10),
      blockType: 'fixed',
    );
    await repository.addInboxTask(title: 'Private notes');
    document =
        jsonDecode(await repository.exportLocalData()) as Map<String, Object?>;
  });
  tearDown(() => database.close());

  test('schema and malformed rows reject before any data changes', () async {
    for (final invalid in [
      {...document, 'product': 'Other'},
      {...document, 'schemaVersion': 100},
      {
        ...document,
        'blocks': [null],
      },
      {
        ...document,
        'tasks': ['not a task'],
      },
      {...document, 'tasks': null},
      {
        ...document,
        'plan': {'day': '2026-02-30T00:00:00'},
      },
    ]) {
      await expectLater(
        repository.importLocalData(jsonEncode(invalid)),
        throwsA(isA<PlanningFailure>()),
      );
    }
    expect((await repository.loadToday()).blocks, hasLength(1));
    expect((await repository.loadToday()).inboxTasks, hasLength(1));
    expect(() => DayImport.parse('['), throwsFormatException);
  });

  test(
    'reject duplicate identities, missing blocks and invalid task fields',
    () {
      final block =
          (document['blocks']! as List<Object?>).single!
              as Map<String, Object?>;
      final task =
          (document['tasks']! as List<Object?>).single! as Map<String, Object?>;
      final cases = [
        {
          ...document,
          'blocks': [block, block],
        },
        {
          ...document,
          'tasks': [task, task],
        },
        {
          ...document,
          'tasks': [
            {...task, 'blockId': 'missing'},
          ],
        },
        {
          ...document,
          'tasks': [
            {...task, 'priority': 'invented'},
          ],
        },
        {
          ...document,
          'tasks': [
            {...task, 'estimatedMinutes': -1},
          ],
        },
        {
          ...document,
          'tasks': [
            {...task, 'canSplit': 'yes'},
          ],
        },
        {
          ...document,
          'tasks': [
            {...task, 'requestedStartTime': '25:00'},
          ],
        },
        {
          ...document,
          'tasks': [
            {
              ...task,
              'dependencyIds': ['missing'],
            },
          ],
        },
      ];
      for (final value in cases) {
        expect(() => DayImport.parse(jsonEncode(value)), throwsFormatException);
      }
    },
  );

  test(
    'preview is non-mutating; repeat import is idempotent across restart and undo permits retry',
    () async {
      final raw = jsonEncode(document);
      final preview = repository.previewLocalImport(raw);
      expect(preview.blocks, hasLength(1));
      expect((await repository.loadToday()).blocks, hasLength(1));
      await repository.importLocalData(raw);
      final reopened = LocalPlanningRepository(
        database,
        now: () => DateTime(2026, 10, 27),
      );
      final changedTimestamp = jsonEncode({
        ...document,
        'exportedAt': '2026-10-28T00:00:00Z',
      });
      await expectLater(
        reopened.importLocalData(changedTimestamp),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.loadToday()).blocks, hasLength(2));
      await reopened.undoLastRevision();
      expect((await repository.loadToday()).blocks, hasLength(1));
      await reopened.importLocalData(raw);
      expect((await repository.loadToday()).blocks, hasLength(2));
    },
  );

  test(
    'imports original plan date instead of attaching old times to today',
    () async {
      final target = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(target.close);
      final importer = LocalPlanningRepository(
        target,
        now: () => DateTime(2026, 10, 28),
      );
      await importer.importLocalData(jsonEncode(document));
      expect((await importer.loadToday()).blocks, isEmpty);
      expect(
        (await importer.loadDay(DateTime(2026, 10, 27))).blocks.single.title,
        'Keep my day',
      );
    },
  );
}
