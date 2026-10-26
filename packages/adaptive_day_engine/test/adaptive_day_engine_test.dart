import 'dart:math';

import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

void main() {
  test('Reality Check detects overlaps and high utilisation', () {
    final day = DateTime(2026, 7, 26);
    final plan = DayPlan(
      id: 'plan',
      day: day,
      timeZone: 'Europe/London',
      workingWindow: TimeWindow(
        start: DateTime(2026, 7, 26, 9),
        end: DateTime(2026, 7, 26, 12),
      ),
      blocks: <TimeBlock>[
        TimeBlock(
          id: 'a',
          title: 'Fixed meeting',
          window: TimeWindow(
            start: DateTime(2026, 7, 26, 9),
            end: DateTime(2026, 7, 26, 11),
          ),
          type: BlockType.fixed,
        ),
        TimeBlock(
          id: 'b',
          title: 'Flexible work',
          window: TimeWindow(
            start: DateTime(2026, 7, 26, 10, 30),
            end: DateTime(2026, 7, 26, 12),
          ),
          type: BlockType.flexible,
        ),
      ],
    );

    final observations = const DayweftAdaptiveEngine().realityCheck(plan);

    expect(
      observations.map((observation) => observation.type),
      containsAll(<RealityIssueType>[
        RealityIssueType.overlap,
        RealityIssueType.excessiveUtilisation,
      ]),
    );
  });

  test(
    'Reweave returns the three named alternatives without applying changes',
    () {
      final day = DateTime(2026, 7, 26);
      final plan = DayPlan(
        id: 'plan',
        day: day,
        timeZone: 'Europe/London',
        workingWindow: TimeWindow(
          start: DateTime(2026, 7, 26, 9),
          end: DateTime(2026, 7, 26, 17),
        ),
      );

      final result = const DayweftAdaptiveEngine().reweave(
        plan: plan,
        disruption: Disruption(
          id: 'disruption',
          type: DisruptionType.runningLate,
          reportedAt: DateTime(2026, 7, 26, 10),
        ),
      );

      expect(result.alternatives, hasLength(3));
      expect(
        result.alternatives.map((alternative) => alternative.strategy.label),
        <String>['Protect Essentials', 'Balanced Reweave', 'Reduce Pressure'],
      );
      expect(
        result.alternatives.every(
          (alternative) =>
              alternative.protectedIds.isEmpty &&
              alternative.preview.blocks.isEmpty,
        ),
        isTrue,
      );
    },
  );

  test('Reality Check reports missing breaks and dependency order issues', () {
    final day = DateTime(2026, 7, 26);
    final plan = DayPlan(
      id: 'plan',
      day: day,
      timeZone: 'Europe/London',
      workingWindow: TimeWindow(
        start: DateTime(2026, 7, 26, 9),
        end: DateTime(2026, 7, 26, 17),
      ),
      tasks: <DayweftTask>[
        const DayweftTask(
          id: 'prepare',
          title: 'Prepare',
          estimatedDuration: Duration(minutes: 60),
          status: TaskStatus.planned,
        ),
        const DayweftTask(
          id: 'present',
          title: 'Present',
          estimatedDuration: Duration(minutes: 60),
          dependencyIds: <String>['prepare'],
          status: TaskStatus.planned,
        ),
      ],
      blocks: <TimeBlock>[
        TimeBlock(
          id: 'present-block',
          title: 'Presentation',
          window: TimeWindow(
            start: DateTime(2026, 7, 26, 9),
            end: DateTime(2026, 7, 26, 12),
          ),
          type: BlockType.fixed,
          taskIds: const <String>['present'],
        ),
        TimeBlock(
          id: 'prepare-block',
          title: 'Preparation',
          window: TimeWindow(
            start: DateTime(2026, 7, 26, 13),
            end: DateTime(2026, 7, 26, 16),
          ),
          type: BlockType.flexible,
          taskIds: const <String>['prepare'],
        ),
      ],
    );

    final observations = const DayweftAdaptiveEngine().realityCheck(plan);

    expect(
      observations.map((observation) => observation.type),
      containsAll(<RealityIssueType>[
        RealityIssueType.missingBreak,
        RealityIssueType.impossibleDeadline,
      ]),
    );
  });

  test('Reduce Pressure previews lower-priority work as deferred', () {
    final day = DateTime(2026, 7, 26);
    final plan = DayPlan(
      id: 'plan',
      day: day,
      timeZone: 'Europe/London',
      workingWindow: TimeWindow(
        start: DateTime(2026, 7, 26, 9),
        end: DateTime(2026, 7, 26, 17),
      ),
      tasks: <DayweftTask>[
        const DayweftTask(
          id: 'essential',
          title: 'Essential',
          estimatedDuration: Duration(minutes: 60),
          priority: TaskPriority.essential,
          status: TaskStatus.planned,
        ),
        const DayweftTask(
          id: 'optional',
          title: 'Optional',
          estimatedDuration: Duration(minutes: 45),
          priority: TaskPriority.low,
          status: TaskStatus.planned,
        ),
      ],
      blocks: <TimeBlock>[
        TimeBlock(
          id: 'fixed',
          title: 'Fixed meeting',
          window: TimeWindow(
            start: DateTime(2026, 7, 26, 9),
            end: DateTime(2026, 7, 26, 10),
          ),
          type: BlockType.fixed,
          taskIds: const <String>['essential'],
        ),
        TimeBlock(
          id: 'flexible',
          title: 'Flexible work',
          window: TimeWindow(
            start: DateTime(2026, 7, 26, 10, 30),
            end: DateTime(2026, 7, 26, 11, 30),
          ),
          type: BlockType.flexible,
          taskIds: const <String>['optional'],
        ),
      ],
    );

    final result = const DayweftAdaptiveEngine().reweave(
      plan: plan,
      disruption: Disruption(
        id: 'disruption',
        type: DisruptionType.needBreak,
        reportedAt: DateTime(2026, 7, 26, 11),
      ),
    );
    final reducePressure = result.alternatives.firstWhere(
      (alternative) => alternative.strategy == ReweaveStrategy.reducePressure,
    );

    expect(reducePressure.protectedIds, contains('fixed'));
    expect(reducePressure.deferredTaskIds, contains('optional'));
    expect(
      reducePressure.preview.blocks
          .firstWhere((block) => block.id == 'flexible')
          .taskIds,
      isNot(contains('optional')),
    );
    expect(
      reducePressure.preview.tasks
          .firstWhere((task) => task.id == 'optional')
          .status,
      TaskStatus.deferred,
    );
  });

  test(
    'Balanced Reweave moves flexible work after a protected fixed block',
    () {
      final day = DateTime(2026, 7, 26);
      final plan = DayPlan(
        id: 'plan',
        day: day,
        timeZone: 'Europe/London',
        workingWindow: TimeWindow(
          start: DateTime(2026, 7, 26, 9),
          end: DateTime(2026, 7, 26, 17),
        ),
        blocks: <TimeBlock>[
          TimeBlock(
            id: 'fixed',
            title: 'Fixed meeting',
            window: TimeWindow(
              start: DateTime(2026, 7, 26, 9),
              end: DateTime(2026, 7, 26, 10),
            ),
            type: BlockType.fixed,
          ),
          TimeBlock(
            id: 'flexible',
            title: 'Flexible work',
            window: TimeWindow(
              start: DateTime(2026, 7, 26, 9, 30),
              end: DateTime(2026, 7, 26, 10, 30),
            ),
            type: BlockType.flexible,
          ),
        ],
      );

      final result = const DayweftAdaptiveEngine().reweave(
        plan: plan,
        disruption: Disruption(
          id: 'disruption',
          type: DisruptionType.meetingOverran,
          reportedAt: DateTime(2026, 7, 26, 10),
        ),
      );
      final balanced = result.alternatives.firstWhere(
        (alternative) =>
            alternative.strategy == ReweaveStrategy.balancedReweave,
      );
      final fixed = balanced.preview.blocks.firstWhere(
        (block) => block.id == 'fixed',
      );
      final flexible = balanced.preview.blocks.firstWhere(
        (block) => block.id == 'flexible',
      );

      expect(fixed.window.start, DateTime(2026, 7, 26, 9));
      expect(fixed.window.end, DateTime(2026, 7, 26, 10));
      expect(flexible.window.start, DateTime(2026, 7, 26, 10, 10));
      expect(
        balanced.changes.map((change) => change.entityId),
        contains('flexible'),
      );
    },
  );

  test('split-capable oversized tasks are previewed as split candidates', () {
    final day = DateTime(2026, 7, 26);
    final plan = DayPlan(
      id: 'plan',
      day: day,
      timeZone: 'Europe/London',
      workingWindow: TimeWindow(
        start: DateTime(2026, 7, 26, 9),
        end: DateTime(2026, 7, 26, 17),
      ),
      tasks: const <DayweftTask>[
        DayweftTask(
          id: 'large',
          title: 'Large task',
          estimatedDuration: Duration(minutes: 120),
          canSplit: true,
          minimumUsefulDuration: Duration(minutes: 30),
          status: TaskStatus.planned,
        ),
      ],
      blocks: <TimeBlock>[
        TimeBlock(
          id: 'window',
          title: 'Available window',
          window: TimeWindow(
            start: DateTime(2026, 7, 26, 10),
            end: DateTime(2026, 7, 26, 11),
          ),
          type: BlockType.flexible,
          taskIds: const <String>['large'],
        ),
      ],
    );

    final result = const DayweftAdaptiveEngine().reweave(
      plan: plan,
      disruption: Disruption(
        id: 'disruption',
        type: DisruptionType.taskTookLonger,
        reportedAt: DateTime(2026, 7, 26, 11),
      ),
    );

    expect(
      result.alternatives.every(
        (alternative) => alternative.splitTaskIds.isEmpty,
      ),
      isTrue,
    );
    expect(plan.tasks.single.estimatedDuration, const Duration(minutes: 120));
  });

  test(
    'generated reweave previews keep fixed blocks stable and durations valid',
    () {
      final random = Random(7);
      final engine = const DayweftAdaptiveEngine();
      for (var caseIndex = 0; caseIndex < 25; caseIndex += 1) {
        final day = DateTime(2026, 7, 26);
        final fixedStartHour = 9 + random.nextInt(3);
        final plan = DayPlan(
          id: 'plan-$caseIndex',
          day: day,
          timeZone: 'Europe/London',
          workingWindow: TimeWindow(
            start: DateTime(2026, 7, 26, 8),
            end: DateTime(2026, 7, 26, 18),
          ),
          blocks: <TimeBlock>[
            TimeBlock(
              id: 'fixed-$caseIndex',
              title: 'Fixed',
              window: TimeWindow(
                start: DateTime(2026, 7, 26, fixedStartHour),
                end: DateTime(2026, 7, 26, fixedStartHour + 1),
              ),
              type: BlockType.fixed,
            ),
            for (var index = 0; index < 3; index += 1)
              TimeBlock(
                id: 'flex-$caseIndex-$index',
                title: 'Flex $index',
                window: TimeWindow(
                  start: DateTime(2026, 7, 26, 8 + index, random.nextInt(30)),
                  end: DateTime(2026, 7, 26, 9 + index, random.nextInt(30)),
                ),
                type: BlockType.flexible,
              ),
          ],
        );
        final result = engine.reweave(
          plan: plan,
          disruption: Disruption(
            id: 'disruption-$caseIndex',
            type: DisruptionType.custom,
            reportedAt: DateTime(2026, 7, 26, 12),
          ),
        );

        for (final alternative in result.alternatives) {
          final originalFixed = plan.blocks.firstWhere(
            (block) => block.id == 'fixed-$caseIndex',
          );
          final previewFixed = alternative.preview.blocks.firstWhere(
            (block) => block.id == 'fixed-$caseIndex',
          );
          expect(previewFixed.window.start, originalFixed.window.start);
          expect(previewFixed.window.end, originalFixed.window.end);
          expect(
            alternative.preview.blocks.every(
              (block) => !block.duration.isNegative,
            ),
            isTrue,
          );
        }
      }
    },
  );
}
