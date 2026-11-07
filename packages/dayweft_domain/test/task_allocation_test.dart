import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

DateTime at(int hour, [int minute = 0]) =>
    DateTime.utc(2026, 11, 2, hour, minute);
TaskAllocation part(
  String id,
  String task,
  String block,
  DateTime start,
  DateTime end,
) => TaskAllocation(
  id: id,
  taskId: task,
  blockId: block,
  window: TimeWindow(start: start, end: end),
);

void main() {
  final blocks = [
    TimeBlock(
      id: 'morning',
      title: 'Morning',
      window: TimeWindow(start: at(9), end: at(10)),
      type: BlockType.flexible,
    ),
    TimeBlock(
      id: 'later',
      title: 'Later',
      window: TimeWindow(start: at(11), end: at(12)),
      type: BlockType.flexible,
    ),
  ];
  DayweftTask task({
    bool split = true,
    List<String> dependencies = const [],
    DateTime? earliest,
    DateTime? latest,
  }) => DayweftTask(
    id: 'task',
    title: 'Work',
    estimatedDuration: const Duration(minutes: 60),
    status: TaskStatus.planned,
    canSplit: split,
    minimumUsefulDuration: const Duration(minutes: 20),
    dependencyIds: dependencies,
    earliestStart: earliest,
    latestFinish: latest,
  );
  final fragments = [
    part('a', 'task', 'morning', at(9), at(9, 30)),
    part('b', 'task', 'later', at(11), at(11, 30)),
  ];
  String? issue(
    List<DayweftTask> tasks,
    List<TaskAllocation> values, {
    List<TimeBlock>? windows,
  }) => taskAllocationIssue(
    tasks: tasks,
    blocks: windows ?? blocks,
    allocations: values,
  );

  test('valid split accounts for all work and preserves input collections', () {
    final before = [...fragments];
    expect(issue([task()], fragments), isNull);
    expect(fragments, before);
  });
  test(
    'rejects missing work, forbidden or undersized fragments, and duplicate identities',
    () {
      expect(issue([task()], []), isNotNull);
      expect(issue([task(split: false)], fragments), isNotNull);
      expect(issue([task()], [fragments.first]), isNotNull);
      expect(
        issue(
          [task()],
          [
            part('a', 'task', 'morning', at(9), at(9, 15)),
            part('b', 'task', 'later', at(11), at(11, 45)),
          ],
        ),
        isNotNull,
      );
      expect(
        issue(
          [task()],
          [fragments.first, part('a', 'task', 'later', at(11), at(11, 30))],
        ),
        isNotNull,
      );
      expect(
        issue([task()], [part('a', 'missing', 'morning', at(9), at(10))]),
        isNotNull,
      );
      expect(
        issue([task()], [part('a', 'task', 'missing', at(9), at(10))]),
        isNotNull,
      );
    },
  );
  test(
    'rejects out-of-block, overlapping, constrained and non-minute allocations',
    () {
      expect(
        issue([task()], [part('a', 'task', 'morning', at(8, 30), at(9, 30))]),
        isNotNull,
      );
      expect(issue([task(earliest: at(9, 15))], fragments), isNotNull);
      expect(issue([task(latest: at(11, 15))], fragments), isNotNull);
      expect(
        issue(
          [task()],
          [
            part(
              'a',
              'task',
              'morning',
              at(9),
              at(9).add(const Duration(seconds: 30)),
            ),
          ],
        ),
        isNotNull,
      );
      final overlappingBlocks = [
        blocks.first,
        TimeBlock(
          id: 'later',
          title: 'Overlap',
          window: TimeWindow(start: at(9), end: at(10)),
          type: BlockType.flexible,
        ),
      ];
      expect(
        issue(
          [task()],
          [fragments.first, part('b', 'task', 'later', at(9, 15), at(9, 45))],
          windows: overlappingBlocks,
        ),
        isNotNull,
      );
    },
  );
  test('allocations and reserved buffers cannot exceed block capacity', () {
    final reserved = TimeBlock(
      id: 'morning',
      title: 'Morning',
      window: TimeWindow(start: at(9), end: at(10)),
      type: BlockType.flexible,
      buffers: [
        const DayweftBuffer(
          id: 'break',
          type: BufferType.recovery,
          duration: Duration(minutes: 40),
        ),
      ],
    );
    expect(
      issue([task()], fragments, windows: [reserved, blocks.last]),
      isNotNull,
    );
  });

  test(
    'does not allocate inside reserved time even when total capacity fits',
    () {
      final reserved = TimeBlock(
        id: 'morning',
        title: 'Morning',
        window: TimeWindow(start: at(9), end: at(10)),
        type: BlockType.flexible,
        buffers: [
          const DayweftBuffer(
            id: 'buffer',
            type: BufferType.recovery,
            duration: Duration(minutes: 20),
          ),
        ],
      );
      expect(
        issue(
          [task()],
          [part('a', 'task', 'morning', at(9, 30), at(10)), fragments.last],
          windows: [reserved, blocks.last],
        ),
        isNotNull,
      );
    },
  );

  test('fixed commitments cannot lose or receive unrelated allocated work', () {
    final fixed = TimeBlock(
      id: 'morning',
      title: 'Fixed',
      window: TimeWindow(start: at(9), end: at(10)),
      type: BlockType.fixed,
      taskIds: const ['task'],
    );
    expect(
      issue([task()], fragments, windows: [fixed, blocks.last]),
      isNotNull,
    );
    final unrelated = TimeBlock(
      id: 'morning',
      title: 'Fixed',
      window: TimeWindow(start: at(9), end: at(10)),
      type: BlockType.fixed,
    );
    expect(
      issue([task()], fragments, windows: [unrelated, blocks.last]),
      isNotNull,
    );
    expect(
      issue(
        [task(split: false)],
        [part('a', 'task', 'morning', at(9), at(10))],
        windows: [fixed, blocks.last],
      ),
      isNull,
    );
  });

  test(
    'overlapping plan blocks are rejected even when allocations do not overlap',
    () {
      final overlapping = TimeBlock(
        id: 'later',
        title: 'Overlap',
        window: TimeWindow(start: at(9, 45), end: at(11, 30)),
        type: BlockType.flexible,
      );
      expect(
        issue(
          [task()],
          [fragments.first, part('b', 'task', 'later', at(10), at(10, 30))],
          windows: [blocks.first, overlapping],
        ),
        isNotNull,
      );
    },
  );
  test(
    'predecessors must be completed or fully finish before dependent work',
    () {
      const predecessor = DayweftTask(
        id: 'before',
        title: 'Prepare',
        estimatedDuration: Duration(minutes: 30),
        status: TaskStatus.planned,
      );
      final dependent = task(dependencies: ['before']);
      expect(issue([predecessor, dependent], fragments), isNotNull);
      final late = part('c', 'before', 'morning', at(9, 30), at(10));
      expect(issue([predecessor, dependent], [...fragments, late]), isNotNull);
      final ordered = [
        part('c', 'before', 'morning', at(9), at(9, 30)),
        part('a', 'task', 'morning', at(9, 30), at(10)),
        fragments.last,
      ];
      expect(issue([predecessor, dependent], ordered), isNull);
      const completed = DayweftTask(
        id: 'before',
        title: 'Prepare',
        estimatedDuration: Duration(minutes: 30),
        status: TaskStatus.completed,
      );
      expect(issue([completed, dependent], fragments), isNull);
    },
  );
}
