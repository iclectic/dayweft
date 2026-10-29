import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

const template = DayTemplate(
  id: 'test',
  name: 'Work',
  blocks: [
    TemplateBlock(
      title: 'Work',
      startTime: '09:00',
      endTime: '10:00',
      blockType: 'flexible',
      category: 'work',
    ),
    TemplateBlock(
      title: 'Break',
      startTime: '10:00',
      endTime: '10:20',
      blockType: 'optional',
      category: 'break',
    ),
  ],
);

void main() {
  TemplatePreview preview({
    List<TemplateReservation> existing = const [],
    int endHour = 17,
    DayTemplate value = template,
  }) => reconcileTemplate(
    template: value,
    planId: 'day',
    revision: 2,
    workingWindow: TimeWindow(
      start: DateTime(2026, 10, 27, 9),
      end: DateTime(2026, 10, 27, endHour),
    ),
    existing: existing,
    transition: const Duration(minutes: 10),
  );

  test('reconciles around all existing commitments with transition room', () {
    final meeting = TimeWindow(
      start: DateTime(2026, 10, 27, 9),
      end: DateTime(2026, 10, 27, 10),
    );
    final result = preview(existing: [TemplateReservation(window: meeting)]);
    expect(
      result.placements.first.window.start,
      DateTime(2026, 10, 27, 10, 10),
    );
    expect(result.placements.last.window.start, DateTime(2026, 10, 27, 11, 20));
    expect(
      result.placements.any((item) => item.window.overlaps(meeting)),
      isFalse,
    );
    expect(result.baseRevision, 2);
    expect(() => result.placements.clear(), throwsUnsupportedError);
  });

  test('duplicates and insufficient room are explicit omissions', () {
    var result = preview(endHour: 10);
    expect(result.placements, hasLength(1));
    expect(result.omissions.single.reason, contains('working hours'));
    result = preview(
      existing: [
        TemplateReservation(
          sourceId: 'template:test',
          window: TimeWindow(
            start: DateTime(2026, 10, 27, 9),
            end: DateTime(2026, 10, 27, 10),
          ),
        ),
      ],
    );
    expect(result.placements, isEmpty);
    expect(result.omissions, hasLength(2));
  });

  test('overnight working window preserves template duration', () {
    final result = reconcileTemplate(
      template: template,
      planId: 'night',
      revision: 0,
      workingWindow: TimeWindow(
        start: DateTime(2026, 10, 27, 22),
        end: DateTime(2026, 10, 28, 6),
      ),
      existing: [],
    );
    expect(result.placements.first.window.start, DateTime(2026, 10, 27, 22));
    expect(result.placements.first.window.duration, const Duration(hours: 1));
  });

  test(
    'stable block identities survive renaming or removing another block',
    () {
      const block = TemplateBlock(
        id: 'stable',
        title: 'Renamed work',
        startTime: '09:00',
        endTime: '10:00',
        blockType: 'flexible',
        category: 'work',
        preparationBufferMinutes: 10,
      );
      const revised = DayTemplate(
        id: 'custom',
        name: 'New name',
        blocks: [block],
        version: 2,
      );
      final first = preview(value: revised);
      expect(first.placements.single.sourceId, 'template:custom:stable');
      expect(first.placements.single.block.preparationBufferMinutes, 10);
      final duplicate = preview(
        value: revised,
        existing: [
          TemplateReservation(
            sourceId: 'template:custom:stable',
            window: first.placements.single.window,
          ),
        ],
      );
      expect(duplicate.placements, isEmpty);
      expect(duplicate.omissions.single.reason, 'Already applied to this day.');
    },
  );

  test(
    'duplicate identities and buffers larger than the block are invalid',
    () {
      const repeated = TemplateBlock(
        id: 'same',
        title: 'Work',
        startTime: '09:00',
        endTime: '10:00',
        blockType: 'fixed',
        category: 'work',
      );
      expect(
        templateDefinitionIssue(
          const DayTemplate(
            id: 'x',
            name: 'Work',
            blocks: [repeated, repeated],
          ),
        ),
        contains('distinct identity'),
      );
      for (final minutes in [-1, 61]) {
        expect(
          templateDefinitionIssue(
            DayTemplate(
              id: 'x',
              name: 'Work',
              blocks: [
                TemplateBlock(
                  title: 'Work',
                  startTime: '09:00',
                  endTime: '10:00',
                  blockType: 'fixed',
                  category: 'work',
                  transitionBufferMinutes: minutes,
                ),
              ],
            ),
          ),
          contains('fit inside'),
        );
      }
    },
  );

  test(
    'invalid templates reject rather than create zero duration or bad types',
    () {
      for (final block in [
        const TemplateBlock(
          title: 'Bad',
          startTime: '25:00',
          endTime: '10:00',
          blockType: 'fixed',
          category: 'work',
        ),
        const TemplateBlock(
          title: 'Bad',
          startTime: '09:00',
          endTime: '09:00',
          blockType: 'fixed',
          category: 'work',
        ),
        const TemplateBlock(
          title: 'Bad',
          startTime: '09:00',
          endTime: '10:00',
          blockType: 'unknown',
          category: 'work',
        ),
      ]) {
        expect(
          () => preview(
            value: DayTemplate(id: 'bad', name: 'Bad', blocks: [block]),
          ),
          throwsArgumentError,
        );
      }
      expect(
        () => preview(
          value: const DayTemplate(id: '', name: 'Bad', blocks: []),
        ),
        throwsArgumentError,
      );
    },
  );
}
