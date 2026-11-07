import 'dart:io';

import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart'
    hide TemplateRecurrence;
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/templates/data/custom_template_repository.dart';
import 'package:dayweft_mobile/features/templates/data/template_recurrence_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

const block = TemplateBlock(
  title: 'Work',
  startTime: '09:00',
  endTime: '10:00',
  blockType: 'flexible',
  category: 'work',
);

void main() {
  test(
    'rules and exceptions survive a file reopen and removal is versioned',
    () async {
      final directory = await Directory.systemTemp.createTemp('recurrence-');
      addTearDown(() => directory.delete(recursive: true));
      final file = File('${directory.path}/data.sqlite');
      var database = DayweftDatabase.forTesting(NativeDatabase(file));
      final template = await CustomTemplateRepository(
        database,
      ).create(name: 'Work', blocks: [block]);
      var repository = TemplateRecurrenceRepository(database);
      final rule = TemplateRecurrence(
        weekdays: {1, 5},
        startsOn: DateTime(2026, 10, 26),
        endsOn: DateTime(2026, 12, 31),
        exceptions: [DateTime(2026, 10, 30)],
      );
      final saved = await repository.save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: null,
        rule: rule,
      );
      expect(saved.version, 1);
      await database.close();
      database = DayweftDatabase.forTesting(NativeDatabase(file));
      addTearDown(() => database.close());
      repository = TemplateRecurrenceRepository(database);
      final reopened = (await repository.get(template.id))!;
      expect(reopened.rule!.occursOn(DateTime(2026, 10, 26)), isTrue);
      expect(reopened.rule!.occursOn(DateTime(2026, 10, 30)), isFalse);
      expect(reopened.rule!.occursOn(DateTime(2027, 1, 1)), isFalse);
      final removed = await repository.save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: reopened.version,
        rule: null,
      );
      expect(removed.version, 2);
      expect((await repository.get(template.id))!.rule, isNull);
      await expectLater(
        repository.save(
          templateId: template.id,
          expectedTemplateVersion: 1,
          expectedVersion: 1,
          rule: rule,
        ),
        throwsA(isA<PlanningFailure>()),
      );
      final restored = await repository.save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: 2,
        rule: rule,
      );
      expect(restored.version, 3);
    },
  );

  test(
    'stale or deleted templates and concurrent editors cannot write',
    () async {
      final database = DayweftDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      final templates = CustomTemplateRepository(database);
      final template = await templates.create(name: 'Work', blocks: [block]);
      final repository = TemplateRecurrenceRepository(database);
      final rule = TemplateRecurrence(weekdays: {1}, startsOn: DateTime(2026));
      await repository.save(
        templateId: template.id,
        expectedTemplateVersion: 1,
        expectedVersion: null,
        rule: rule,
      );
      await expectLater(
        repository.save(
          templateId: template.id,
          expectedTemplateVersion: 1,
          expectedVersion: null,
          rule: rule,
        ),
        throwsA(isA<PlanningFailure>()),
      );
      await templates.update(
        id: template.id,
        expectedVersion: 1,
        name: 'Edited',
        blocks: template.blocks,
      );
      await expectLater(
        repository.save(
          templateId: template.id,
          expectedTemplateVersion: 1,
          expectedVersion: 1,
          rule: rule,
        ),
        throwsA(isA<PlanningFailure>()),
      );
      await templates.delete(template.id, expectedVersion: 2);
      await expectLater(
        repository.save(
          templateId: template.id,
          expectedTemplateVersion: 2,
          expectedVersion: 1,
          rule: rule,
        ),
        throwsA(isA<PlanningFailure>()),
      );
      expect((await repository.get(template.id))!.version, 1);
    },
  );

  test('malformed stored dates fail safely without replacing the rule', () async {
    final database = DayweftDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final template = await CustomTemplateRepository(
      database,
    ).create(name: 'Work', blocks: [block]);
    final repository = TemplateRecurrenceRepository(database);
    await repository.save(
      templateId: template.id,
      expectedTemplateVersion: 1,
      expectedVersion: null,
      rule: TemplateRecurrence(weekdays: {1}, startsOn: DateTime(2026)),
    );
    await (database.update(
      database.templateRecurrences,
    )..where((r) => r.templateId.equals(template.id))).write(
      const TemplateRecurrencesCompanion(
        ruleJson: Value(
          '{"formatVersion":1,"weekdays":[1],"startsOn":"2026-02-30","endsOn":null,"exceptions":[]}',
        ),
      ),
    );
    await expectLater(
      repository.get(template.id),
      throwsA(isA<PlanningFailure>()),
    );
    expect(
      (await database.select(database.savedTemplates).getSingle()).name,
      'Work',
    );
  });
}
