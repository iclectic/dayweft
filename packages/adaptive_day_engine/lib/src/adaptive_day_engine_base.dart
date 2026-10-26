import 'package:dayweft_domain/dayweft_domain.dart';

enum RealityIssueType {
  invalidInput,
  outsideWorkingHours,
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

  bool get isHardConstraint => switch (type) {
    RealityIssueType.invalidInput ||
    RealityIssueType.outsideWorkingHours ||
    RealityIssueType.overlap ||
    RealityIssueType.impossibleDeadline ||
    RealityIssueType.oversizedTask => true,
    _ => false,
  };
}

class ReweaveAlternative {
  const ReweaveAlternative({
    required this.strategy,
    required this.preview,
    required this.changes,
    required this.protectedIds,
    required this.deferredTaskIds,
    this.splitTaskIds = const <String>[],
    required this.tradeOffs,
    required this.evidenceSummary,
  });

  final ReweaveStrategy strategy;
  final DayPlan preview;
  final List<ScheduleChange> changes;
  final List<String> protectedIds;
  final List<String> deferredTaskIds;
  final List<String> splitTaskIds;
  final List<String> tradeOffs;
  final String evidenceSummary;
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
    this.preferredBreakDuration = const Duration(minutes: 20),
    this.contingencyDuration = const Duration(minutes: 30),
  });

  final double targetUtilisation;
  final Duration minimumTransition;
  final Duration preferredBreakDuration;
  final Duration contingencyDuration;

  int _compareBlocks(TimeBlock a, TimeBlock b) {
    final order = a.window.start.compareTo(b.window.start);
    return order == 0 ? a.id.compareTo(b.id) : order;
  }

  List<RealityObservation> _inputObservations(DayPlan plan) {
    final issues = <RealityObservation>[];
    void invalid(String message, List<String> ids) => issues.add(
      RealityObservation(
        type: RealityIssueType.invalidInput,
        message: message,
        affectedIds: ids,
      ),
    );
    if (plan.workingWindow.duration <= Duration.zero ||
        targetUtilisation <= 0 ||
        targetUtilisation > 1 ||
        minimumTransition.isNegative ||
        preferredBreakDuration <= Duration.zero ||
        contingencyDuration.isNegative) {
      invalid('Review the working window and planning buffer preferences.', [
        plan.id,
      ]);
    }
    if (plan.blocks.map((block) => block.id).toSet().length !=
            plan.blocks.length ||
        plan.tasks.map((task) => task.id).toSet().length != plan.tasks.length) {
      invalid('Every block and task must have a unique identity.', [plan.id]);
    }
    final tasks = plan.tasksById;
    final assigned = <String>{};
    for (final block in plan.blocks) {
      if (block.duration <= Duration.zero ||
          block.buffers.any((buffer) => buffer.duration.isNegative) ||
          block.reservedBufferDuration > block.duration) {
        invalid(
          'Review the duration and internal buffers for ${block.title}.',
          [block.id],
        );
      }
      for (final id in block.taskIds) {
        if (!tasks.containsKey(id) || !assigned.add(id)) {
          invalid(
            'A task is missing or is assigned more than once without fragment allocations.',
            [block.id, id],
          );
        }
      }
    }
    final graph = {for (final task in plan.tasks) task.id: task.dependencyIds};
    for (final task in plan.tasks) {
      final details = TaskDetails(
        title: task.title,
        estimatedMinutes: task.estimatedDuration.inMinutes,
        canSplit: task.canSplit,
        minimumUsefulMinutes: task.minimumUsefulDuration.inMinutes,
        dependencyIds: task.dependencyIds,
      );
      final issue =
          details.validationMessage ??
          taskDependencyIssue(task.id, task.dependencyIds, graph);
      if (issue != null) invalid(issue, [task.id]);
      if (task.status == TaskStatus.planned && !assigned.contains(task.id)) {
        invalid('${task.title} is marked planned but has no allocation.', [
          task.id,
        ]);
      }
    }
    return issues;
  }

  Duration _occupiedDuration(DayPlan plan) {
    final windows = <TimeWindow>[];
    for (final block in plan.blocks) {
      final start = _latestDateTime(
        block.window.start,
        plan.workingWindow.start,
      );
      final end = block.window.end.isBefore(plan.workingWindow.end)
          ? block.window.end
          : plan.workingWindow.end;
      if (start.isBefore(end)) windows.add(TimeWindow(start: start, end: end));
    }
    windows.sort((a, b) => a.start.compareTo(b.start));
    var total = Duration.zero;
    DateTime? end;
    for (final window in windows) {
      final start = end == null
          ? window.start
          : _latestDateTime(window.start, end);
      if (start.isBefore(window.end)) total += window.end.difference(start);
      if (end == null || window.end.isAfter(end)) end = window.end;
    }
    return total;
  }

  List<RealityObservation> realityCheck(DayPlan plan) {
    final sortedBlocks = [...plan.blocks]..sort(_compareBlocks);
    final observations = _inputObservations(plan);

    for (var index = 0; index < sortedBlocks.length; index += 1) {
      final block = sortedBlocks[index];
      if (block.type != BlockType.fixed &&
          (block.window.start.isBefore(plan.workingWindow.start) ||
              block.window.end.isAfter(plan.workingWindow.end))) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.outsideWorkingHours,
            message: '${block.title} is outside the permitted working window.',
            affectedIds: [block.id],
          ),
        );
      }
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
      for (var earlier = 0; earlier < index; earlier++) {
        final other = sortedBlocks[earlier];
        if (other.window.overlaps(block.window)) {
          observations.add(
            RealityObservation(
              type: RealityIssueType.overlap,
              message: '${other.title} overlaps ${block.title}.',
              affectedIds: [other.id, block.id],
            ),
          );
        }
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

    final planned = _occupiedDuration(plan);
    final available = plan.workingWindow.duration;
    if (available > Duration.zero) {
      final utilisation = planned.inMicroseconds / available.inMicroseconds;
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
    observations.addAll(_dependencyObservations(plan));
    observations.addAll(_breakObservations(plan, planned));
    observations.addAll(_travelObservations(plan));
    observations.addAll(_demandingClusterObservations(plan));
    observations.addAll(_contingencyObservations(plan, planned));

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

    if (observations.any(
          (issue) => issue.type == RealityIssueType.invalidInput,
        ) ||
        (disruption.duration?.isNegative ?? false)) {
      return ReweaveResult(
        observations: [
          ...observations,
          if (disruption.duration?.isNegative ?? false)
            const RealityObservation(
              type: RealityIssueType.invalidInput,
              message: 'Disruption duration must not be negative.',
              affectedIds: [],
            ),
        ],
        alternatives: const [],
        isFeasible: false,
      );
    }
    final unavailable =
        disruption.duration == null || disruption.duration == Duration.zero
        ? null
        : TimeWindow(
            start: disruption.reportedAt,
            end: disruption.reportedAt.add(disruption.duration!),
          );
    final alternatives = ReweaveStrategy.values
        .map((strategy) {
          final deferred = _deferredTasksFor(plan, strategy);
          final split = _splitTaskIdsFor(plan, deferred);
          final deferredPreview = _previewWithDeferredTasks(plan, deferred);
          final preview = _reflowFlexibleBlocks(deferredPreview, unavailable);
          if (preview == null ||
              split.isNotEmpty ||
              !_isFeasible(realityCheck(preview))) {
            return null;
          }
          final changes = <ScheduleChange>[
            ScheduleChange(
              entityId: plan.id,
              summary: 'Preview generated for ${strategy.label}.',
              reason: _reasonFor(strategy, disruption),
            ),
            ...deferred.map((taskId) {
              final task = plan.tasksById[taskId];
              return ScheduleChange(
                entityId: taskId,
                summary: 'Defer ${task?.title ?? 'optional task'}.',
                reason:
                    '${strategy.label} protects fixed commitments by removing '
                    'lower-priority work from today.',
              );
            }),
            ...split.map((taskId) {
              final task = plan.tasksById[taskId];
              return ScheduleChange(
                entityId: taskId,
                summary:
                    'Split ${task?.title ?? 'task'} into useful fragments.',
                reason:
                    'The task is larger than one available window and permits '
                    'splitting without going below its minimum useful duration.',
              );
            }),
            ..._movementChanges(plan, preview),
          ];

          return ReweaveAlternative(
            strategy: strategy,
            preview: preview,
            changes: changes,
            protectedIds: fixedIds,
            deferredTaskIds: deferred,
            splitTaskIds: split,
            tradeOffs: _tradeOffsFor(strategy, deferred.length),
            evidenceSummary: plan.tasks.isEmpty
                ? 'No task-duration evidence is available. Only block reservations were checked.'
                : 'Based on ${plan.tasks.where((task) => task.status == TaskStatus.planned).length} user-entered task estimate(s). This is not a prediction of completion.',
          );
        })
        .whereType<ReweaveAlternative>()
        .toList();

    return ReweaveResult(
      observations: observations,
      alternatives: alternatives,
      isFeasible: alternatives.isNotEmpty,
    );
  }

  List<RealityObservation> _deadlineObservations(DayPlan plan) {
    final tasksById = plan.tasksById;
    final observations = <RealityObservation>[];
    for (final block in plan.blocks) {
      for (final taskId in block.taskIds) {
        final task = tasksById[taskId];
        final deadline = task?.deadline;
        if (task == null ||
            deadline == null ||
            task.status == TaskStatus.completed ||
            task.status == TaskStatus.deferred) {
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
      final remaining = block.taskIds
          .map((id) => tasksById[id])
          .whereType<DayweftTask>()
          .where((task) => task.status == TaskStatus.planned)
          .toList();
      final demand = remaining.fold(
        Duration.zero,
        (total, task) => total + task.planningDuration,
      );
      if (remaining.length > 1 && demand > usableDuration) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.oversizedTask,
            message:
                '${block.title} has ${demand.inMinutes} minutes of work but only ${usableDuration.inMinutes} usable minutes.',
            affectedIds: [block.id, ...remaining.map((task) => task.id)],
          ),
        );
      }
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
        if (task.canSplit &&
            usableDuration < task.minimumUsefulDuration &&
            task.planningDuration > usableDuration) {
          observations.add(
            RealityObservation(
              type: RealityIssueType.oversizedTask,
              message:
                  '${task.title} can split, but ${block.title} is below its '
                  'minimum useful duration.',
              affectedIds: <String>[task.id, block.id],
            ),
          );
        }
      }
    }
    return observations;
  }

  List<RealityObservation> _dependencyObservations(DayPlan plan) {
    final tasksById = plan.tasksById;
    final blockByTaskId = <String, TimeBlock>{};
    for (final block in plan.blocks) {
      for (final taskId in block.taskIds) {
        blockByTaskId[taskId] = block;
      }
    }

    final observations = <RealityObservation>[];
    for (final task in plan.tasks) {
      final taskBlock = blockByTaskId[task.id];
      if (taskBlock == null) {
        continue;
      }
      for (final dependencyId in task.dependencyIds) {
        final dependency = tasksById[dependencyId];
        final dependencyBlock = blockByTaskId[dependencyId];
        if (dependency?.status == TaskStatus.completed) {
          continue;
        }
        if (dependency == null || dependencyBlock == null) {
          observations.add(
            RealityObservation(
              type: RealityIssueType.impossibleDeadline,
              message:
                  '${task.title} depends on work that is not scheduled today.',
              affectedIds: <String>[task.id, dependencyId],
            ),
          );
          continue;
        }
        if (dependencyBlock.window.end.isAfter(taskBlock.window.start)) {
          observations.add(
            RealityObservation(
              type: RealityIssueType.impossibleDeadline,
              message:
                  '${task.title} is scheduled before its dependency '
                  '${dependency.title} can finish.',
              affectedIds: <String>[task.id, dependency.id],
            ),
          );
        }
      }
    }
    return observations;
  }

  List<RealityObservation> _breakObservations(DayPlan plan, Duration planned) {
    if (planned < const Duration(hours: 4)) {
      return const <RealityObservation>[];
    }
    final hasRecoveryBlock = plan.blocks.any((block) {
      final category = block.category?.toLowerCase();
      return block.type == BlockType.fixed &&
          (category == 'rest' ||
              category == 'recovery' ||
              category == 'break') &&
          block.duration >= preferredBreakDuration;
    });
    if (hasRecoveryBlock) {
      return const <RealityObservation>[];
    }
    return <RealityObservation>[
      RealityObservation(
        type: RealityIssueType.missingBreak,
        message:
            'The plan has more than 4 hours scheduled without a clear break.',
        affectedIds: plan.blocks.map((block) => block.id).toList(),
      ),
    ];
  }

  List<RealityObservation> _travelObservations(DayPlan plan) {
    final observations = <RealityObservation>[];
    for (final block in plan.blocks) {
      final hasTravelBuffer = block.buffers.any(
        (buffer) => buffer.type == BufferType.travel,
      );
      final looksImportedCalendar =
          block.sourceId?.startsWith('calendar:') ?? false;
      if (looksImportedCalendar && !hasTravelBuffer) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.insufficientTravel,
            message:
                '${block.title} is calendar-sourced and has no travel buffer.',
            affectedIds: <String>[block.id],
          ),
        );
      }
    }
    return observations;
  }

  List<RealityObservation> _demandingClusterObservations(DayPlan plan) {
    final tasksById = plan.tasksById;
    final sortedBlocks = [...plan.blocks]
      ..sort((a, b) => a.window.start.compareTo(b.window.start));
    final observations = <RealityObservation>[];
    for (var index = 1; index < sortedBlocks.length; index += 1) {
      final previous = sortedBlocks[index - 1];
      final current = sortedBlocks[index];
      final previousDemanding = previous.taskIds.any(
        (id) => tasksById[id]?.cognitiveLoad == CognitiveLoad.demanding,
      );
      final currentDemanding = current.taskIds.any(
        (id) => tasksById[id]?.cognitiveLoad == CognitiveLoad.demanding,
      );
      final gap = current.window.start.difference(previous.window.end);
      if (previousDemanding &&
          currentDemanding &&
          !gap.isNegative &&
          gap < const Duration(minutes: 30)) {
        observations.add(
          RealityObservation(
            type: RealityIssueType.demandingTaskCluster,
            message:
                '${previous.title} and ${current.title} place demanding work '
                'too close together.',
            affectedIds: <String>[previous.id, current.id],
          ),
        );
      }
    }
    return observations;
  }

  List<RealityObservation> _contingencyObservations(
    DayPlan plan,
    Duration planned,
  ) {
    final available = plan.workingWindow.duration;
    if (available <= Duration.zero) {
      return const <RealityObservation>[];
    }
    final slack = available - planned;
    if (slack >= contingencyDuration) {
      return const <RealityObservation>[];
    }
    return <RealityObservation>[
      RealityObservation(
        type: RealityIssueType.inadequateContingency,
        message:
            'The plan leaves only ${slack.inMinutes.clamp(0, 1440)} minutes '
            'of contingency time.',
        affectedIds: plan.blocks.map((block) => block.id).toList(),
      ),
    ];
  }

  bool _isFeasible(List<RealityObservation> observations) {
    return !observations.any((observation) => observation.isHardConstraint);
  }

  List<String> _deferredTasksFor(DayPlan plan, ReweaveStrategy strategy) {
    final candidates =
        plan.tasks.where((task) {
          return task.status == TaskStatus.planned &&
              task.deadline == null &&
              !plan.blocks.any(
                (block) =>
                    block.type == BlockType.fixed &&
                    block.taskIds.contains(task.id),
              ) &&
              !plan.tasks.any(
                (other) =>
                    other.status == TaskStatus.planned &&
                    other.dependencyIds.contains(task.id),
              ) &&
              (task.priority == TaskPriority.low ||
                  task.priority == TaskPriority.medium);
        }).toList()..sort((a, b) {
          final priorityComparison = a.priority.index.compareTo(
            b.priority.index,
          );
          if (priorityComparison != 0) {
            return priorityComparison;
          }
          final durationOrder = b.planningDuration.compareTo(
            a.planningDuration,
          );
          return durationOrder == 0 ? a.id.compareTo(b.id) : durationOrder;
        });

    final limit = switch (strategy) {
      ReweaveStrategy.protectEssentials => 0,
      ReweaveStrategy.balancedReweave => 1,
      ReweaveStrategy.reducePressure => 3,
    };
    return candidates.take(limit).map((task) => task.id).toList();
  }

  List<String> _splitTaskIdsFor(DayPlan plan, List<String> deferredIds) {
    final deferred = deferredIds.toSet();
    final tasksById = plan.tasksById;
    final splitTaskIds = <String>[];
    for (final block in plan.blocks) {
      final usableDuration = block.duration - block.reservedBufferDuration;
      for (final taskId in block.taskIds) {
        if (deferred.contains(taskId)) {
          continue;
        }
        final task = tasksById[taskId];
        if (task == null || !task.canSplit) {
          continue;
        }
        if (task.planningDuration > usableDuration &&
            usableDuration >= task.minimumUsefulDuration) {
          splitTaskIds.add(task.id);
        }
      }
    }
    return splitTaskIds;
  }

  List<ScheduleChange> _movementChanges(DayPlan original, DayPlan preview) {
    final originalById = <String, TimeBlock>{
      for (final block in original.blocks) block.id: block,
    };
    final changes = <ScheduleChange>[];
    for (final block in preview.blocks) {
      final originalBlock = originalById[block.id];
      if (originalBlock == null) {
        continue;
      }
      if (originalBlock.window.start != block.window.start ||
          originalBlock.window.end != block.window.end) {
        changes.add(
          ScheduleChange(
            entityId: block.id,
            summary: 'Move ${block.title} to reduce conflicts.',
            reason:
                'Flexible work can move while fixed commitments stay protected.',
            before: originalBlock.window,
            after: block.window,
          ),
        );
      }
    }
    return changes;
  }

  DayPlan? _reflowFlexibleBlocks(DayPlan plan, TimeWindow? unavailable) {
    final fixed = plan.blocks
        .where((block) => block.type == BlockType.fixed)
        .toList();
    final occupied = [for (final block in fixed) block.window, ?unavailable];
    final reflowed = [...fixed];
    final flexible =
        plan.blocks.where((block) => block.type != BlockType.fixed).toList()
          ..sort(_compareBlocks);
    for (final block in flexible) {
      // Fully elapsed reservations stay in place; unfinished work needs explicit remaining-work input.
      if (unavailable != null && !block.window.end.isAfter(unavailable.start)) {
        reflowed.add(block);
        occupied.add(block.window);
        continue;
      }
      if (unavailable != null &&
          block.window.start.isBefore(unavailable.start)) {
        return null;
      }
      var start = _latestDateTime(block.window.start, plan.workingWindow.start);
      occupied.sort((a, b) => a.start.compareTo(b.start));
      for (final window in occupied) {
        if (start.isBefore(window.end.add(minimumTransition)) &&
            start
                .add(block.duration)
                .isAfter(window.start.subtract(minimumTransition))) {
          start = window.end.add(minimumTransition);
        }
      }
      final end = start.add(block.duration);
      if (end.isAfter(plan.workingWindow.end)) return null;
      final moved = TimeBlock(
        id: block.id,
        title: block.title,
        window: TimeWindow(start: start, end: end),
        type: block.type,
        taskIds: block.taskIds,
        category: block.category,
        sourceId: block.sourceId,
        buffers: block.buffers,
      );
      reflowed.add(moved);
      occupied.add(moved.window);
    }
    reflowed.sort(_compareBlocks);
    return DayPlan(
      id: plan.id,
      day: plan.day,
      timeZone: plan.timeZone,
      workingWindow: plan.workingWindow,
      blocks: reflowed,
      tasks: plan.tasks,
      revision: plan.revision,
    );
  }

  DateTime _latestDateTime(DateTime first, DateTime second) {
    return first.isAfter(second) ? first : second;
  }

  DayPlan _previewWithDeferredTasks(DayPlan plan, List<String> deferredIds) {
    if (deferredIds.isEmpty) {
      return plan;
    }
    final deferred = deferredIds.toSet();
    return DayPlan(
      id: plan.id,
      day: plan.day,
      timeZone: plan.timeZone,
      workingWindow: plan.workingWindow,
      revision: plan.revision,
      blocks: plan.blocks
          .map(
            (block) => TimeBlock(
              id: block.id,
              title: block.title,
              window: block.window,
              type: block.type,
              taskIds: block.taskIds
                  .where((taskId) => !deferred.contains(taskId))
                  .toList(),
              category: block.category,
              sourceId: block.sourceId,
              buffers: block.buffers,
            ),
          )
          .toList(),
      tasks: plan.tasks
          .map(
            (task) => DayweftTask(
              id: task.id,
              title: task.title,
              estimatedDuration: task.estimatedDuration,
              actualDuration: task.actualDuration,
              priority: task.priority,
              category: task.category,
              deadline: task.deadline,
              notes: task.notes,
              energyRequired: task.energyRequired,
              cognitiveLoad: task.cognitiveLoad,
              dependencyIds: task.dependencyIds,
              canSplit: task.canSplit,
              minimumUsefulDuration: task.minimumUsefulDuration,
              status: deferred.contains(task.id)
                  ? TaskStatus.deferred
                  : task.status,
            ),
          )
          .toList(),
    );
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

  List<String> _tradeOffsFor(ReweaveStrategy strategy, int deferredCount) {
    return switch (strategy) {
      ReweaveStrategy.protectEssentials => <String>[
        'Lower-priority flexible work may move later.',
        'The day may still feel full if fixed commitments dominate.',
      ],
      ReweaveStrategy.balancedReweave => <String>[
        'Preserves more of the original plan.',
        if (deferredCount > 0) 'Defers $deferredCount lower-priority task.',
        'Leaves less recovery time than Reduce Pressure.',
      ],
      ReweaveStrategy.reducePressure => <String>[
        'Protects more breathing room.',
        if (deferredCount == 0)
          'No eligible optional work was found to defer.'
        else
          'Defers $deferredCount lower-priority task(s).',
      ],
    };
  }
}
