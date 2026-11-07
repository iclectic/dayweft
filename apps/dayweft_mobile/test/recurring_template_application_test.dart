import 'dart:io';

import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/application/planning_date.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:dayweft_mobile/features/templates/data/custom_template_repository.dart';
import 'package:dayweft_mobile/features/templates/data/template_recurrence_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'selected occurrence preserves commitments, prevents duplicates and can be undone after reopening',
    () async {
      final directory = await Directory.systemTemp.createTemp('recurring-day-');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/planning.sqlite');
      var db = DayweftDatabase.forTesting(NativeDatabase(file));
      final container = ProviderContainer(
        overrides: [dayweftDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(() => db.close());
      container
          .read(planningDateProvider.notifier)
          .select(DateTime(2026, 10, 26));
      await container.read(planningControllerProvider.future);
      final controller = container.read(planningControllerProvider.notifier);
      await controller.addBlock(
        title: 'Keep meeting',
        startsAt: DateTime(2026, 10, 26, 9),
        endsAt: DateTime(2026, 10, 26, 10),
        blockType: 'fixed',
      );
      final template = await CustomTemplateRepository(db).create(
        name: 'Work',
        blocks: [
          const domain.TemplateBlock(
            title: 'Shift',
            startTime: '09:00',
            endTime: '10:00',
            blockType: 'flexible',
            category: 'work',
          ),
        ],
      );
      await TemplateRecurrenceRepository(db).save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: null,
        rule: domain.TemplateRecurrence(
          weekdays: {DateTime.monday},
          startsOn: DateTime(2026, 10, 1),
        ),
      );
      final preview = await controller.previewRecurringTemplate(template);
      expect(
        (await container.read(planningControllerProvider.future)).blocks,
        hasLength(1),
      );
      await controller.applyRecurringTemplatePreview(preview);
      final applied = container.read(planningControllerProvider).requireValue;
      expect(applied.blocks, hasLength(2));
      expect(
        applied.blocks.last.startsAt.isBefore(applied.blocks.first.endsAt),
        isFalse,
      );
      expect(
        (await controller.previewRecurringTemplate(
          template,
        )).preview.placements,
        isEmpty,
      );
      await expectLater(
        controller.applyRecurringTemplatePreview(preview),
        throwsA(isA<PlanningFailure>()),
      );
      container.dispose();
      await db.close();
      db = DayweftDatabase.forTesting(NativeDatabase(file));
      final reopened = LocalPlanningRepository(
        db,
        planningDate: DateTime(2026, 10, 26),
      );
      expect(await reopened.undoLastRevision(), isTrue);
      final restored = await reopened.loadSelectedDay();
      expect(restored.blocks.single.title, 'Keep meeting');
      expect(
        (await reopened.previewRecurringTemplate(template)).preview.placements,
        hasLength(1),
      );
    },
  );

  test(
    'excluded dates and changed rules or dates reject previews without writes',
    () async {
      final db = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final template = await CustomTemplateRepository(db).create(
        name: 'Work',
        blocks: [
          const domain.TemplateBlock(
            title: 'Work',
            startTime: '09:00',
            endTime: '10:00',
            blockType: 'flexible',
            category: 'work',
          ),
        ],
      );
      final rules = TemplateRecurrenceRepository(db);
      final initial = domain.TemplateRecurrence(
        weekdays: {1, 2},
        startsOn: DateTime(2026, 10, 1),
        exceptions: [DateTime(2026, 10, 27)],
      );
      await rules.save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: null,
        rule: initial,
      );
      final monday = LocalPlanningRepository(
        db,
        planningDate: DateTime(2026, 10, 26),
      );
      final tuesday = LocalPlanningRepository(
        db,
        planningDate: DateTime(2026, 10, 27),
      );
      await expectLater(
        tuesday.previewRecurringTemplate(template),
        throwsA(isA<PlanningFailure>()),
      );
      final preview = await monday.previewRecurringTemplate(template);
      final nextMonday = LocalPlanningRepository(
        db,
        planningDate: DateTime(2026, 11, 2),
      );
      await expectLater(
        nextMonday.applyRecurringTemplatePreview(preview),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await nextMonday.loadSelectedDay()).blocks, isEmpty);
      await expectLater(
        tuesday.applyRecurringTemplatePreview(preview),
        throwsA(isA<PlanningFailure>()),
      );
      await rules.save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: 1,
        rule: domain.TemplateRecurrence(
          weekdays: {1},
          startsOn: DateTime(2026, 10, 1),
        ),
      );
      await expectLater(
        monday.applyRecurringTemplatePreview(preview),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await monday.loadSelectedDay()).blocks, isEmpty);
      expect((await tuesday.loadSelectedDay()).blocks, isEmpty);
    },
  );

  test(
    'overnight occurrence uses the selected civil day and keeps its duration',
    () async {
      final db = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = LocalPlanningRepository(
        db,
        planningDate: DateTime(2026, 10, 26),
      );
      await repository.updatePlanningPreferences(
        const OnboardingPreferences(
          workStartTime: '22:00',
          workEndTime: '06:00',
        ),
      );
      final template = await CustomTemplateRepository(db).create(
        name: 'Night',
        blocks: [
          const domain.TemplateBlock(
            title: 'Night work',
            startTime: '22:00',
            endTime: '01:00',
            blockType: 'flexible',
            category: 'work',
          ),
        ],
      );
      await TemplateRecurrenceRepository(db).save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: null,
        rule: domain.TemplateRecurrence(
          weekdays: {1},
          startsOn: DateTime(2026, 10, 26),
        ),
      );
      final preview = await repository.previewRecurringTemplate(template);
      await repository.applyRecurringTemplatePreview(preview);
      final block = (await repository.loadSelectedDay()).blocks.single;
      expect(block.startsAt, DateTime(2026, 10, 26, 22));
      expect(block.endsAt, DateTime(2026, 10, 27, 1));
    },
  );
}
