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
          (alternative) => identical(alternative.preview, plan),
        ),
        isTrue,
      );
    },
  );
}
