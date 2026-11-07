import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

DateTime at(int h, [int m = 0]) => DateTime.utc(2026, 11, 2, h, m);
TimeBlock block(
  String id,
  int start,
  int end, {
  List<String> tasks = const [],
  BlockType type = BlockType.flexible,
}) => TimeBlock(
  id: id,
  title: id,
  type: type,
  taskIds: tasks,
  window: TimeWindow(start: at(start), end: at(end)),
);
DayPlan plan(List<TimeBlock> blocks, List<DayweftTask> tasks) => DayPlan(
  id: 'day',
  day: at(0),
  timeZone: 'UTC',
  workingWindow: TimeWindow(start: at(9), end: at(17)),
  blocks: blocks,
  tasks: tasks,
);

void main() {
  test(
    'disruption changes fragment placement and never overlaps protected time',
    () {
      final input = plan(
        [
          block('one', 9, 10, tasks: ['task']),
          block('two', 11, 12),
        ],
        [
          const DayweftTask(
            id: 'task',
            title: 'Work',
            estimatedDuration: Duration(minutes: 90),
            canSplit: true,
            minimumUsefulDuration: Duration(minutes: 20),
            status: TaskStatus.planned,
          ),
        ],
      );
      final busy = TimeWindow(start: at(9), end: at(9, 30));
      final original = proposeTaskAllocations(input)!;
      final adjusted = proposeTaskAllocations(input, unavailable: busy)!;
      expect(original.first.window.start, at(9));
      expect(adjusted.first.window.start, at(9, 30));
      expect(adjusted.every((part) => !part.window.overlaps(busy)), isTrue);
      expect(adjusted.map((part) => part.window.duration), [
        const Duration(minutes: 30),
        const Duration(hours: 1),
      ]);
      expect(input.blocks.first.taskIds, ['task']);
    },
  );
  test('fixed conflict and invalid disruption do not yield a proposal', () {
    final input = plan([block('meeting', 9, 10, type: BlockType.fixed)], []);
    expect(
      proposeTaskAllocations(
        input,
        unavailable: TimeWindow(start: at(9, 30), end: at(10, 30)),
      ),
      isNull,
    );
    expect(
      proposeTaskAllocations(
        input,
        unavailable: TimeWindow(start: at(10), end: at(10)),
      ),
      isNull,
    );
    expect(
      proposeTaskAllocations(
        input,
        unavailable: TimeWindow(start: at(10), end: at(11)),
      ),
      isNotNull,
    );
  });
  test(
    'produces deterministic concrete fragments without mutating the plan',
    () {
      final input = plan(
        [
          block('one', 9, 10, tasks: ['task']),
          block('two', 11, 12),
        ],
        [
          const DayweftTask(
            id: 'task',
            title: 'Work',
            estimatedDuration: Duration(minutes: 90),
            canSplit: true,
            minimumUsefulDuration: Duration(minutes: 20),
            status: TaskStatus.planned,
          ),
        ],
      );
      final first = proposeTaskAllocations(input)!;
      final second = proposeTaskAllocations(input)!;
      expect(first.map((a) => a.id), second.map((a) => a.id));
      expect(first.map((a) => a.window.duration), [
        const Duration(hours: 1),
        const Duration(minutes: 30),
      ]);
      expect(
        taskAllocationIssue(
          tasks: input.tasks,
          blocks: input.blocks,
          allocations: first,
        ),
        isNull,
      );
      expect(input.blocks.first.taskIds, ['task']);
      expect(() => first.clear(), throwsUnsupportedError);
    },
  );
  test('does not split without permission or claim an impossible proposal', () {
    final input = plan(
      [
        block('one', 9, 10, tasks: ['task']),
        block('two', 11, 12),
      ],
      [
        const DayweftTask(
          id: 'task',
          title: 'Work',
          estimatedDuration: Duration(minutes: 90),
          status: TaskStatus.planned,
        ),
      ],
    );
    expect(proposeTaskAllocations(input), isNull);
  });

  test('leaves a useful final fragment instead of a short remainder', () {
    final input = plan(
      [
        block('one', 9, 10, tasks: ['task']),
        block('two', 11, 12),
      ],
      [
        const DayweftTask(
          id: 'task',
          title: 'Work',
          estimatedDuration: Duration(minutes: 75),
          canSplit: true,
          minimumUsefulDuration: Duration(minutes: 20),
          status: TaskStatus.planned,
        ),
      ],
    );
    expect(proposeTaskAllocations(input)!.map((part) => part.window.duration), [
      const Duration(minutes: 55),
      const Duration(minutes: 20),
    ]);
  });
  test('honours dependencies and bounded times', () {
    final input = plan(
      [
        block('one', 9, 10, tasks: ['before']),
        block('two', 11, 12, tasks: ['after']),
      ],
      [
        const DayweftTask(
          id: 'before',
          title: 'Before',
          estimatedDuration: Duration(minutes: 30),
          status: TaskStatus.planned,
        ),
        DayweftTask(
          id: 'after',
          title: 'After',
          estimatedDuration: const Duration(minutes: 30),
          earliestStart: at(11),
          latestFinish: at(12),
          dependencyIds: const ['before'],
          status: TaskStatus.planned,
        ),
      ],
    );
    final result = proposeTaskAllocations(input)!;
    expect(result.first.taskId, 'before');
    expect(result.last.window.start, at(11));
  });
  test(
    'does not move work out of fixed commitments or into unrelated fixed blocks',
    () {
      final input = plan(
        [
          block('fixed', 9, 10, tasks: ['task'], type: BlockType.fixed),
          block('free', 11, 12),
        ],
        [
          const DayweftTask(
            id: 'task',
            title: 'Work',
            estimatedDuration: Duration(minutes: 90),
            canSplit: true,
            minimumUsefulDuration: Duration(minutes: 20),
            status: TaskStatus.planned,
          ),
        ],
      );
      expect(proposeTaskAllocations(input), isNull);
    },
  );
  test(
    'returns no proposal for dependency cycles, overlaps and missing assignments',
    () {
      final cyc = plan(
        [
          block('one', 9, 10, tasks: ['a', 'b']),
        ],
        [
          const DayweftTask(
            id: 'a',
            title: 'A',
            estimatedDuration: Duration(minutes: 20),
            dependencyIds: ['b'],
            status: TaskStatus.planned,
          ),
          const DayweftTask(
            id: 'b',
            title: 'B',
            estimatedDuration: Duration(minutes: 20),
            dependencyIds: ['a'],
            status: TaskStatus.planned,
          ),
        ],
      );
      expect(proposeTaskAllocations(cyc), isNull);
      expect(
        proposeTaskAllocations(
          plan([block('a', 9, 11), block('b', 10, 12)], []),
        ),
        isNull,
      );
      expect(
        proposeTaskAllocations(
          plan(
            [block('a', 9, 10)],
            [
              const DayweftTask(
                id: 'x',
                title: 'X',
                estimatedDuration: Duration(minutes: 20),
                status: TaskStatus.planned,
              ),
            ],
          ),
        ),
        isNull,
      );
    },
  );
}
