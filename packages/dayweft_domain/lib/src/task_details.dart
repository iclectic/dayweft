import 'dayweft_domain_base.dart';

class TaskDetails {
  TaskDetails({
    required this.title,
    required this.estimatedMinutes,
    this.priority = TaskPriority.medium,
    this.category,
    this.notes,
    this.deadline,
    this.energyRequired,
    this.cognitiveLoad,
    this.canSplit = false,
    this.minimumUsefulMinutes = 15,
    List<String> dependencyIds = const [],
  }) : dependencyIds = List.unmodifiable(dependencyIds);

  final String title;
  final int estimatedMinutes;
  final TaskPriority priority;
  final String? category;
  final String? notes;
  final DateTime? deadline;
  final EnergyLevel? energyRequired;
  final CognitiveLoad? cognitiveLoad;
  final bool canSplit;
  final int minimumUsefulMinutes;
  final List<String> dependencyIds;

  String? get validationMessage {
    if (title.trim().isEmpty || title.length > 500) {
      return 'Use a task title between 1 and 500 characters.';
    }
    if (estimatedMinutes < 1 || estimatedMinutes > 1440) {
      return 'Enter an estimate between 1 and 1440 minutes.';
    }
    if ((notes?.length ?? 0) > 20000 || (category?.length ?? 0) > 80) {
      return 'Use up to 20,000 characters for notes and 80 for a category.';
    }
    if (minimumUsefulMinutes < 1 ||
        minimumUsefulMinutes > 1440 ||
        (canSplit && minimumUsefulMinutes > estimatedMinutes)) {
      return 'A useful fragment must be positive and fit the task estimate.';
    }
    if (dependencyIds.length > 100) {
      return 'Use no more than 100 predecessor tasks.';
    }
    return null;
  }
}

String? taskDependencyIssue(
  String taskId,
  List<String> dependencies,
  Map<String, List<String>> graph,
) {
  if (dependencies.toSet().length != dependencies.length) {
    return 'Select each predecessor only once.';
  }
  if (dependencies.contains(taskId)) return 'A task cannot depend on itself.';
  if (dependencies.any((id) => !graph.containsKey(id))) {
    return 'A predecessor is no longer available. Review the dependencies.';
  }
  final visited = <String>{};
  final pending = [...dependencies];
  while (pending.isNotEmpty) {
    final id = pending.removeLast();
    if (id == taskId) return 'These dependencies would create a cycle.';
    if (visited.add(id)) pending.addAll(graph[id] ?? const []);
  }
  return null;
}
