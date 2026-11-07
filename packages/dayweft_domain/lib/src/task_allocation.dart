import 'dayweft_domain_base.dart';

/// One explicit, continuous allocation of an existing task inside a block.
class TaskAllocation {
  const TaskAllocation({
    required this.id,
    required this.taskId,
    required this.blockId,
    required this.window,
  });

  final String id;
  final String taskId;
  final String blockId;
  final TimeWindow window;
}

/// Checks a complete allocation proposal without changing the original plan.
/// Every planned task must be represented, including tasks that are not split.
String? taskAllocationIssue({
  required List<DayweftTask> tasks,
  required List<TimeBlock> blocks,
  required List<TaskAllocation> allocations,
}) {
  final taskById = {for (final task in tasks) task.id: task};
  final blockById = {for (final block in blocks) block.id: block};
  if (taskById.length != tasks.length ||
      blockById.length != blocks.length ||
      taskById.containsKey('') ||
      blockById.containsKey('')) {
    return 'Tasks and blocks need distinct identities.';
  }
  final allocationIds = <String>{};
  final byTask = <String, List<TaskAllocation>>{};
  final byBlock = <String, List<TaskAllocation>>{};
  final fixedOwners = <String, String>{};
  for (final block in blocks.where((block) => block.type == BlockType.fixed)) {
    for (final id in block.taskIds) {
      if (fixedOwners.containsKey(id)) {
        return 'A task cannot belong to more than one fixed commitment.';
      }
      fixedOwners[id] = block.id;
    }
  }
  final sortedBlocks = [...blocks]
    ..sort((a, b) => a.window.start.compareTo(b.window.start));
  for (var i = 1; i < sortedBlocks.length; i++) {
    if (sortedBlocks[i - 1].window.overlaps(sortedBlocks[i].window)) {
      return 'Overlapping blocks must be resolved before allocating tasks.';
    }
  }
  for (final allocation in allocations) {
    final task = taskById[allocation.taskId];
    final block = blockById[allocation.blockId];
    if (allocation.id.isEmpty ||
        !allocationIds.add(allocation.id) ||
        task == null ||
        block == null ||
        task.status != TaskStatus.planned) {
      return 'Every allocation must identify a distinct allocation, planned task and existing block.';
    }
    final window = allocation.window;
    final fixedOwner = fixedOwners[task.id];
    if ((fixedOwner != null && fixedOwner != block.id) ||
        (block.type == BlockType.fixed && fixedOwner != block.id)) {
      return 'Tasks cannot be moved into or out of a fixed commitment.';
    }
    if (window.duration <= Duration.zero ||
        window.duration.inMicroseconds % Duration.microsecondsPerMinute != 0 ||
        window.start.isBefore(block.window.start) ||
        window.end.isAfter(block.window.end)) {
      return 'Each allocation must fit inside its block and use whole, positive minutes.';
    }
    // Until buffer positions are represented, conservatively reserve the end
    // of the block. This matches the proposal generator's assumption.
    if (window.end.isAfter(
      block.window.end.subtract(block.reservedBufferDuration),
    )) {
      return 'An allocation overlaps the time reserved for block buffers.';
    }
    if ((task.earliestStart != null &&
            window.start.isBefore(task.earliestStart!)) ||
        (task.latestFinish != null && window.end.isAfter(task.latestFinish!)) ||
        (task.deadline != null && window.end.isAfter(task.deadline!))) {
      return 'An allocation falls outside its task’s permitted time or deadline.';
    }
    (byTask[task.id] ??= []).add(allocation);
    (byBlock[block.id] ??= []).add(allocation);
  }
  for (final block in blocks) {
    final fragments = byBlock[block.id] ?? [];
    fragments.sort((a, b) => a.window.start.compareTo(b.window.start));
    var duration = Duration.zero;
    for (var i = 0; i < fragments.length; i++) {
      duration += fragments[i].window.duration;
      if (i > 0 && fragments[i - 1].window.overlaps(fragments[i].window)) {
        return 'Allocations within a block cannot overlap.';
      }
    }
    if (block.buffers.any((buffer) => buffer.duration.isNegative) ||
        duration + block.reservedBufferDuration > block.duration) {
      return 'Allocations and reserved buffers must fit within the block.';
    }
  }
  final chronological = [...allocations]
    ..sort((a, b) => a.window.start.compareTo(b.window.start));
  for (var i = 1; i < chronological.length; i++) {
    if (chronological[i - 1].window.overlaps(chronological[i].window)) {
      return 'Task allocations cannot overlap.';
    }
  }
  for (final task in tasks.where((task) => task.status == TaskStatus.planned)) {
    final fragments = byTask[task.id] ?? [];
    if (task.estimatedDuration <= Duration.zero ||
        task.minimumUsefulDuration <= Duration.zero) {
      return 'A task needs a positive estimate and minimum fragment duration.';
    }
    if (fragments.isEmpty || (!task.canSplit && fragments.length != 1)) {
      return 'Each planned task needs an allocation and may split only with permission.';
    }
    final total = fragments.fold<Duration>(
      Duration.zero,
      (sum, item) => sum + item.window.duration,
    );
    if (total != task.estimatedDuration ||
        (fragments.length > 1 &&
            fragments.any(
              (item) => item.window.duration < task.minimumUsefulDuration,
            ))) {
      return 'Allocations must account for the estimate and respect minimum fragment duration.';
    }
    final firstStart = fragments
        .map((item) => item.window.start)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    for (final predecessorId in task.dependencyIds) {
      final predecessor = taskById[predecessorId];
      if (predecessor == null) {
        return 'An allocated task has a missing predecessor.';
      }
      if (predecessor.status == TaskStatus.completed) continue;
      final predecessors = byTask[predecessorId] ?? [];
      if (predecessors.isEmpty ||
          predecessors.any((item) => item.window.end.isAfter(firstStart))) {
        return 'Every predecessor must finish before its dependent task begins.';
      }
    }
  }
  return null;
}
