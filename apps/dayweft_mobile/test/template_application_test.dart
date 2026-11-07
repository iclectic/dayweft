import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DayweftDatabase database;
  late LocalPlanningRepository repository;
  setUp(() {
    database = DayweftDatabase.forTesting(NativeDatabase.memory());
    repository = LocalPlanningRepository(
      database,
      now: () => DateTime(2026, 10, 27, 8),
    );
  });
  tearDown(() => database.close());

  test(
    'selected preview adds no overlaps or duplicates and survives undo/reopen',
    () async {
      await repository.addBlock(
        title: 'Keep appointment',
        startsAt: DateTime(2026, 10, 27, 9),
        endsAt: DateTime(2026, 10, 27, 10),
        blockType: 'fixed',
      );
      final original = (await repository.loadToday()).blocks.single;
      final preview = await repository.previewTemplate(dayweftTemplates.first);
      expect((await repository.loadToday()).blocks, hasLength(1));
      final index = preview.placements.first.index;
      await repository.applyTemplatePreview(preview, selectedIndices: {index});
      var current = await repository.loadToday();
      expect(current.blocks, hasLength(2));
      expect(current.blocks.first.id, original.id);
      final added = current.blocks.last;
      expect(added.startsAt.isBefore(original.endsAt), isFalse);
      final repeated = await repository.previewTemplate(dayweftTemplates.first);
      expect(repeated.placements.any((item) => item.index == index), isFalse);
      await expectLater(
        repository.applyTemplatePreview(preview),
        throwsA(isA<PlanningFailure>()),
      );
      final reopened = LocalPlanningRepository(
        database,
        now: () => DateTime(2026, 10, 27),
      );
      await reopened.undoLastRevision();
      current = await reopened.loadToday();
      expect(current.blocks.single.id, original.id);
      expect(
        (await reopened.previewTemplate(
          dayweftTemplates.first,
        )).placements.any((item) => item.index == index),
        isTrue,
      );
    },
  );

  test(
    'changed preferences invalidate preview without changing commitments',
    () async {
      final preview = await repository.previewTemplate(dayweftTemplates.first);
      await repository.updatePlanningBuffers(
        preferredBreakMinutes: 20,
        contingencyMinutes: 30,
        transitionMinutes: 45,
      );
      await expectLater(
        repository.applyTemplatePreview(preview),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.loadToday()).blocks, isEmpty);
    },
  );

  test('empty or forged selection cannot insert anything', () async {
    final preview = await repository.previewTemplate(dayweftTemplates.first);
    for (final selection in [
      <int>{},
      {999},
    ]) {
      await expectLater(
        repository.applyTemplatePreview(preview, selectedIndices: selection),
        throwsA(isA<PlanningFailure>()),
      );
    }
    expect((await repository.loadToday()).blocks, isEmpty);
    expect(dayweftTemplates.length, greaterThanOrEqualTo(5));
  });
}
