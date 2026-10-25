enum BlockType { fixed, flexible, optional }

enum TaskPriority { low, medium, high, essential }

enum EnergyLevel { low, steady, high }

enum CognitiveLoad { light, moderate, demanding }

enum BufferType { travel, preparation, transition, recovery }

enum TaskStatus { inbox, planned, completed, deferred, deleted }

enum DisruptionType {
  runningLate,
  meetingOverran,
  taskTookLonger,
  newUrgentTask,
  energyChanged,
  needBreak,
  missedPartOfDay,
  custom,
}

enum ReweaveStrategy { protectEssentials, balancedReweave, reducePressure }

extension ReweaveStrategyLabel on ReweaveStrategy {
  String get label => switch (this) {
    ReweaveStrategy.protectEssentials => 'Protect Essentials',
    ReweaveStrategy.balancedReweave => 'Balanced Reweave',
    ReweaveStrategy.reducePressure => 'Reduce Pressure',
  };
}

class TimeWindow {
  const TimeWindow({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);

  bool overlaps(TimeWindow other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  bool contains(DateTime value) {
    return !value.isBefore(start) && value.isBefore(end);
  }
}

class DayweftTask {
  const DayweftTask({
    required this.id,
    required this.title,
    required this.estimatedDuration,
    this.actualDuration,
    this.priority = TaskPriority.medium,
    this.category,
    this.deadline,
    this.notes,
    this.energyRequired,
    this.cognitiveLoad,
    this.dependencyIds = const <String>[],
    this.canSplit = false,
    this.minimumUsefulDuration = const Duration(minutes: 15),
    this.status = TaskStatus.inbox,
  });

  final String id;
  final String title;
  final Duration estimatedDuration;
  final Duration? actualDuration;
  final TaskPriority priority;
  final String? category;
  final DateTime? deadline;
  final String? notes;
  final EnergyLevel? energyRequired;
  final CognitiveLoad? cognitiveLoad;
  final List<String> dependencyIds;
  final bool canSplit;
  final Duration minimumUsefulDuration;
  final TaskStatus status;

  // Historical actual time is evidence, never a replacement for remaining work.
  Duration get planningDuration =>
      status == TaskStatus.completed || status == TaskStatus.deleted
      ? Duration.zero
      : estimatedDuration;
}

class DayweftBuffer {
  const DayweftBuffer({
    required this.id,
    required this.type,
    required this.duration,
  });

  final String id;
  final BufferType type;
  final Duration duration;
}

class TimeBlock {
  const TimeBlock({
    required this.id,
    required this.title,
    required this.window,
    required this.type,
    this.taskIds = const <String>[],
    this.category,
    this.sourceId,
    this.buffers = const <DayweftBuffer>[],
  });

  final String id;
  final String title;
  final TimeWindow window;
  final BlockType type;
  final List<String> taskIds;
  final String? category;
  final String? sourceId;
  final List<DayweftBuffer> buffers;

  Duration get duration => window.duration;

  Duration get reservedBufferDuration {
    return buffers.fold(
      Duration.zero,
      (total, buffer) => total + buffer.duration,
    );
  }
}

class DayPlan {
  const DayPlan({
    required this.id,
    required this.day,
    required this.timeZone,
    required this.workingWindow,
    this.blocks = const <TimeBlock>[],
    this.tasks = const <DayweftTask>[],
    this.revision = 0,
  });

  final String id;
  final DateTime day;
  final String timeZone;
  final TimeWindow workingWindow;
  final List<TimeBlock> blocks;
  final List<DayweftTask> tasks;
  final int revision;

  Map<String, DayweftTask> get tasksById {
    return <String, DayweftTask>{for (final task in tasks) task.id: task};
  }
}

class Disruption {
  const Disruption({
    required this.id,
    required this.type,
    required this.reportedAt,
    this.duration,
    this.description,
  });

  final String id;
  final DisruptionType type;
  final DateTime reportedAt;
  final Duration? duration;
  final String? description;
}

class ScheduleChange {
  const ScheduleChange({
    required this.entityId,
    required this.summary,
    required this.reason,
    this.before,
    this.after,
  });

  final String entityId;
  final String summary;
  final String reason;
  final TimeWindow? before;
  final TimeWindow? after;
}
