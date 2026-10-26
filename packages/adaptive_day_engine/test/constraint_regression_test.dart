import 'dart:math';

import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

DateTime at(int hour, [int minute = 0]) =>
    DateTime.utc(2026, 10, 26, hour, minute);
TimeBlock block(
  String id,
  int start,
  int end, {
  BlockType type = BlockType.flexible,
  List<String> taskIds = const [],
  List<DayweftBuffer> buffers = const [],
}) => TimeBlock(
  id: id,
  title: id,
  window: TimeWindow(start: at(start), end: at(end)),
  type: type,
  taskIds: taskIds,
  buffers: buffers,
);
DayPlan plan(List<TimeBlock> blocks, {List<DayweftTask> tasks = const []}) =>
    DayPlan(
      id: 'plan',
      day: at(0),
      timeZone: 'Europe/London',
      workingWindow: TimeWindow(start: at(9), end: at(17)),
      blocks: blocks,
      tasks: tasks,
    );
Disruption disruption({int? minutes}) => Disruption(
  id: 'disruption',
  type: DisruptionType.runningLate,
  reportedAt: at(9),
  duration: minutes == null ? null : Duration(minutes: minutes),
);

void main() {
  const engine = DayweftAdaptiveEngine();
  test('nested reservations report every overlapping pair', () {
    final input = plan([
      block('long', 9, 12),
      block('short-a', 9, 10),
      block('short-b', 11, 12),
    ]);
    final overlaps = engine
        .realityCheck(input)
        .where((issue) => issue.type == RealityIssueType.overlap);
    expect(overlaps, hasLength(2));
    expect(overlaps.expand((issue) => issue.affectedIds), contains('short-b'));
  });
  test('sequential task estimates are added before checking capacity', () {
    final input = plan(
      [
        block('work', 9, 10, taskIds: ['a', 'b']),
      ],
      tasks: [
        for (final id in ['a', 'b'])
          DayweftTask(
            id: id,
            title: id,
            estimatedDuration: const Duration(minutes: 40),
            status: TaskStatus.planned,
          ),
      ],
    );
    expect(
      engine
          .realityCheck(input)
          .any((issue) => issue.type == RealityIssueType.oversizedTask),
      isTrue,
    );
  });
  test('flexible work outside working hours is a hard observation', () {
    final issues = engine.realityCheck(plan([block('early', 8, 9)]));
    expect(issues.any((issue) => issue.isHardConstraint), isTrue);
  });
  test(
    'buffer time inside a reservation is not counted twice in utilisation',
    () {
      final input = plan([
        block(
          'reserved',
          9,
          15,
          buffers: [
            const DayweftBuffer(
              id: 'rest',
              type: BufferType.recovery,
              duration: Duration(hours: 1),
            ),
          ],
        ),
      ]);
      expect(
        engine
            .realityCheck(input)
            .any(
              (issue) => issue.type == RealityIssueType.excessiveUtilisation,
            ),
        isFalse,
      );
    },
  );
  test(
    'invalid identities, references, durations and buffers are reported',
    () {
      for (final input in [
        plan([block('same', 9, 10), block('same', 11, 12)]),
        plan([
          block('unknown', 9, 10, taskIds: ['missing']),
        ]),
        plan([block('backwards', 10, 9)]),
        plan([
          block(
            'negative',
            9,
            10,
            buffers: [
              const DayweftBuffer(
                id: 'b',
                type: BufferType.travel,
                duration: Duration(minutes: -1),
              ),
            ],
          ),
        ]),
      ]) {
        expect(
          engine.realityCheck(input).any((issue) => issue.isHardConstraint),
          isTrue,
        );
        expect(
          engine.reweave(plan: input, disruption: disruption()).alternatives,
          isEmpty,
        );
      }
    },
  );
  test(
    'different running-late durations constrain the actual preview times',
    () {
      final input = plan([block('work', 9, 10)]);
      final short = engine.reweave(
        plan: input,
        disruption: disruption(minutes: 10),
      );
      final long = engine.reweave(
        plan: input,
        disruption: disruption(minutes: 60),
      );
      expect(short.alternatives, isNotEmpty);
      expect(long.alternatives, isNotEmpty);
      expect(
        long.alternatives.first.preview.blocks.single.window.start.isAfter(
          short.alternatives.first.preview.blocks.single.window.start,
        ),
        isTrue,
      );
      expect(
        long.alternatives.first.preview.blocks.single.window.start.isBefore(
          at(10),
        ),
        isFalse,
      );
    },
  );
  test('unresolvable fixed overlaps never produce applicable alternatives', () {
    final input = plan([
      block('fixed-a', 9, 11, type: BlockType.fixed),
      block('fixed-b', 10, 12, type: BlockType.fixed),
    ]);
    final result = engine.reweave(plan: input, disruption: disruption());
    expect(result.alternatives, isEmpty);
    expect(result.isFeasible, isFalse);
    expect(input.blocks, hasLength(2));
  });
  test(
    'generated schedules pass independent pair checks and conserve task identity',
    () {
      final random = Random(261026);
      var validatedCount = 0;
      for (var index = 0; index < 100; index++) {
        final tasks = [
          for (var task = 0; task < 3; task++)
            DayweftTask(
              id: 'task-$task',
              title: 'task-$task',
              estimatedDuration: Duration(minutes: 10 + random.nextInt(20)),
              status: TaskStatus.planned,
            ),
        ];
        final input = plan([
          block('fixed', 12, 13, type: BlockType.fixed),
          for (var task = 0; task < 3; task++)
            block('block-$task', 9 + task, 10 + task, taskIds: ['task-$task']),
        ], tasks: tasks);
        final result = engine.reweave(
          plan: input,
          disruption: disruption(minutes: random.nextInt(61)),
        );
        for (final alternative in result.alternatives) {
          validatedCount++;
          final schedule = alternative.preview.blocks;
          for (var a = 0; a < schedule.length; a++) {
            expect(schedule[a].duration, greaterThan(Duration.zero));
            for (var b = a + 1; b < schedule.length; b++) {
              expect(
                schedule[a].window.start.isBefore(schedule[b].window.end) &&
                    schedule[b].window.start.isBefore(schedule[a].window.end),
                isFalse,
              );
            }
          }
          expect(
            alternative.preview.tasks.map((task) => task.id).toSet(),
            tasks.map((task) => task.id).toSet(),
          );
          final fixed = schedule.singleWhere((block) => block.id == 'fixed');
          expect(fixed.window.start, at(12));
          expect(fixed.window.end, at(13));
        }
      }
      expect(validatedCount, greaterThan(0));
    },
  );
}
