import 'dart:convert';

import 'package:dayweft_domain/dayweft_domain.dart';

/// Returns one conservative, deterministic proposal, or null if this greedy
/// search cannot produce one. Null is not proof that no valid plan exists.
/// Fixed blocks are available only to tasks already assigned to them. Buffers
/// reserve the end of each block because their exact placement is not stored.
List<TaskAllocation>? proposeTaskAllocations(
  DayPlan plan, {
  TimeWindow? unavailable,
}) {
  if (plan.workingWindow.duration <= Duration.zero) return null;
  if (unavailable != null && unavailable.duration <= Duration.zero) return null;
  final tasks =
      plan.tasks.where((task) => task.status == TaskStatus.planned).toList()
        ..sort((a, b) => a.id.compareTo(b.id));
  final taskMap = plan.tasksById;
  final blocks = [...plan.blocks]
    ..sort((a, b) {
      final byTime = a.window.start.compareTo(b.window.start);
      return byTime == 0 ? a.id.compareTo(b.id) : byTime;
    });
  if (taskMap.length != plan.tasks.length ||
      blocks.map((b) => b.id).toSet().length != blocks.length) {
    return null;
  }
  for (var i = 0; i < blocks.length; i++) {
    final block = blocks[i];
    if (block.duration <= Duration.zero ||
        block.buffers.any((b) => b.duration.isNegative) ||
        block.reservedBufferDuration > block.duration ||
        (block.type != BlockType.fixed &&
            (block.window.start.isBefore(plan.workingWindow.start) ||
                block.window.end.isAfter(plan.workingWindow.end))) ||
        (i > 0 && blocks[i - 1].window.overlaps(block.window)) ||
        (block.type == BlockType.fixed &&
            unavailable != null &&
            block.window.overlaps(unavailable))) {
      return null;
    }
  }
  final originalBlock = <String, TimeBlock>{};
  for (final block in blocks) {
    for (final id in block.taskIds) {
      if (!taskMap.containsKey(id) || originalBlock.containsKey(id)) {
        return null;
      }
      originalBlock[id] = block;
    }
  }
  final allocations = <TaskAllocation>[];
  final scheduled = <String>{};
  final remaining = [...tasks];
  while (remaining.isNotEmpty) {
    final available = remaining
        .where(
          (task) => task.dependencyIds.every(
            (id) =>
                taskMap[id]?.status == TaskStatus.completed ||
                scheduled.contains(id),
          ),
        )
        .toList();
    if (available.isEmpty) return null;
    final task = available.first;
    final origin = originalBlock[task.id];
    if (origin == null ||
        task.estimatedDuration <= Duration.zero ||
        task.minimumUsefulDuration <= Duration.zero) {
      return null;
    }
    DateTime? after;
    for (final id in task.dependencyIds) {
      for (final part in allocations.where((item) => item.taskId == id)) {
        if (after == null || part.window.end.isAfter(after)) {
          after = part.window.end;
        }
      }
    }
    var durationLeft = task.estimatedDuration;
    final newParts = <TaskAllocation>[];
    for (final block in blocks) {
      if (origin.type == BlockType.fixed
          ? block.id != origin.id
          : block.type == BlockType.fixed) {
        continue;
      }
      var cursor = block.window.start;
      final usableEnd = block.window.end.subtract(block.reservedBufferDuration);
      final occupied = [
        ...allocations
            .where((item) => item.blockId == block.id)
            .map((item) => item.window),
        if (unavailable != null && unavailable.overlaps(block.window))
          unavailable,
      ]..sort((a, b) => a.start.compareTo(b.start));
      final boundaries = [
        ...occupied,
        TimeWindow(start: usableEnd, end: usableEnd),
      ];
      for (final reserved in boundaries) {
        if (after != null && cursor.isBefore(after)) cursor = after;
        if (task.earliestStart != null &&
            cursor.isBefore(task.earliestStart!)) {
          cursor = task.earliestStart!;
        }
        var end = reserved.start.isBefore(usableEnd)
            ? reserved.start
            : usableEnd;
        if (task.latestFinish != null && task.latestFinish!.isBefore(end)) {
          end = task.latestFinish!;
        }
        if (task.deadline != null && task.deadline!.isBefore(end)) {
          end = task.deadline!;
        }
        if (end.isAfter(cursor)) {
          final capacity = end.difference(cursor);
          var take = durationLeft <= capacity ? durationLeft : capacity;
          if (take < durationLeft &&
              task.canSplit &&
              durationLeft - take < task.minimumUsefulDuration) {
            take = durationLeft - task.minimumUsefulDuration;
          }
          if ((!task.canSplit && take < durationLeft) ||
              (take < durationLeft && take < task.minimumUsefulDuration) ||
              take <= Duration.zero) {
            take = Duration.zero;
          }
          if (take > Duration.zero) {
            newParts.add(
              TaskAllocation(
                id: jsonEncode([task.id, newParts.length]),
                taskId: task.id,
                blockId: block.id,
                window: TimeWindow(start: cursor, end: cursor.add(take)),
              ),
            );
            durationLeft -= take;
            if (durationLeft == Duration.zero) break;
          }
        }
        if (cursor.isBefore(reserved.end)) cursor = reserved.end;
      }
      if (durationLeft == Duration.zero) break;
    }
    if (durationLeft != Duration.zero) return null;
    allocations.addAll(newParts);
    scheduled.add(task.id);
    remaining.remove(task);
  }
  if (taskAllocationIssue(
        tasks: plan.tasks,
        blocks: blocks,
        allocations: allocations,
      ) !=
      null) {
    return null;
  }
  if (unavailable != null &&
      allocations.any((item) => item.window.overlaps(unavailable))) {
    return null;
  }
  return List.unmodifiable(allocations);
}
