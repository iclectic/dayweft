import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:test/test.dart';

void main() {
  test('details accept optional attributes without requiring energy use', () {
    final details = TaskDetails(
      title: 'Read',
      estimatedMinutes: 30,
      priority: TaskPriority.high,
      cognitiveLoad: CognitiveLoad.demanding,
      canSplit: true,
      minimumUsefulMinutes: 10,
      dependencyIds: ['prepare'],
    );
    expect(details.validationMessage, isNull);
    expect(details.energyRequired, isNull);
    expect(() => details.dependencyIds.add('another'), throwsUnsupportedError);
  });

  test(
    'invalid durations, tiny fragments and unbounded content are rejected',
    () {
      for (final details in [
        TaskDetails(title: ' ', estimatedMinutes: 30),
        TaskDetails(title: 'Task', estimatedMinutes: 0),
        TaskDetails(title: 'Task', estimatedMinutes: 1441),
        TaskDetails(
          title: 'Task',
          estimatedMinutes: 20,
          canSplit: true,
          minimumUsefulMinutes: 21,
        ),
        TaskDetails(
          title: 'Task',
          estimatedMinutes: 20,
          minimumUsefulMinutes: 0,
        ),
        TaskDetails(title: 'Task', estimatedMinutes: 20, notes: 'n' * 20001),
        TaskDetails(title: 'Task', estimatedMinutes: 20, category: 'c' * 81),
      ]) {
        expect(details.validationMessage, isNotNull);
      }
    },
  );

  test(
    'dependency validation rejects self, missing, duplicate and cyclic links',
    () {
      final graph = <String, List<String>>{
        'a': [],
        'b': ['a'],
        'c': ['b'],
      };
      expect(taskDependencyIssue('a', [], graph), isNull);
      expect(taskDependencyIssue('c', ['a'], graph), isNull);
      expect(taskDependencyIssue('a', ['a'], graph), isNotNull);
      expect(taskDependencyIssue('a', ['missing'], graph), isNotNull);
      expect(taskDependencyIssue('c', ['a', 'a'], graph), isNotNull);
      expect(taskDependencyIssue('a', ['c'], graph), isNotNull);
    },
  );
}
