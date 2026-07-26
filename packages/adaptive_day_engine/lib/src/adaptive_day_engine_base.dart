import 'package:dayweft_domain/dayweft_domain.dart';

enum RealityIssueType {
  overlap,
  excessiveUtilisation,
  insufficientTransition,
  missingBreak,
  impossibleDeadline,
  demandingTaskCluster,
  insufficientTravel,
  oversizedTask,
  inadequateContingency,
}

class RealityObservation {
  const RealityObservation({
    required this.type,
    required this.message,
    required this.affectedIds,
  });

  final RealityIssueType type;
  final String message;
  final List<String> affectedIds;
}

class ReweaveAlternative {
  const ReweaveAlternative({
    required this.strategy,
    required this.preview,
    required this.changes,
    required this.protectedIds,
    required this.deferredTaskIds,
    required this.tradeOffs,
    required this.confidence,
  });

  final ReweaveStrategy strategy;
  final DayPlan preview;
  final List<ScheduleChange> changes;
  final List<String> protectedIds;
  final List<String> deferredTaskIds;
  final List<String> tradeOffs;
  final double confidence;
}

class ReweaveResult {
  const ReweaveResult({
    required this.observations,
    required this.alternatives,
    required this.isFeasible,
  });

  final List<RealityObservation> observations;
  final List<ReweaveAlternative> alternatives;
  final bool isFeasible;
}

class DayweftAdaptiveEngine {
  const DayweftAdaptiveEngine({
    this.targetUtilisation = 0.8,
    this.minimumTransition = const Duration(minutes: 10),
  });

  final double targetUtilisation;
  final Duration minimumTransition;

  List<RealityObservation> realityCheck(DayPlan plan) {
    final sortedBlocks = [...plan.blocks]
      ..sort((a, b) => a.window.start.compareTo(b.window.start));
    final observations = <RealityObservation>[];

    for (var index = 0; index < sortedBlocks.length; index += 1) {
      final block = sortedBlocks[index];
      if (block.duration.isNegative || block.duration == Duration.zero) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.oversizedTask,
            message: '${block.title} has no useful scheduled duration.',
            affectedIds: <String>[block.id],
          ),
        );
      }

      if (index == 0) {
        continue;
      }

      final previous = sortedBlocks[index - 1];
      if (previous.window.overlaps(block.window)) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.overlap,
            message: '${previous.title} overlaps ${block.title}.',
            affectedIds: <String>[previous.id, block.id],
          ),
        );
      }

      final gap = block.window.start.difference(previous.window.end);
      if (!gap.isNegative && gap < minimumTransition) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.insufficientTransition,
            message:
                '${block.title} starts with only ${gap.inMinutes} minutes '
                'after ${previous.title}.',
            affectedIds: <String>[previous.id, block.id],
          ),
        );
      }
    }

    final planned = sortedBlocks.fold<Duration>(
      Duration.zero,
      (total, block) => total + block.duration + block.reservedBufferDuration,
    );
    final available = plan.workingWindow.duration;
    if (available > Duration.zero) {
      final utilisation = planned.inMinutes / available.inMinutes;
      if (utilisation > targetUtilisation) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.excessiveUtilisation,
            message:
                'The plan uses ${(utilisation * 100).round()}% of the '
                'available day before interruptions.',
            affectedIds: sortedBlocks.map((block) => block.id).toList(),
          ),
        );
      }
    }

    observations.addAll(_deadlineObservations(plan));
    observations.addAll(_oversizedTaskObservations(plan));

    return observations;
  }

  ReweaveResult reweave({
    required DayPlan plan,
    required Disruption disruption,
  }) {
    final observations = realityCheck(plan);
    final fixedIds = plan.blocks
        .where((block) => block.type == BlockType.fixed)
        .map((block) => block.id)
        .toList();

    final alternatives = ReweaveStrategy.values.map((strategy) {
      final deferred = strategy == ReweaveStrategy.reducePressure
          ? plan.tasks
                .where((task) => task.priority == TaskPriority.low)
                .map((task) => task.id)
                .toList()
          : <String>[];

      return ReweaveAlternative(
        strategy: strategy,
        preview: plan,
        changes: <ScheduleChange>[
          ScheduleChange(
            entityId: plan.id,
            summary: 'Preview generated for ${strategy.label}.',
            reason: _reasonFor(strategy, disruption),
          ),
        ],
        protectedIds: fixedIds,
        deferredTaskIds: deferred,
        tradeOffs: _tradeOffsFor(strategy),
        confidence: _confidenceFor(observations),
      );
    }).toList();

    return ReweaveResult(
      observations: observations,
      alternatives: alternatives,
      isFeasible: observations.every(
        (observation) => observation.type != RealityIssueType.overlap,
      ),
    );
  }

  List<RealityObservation> _deadlineObservations(DayPlan plan) {
    final tasksById = plan.tasksById;
    final observations = <RealityObservation>[];
    for (final block in plan.blocks) {
      for (final taskId in block.taskIds) {
        final task = tasksById[taskId];
        final deadline = task?.deadline;
        if (task == null || deadline == null) {
          continue;
        }
        if (block.window.end.isAfter(deadline)) {
          observations.add(
            RealityObservation(
              type: RealityIssueType.impossibleDeadline,
              message: '${task.title} is scheduled after its deadline.',
              affectedIds: <String>[task.id, block.id],
            ),
          );
        }
      }
    }
    return observations;
  }

  List<RealityObservation> _oversizedTaskObservations(DayPlan plan) {
    final tasksById = plan.tasksById;
    final observations = <RealityObservation>[];
    for (final block in plan.blocks) {
      final usableDuration = block.duration - block.reservedBufferDuration;
      for (final taskId in block.taskIds) {
        final task = tasksById[taskId];
        if (task == null) {
          continue;
        }
        if (task.planningDuration > usableDuration && !task.canSplit) {
          observations.add(
            RealityObservation(
              type: RealityIssueType.oversizedTask,
              message: '${task.title} is larger than ${block.title}.',
              affectedIds: <String>[task.id, block.id],
            ),
          );
        }
      }
    }
    return observations;
  }

  String _reasonFor(ReweaveStrategy strategy, Disruption disruption) {
    return switch (strategy) {
      ReweaveStrategy.protectEssentials =>
        'Keeps fixed commitments and essential work stable after '
            '${disruption.type.name}.',
      ReweaveStrategy.balancedReweave =>
        'Looks for a low-disruption adjustment after ${disruption.type.name}.',
      ReweaveStrategy.reducePressure =>
        'Creates more slack after ${disruption.type.name} by deferring '
            'optional work first.',
    };
  }

  List<String> _tradeOffsFor(ReweaveStrategy strategy) {
    return switch (strategy) {
      ReweaveStrategy.protectEssentials => <String>[
        'Lower-priority flexible work may move later.',
        'The day may still feel full if fixed commitments dominate.',
      ],
      ReweaveStrategy.balancedReweave => <String>[
        'Preserves more of the original plan.',
        'Leaves less recovery time than Reduce Pressure.',
      ],
      ReweaveStrategy.reducePressure => <String>[
        'Protects more breathing room.',
        'Optional work is more likely to be deferred.',
      ],
    };
  }

  double _confidenceFor(List<RealityObservation> observations) {
    final severeCount = observations
        .where(
          (observation) =>
              observation.type == RealityIssueType.overlap ||
              observation.type == RealityIssueType.impossibleDeadline,
        )
        .length;
    final confidence = 0.9 - (severeCount * 0.2) - (observations.length * 0.03);
    return confidence.clamp(0.3, 0.9);
  }
}
