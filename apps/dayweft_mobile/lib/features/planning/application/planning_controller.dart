import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localPlanningRepositoryProvider = Provider<LocalPlanningRepository>((
  ref,
) {
  return LocalPlanningRepository(ref.watch(dayweftDatabaseProvider));
});

final planningControllerProvider =
    AsyncNotifierProvider<PlanningController, LocalDaySnapshot>(
      PlanningController.new,
    );

class PlanningController extends AsyncNotifier<LocalDaySnapshot> {
  LocalPlanningRepository get _repository {
    return ref.read(localPlanningRepositoryProvider);
  }

  @override
  Future<LocalDaySnapshot> build() {
    return _repository.loadToday();
  }

  Future<void> reload() async {
    state = const AsyncLoading<LocalDaySnapshot>();
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> completeOnboarding({required bool includeSampleData}) async {
    await _repository.completeOnboarding(includeSampleData: includeSampleData);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> removeSampleData() async {
    await _repository.removeSampleData();
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> addBlock({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
    String? category,
  }) async {
    await _repository.addBlock(
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
      blockType: blockType,
      category: category,
    );
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> deleteBlock(String blockId) async {
    await _repository.deleteBlock(blockId);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> updateBlock({
    required String blockId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
  }) async {
    await _repository.updateBlock(
      blockId: blockId,
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
      blockType: blockType,
    );
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> moveBlock({
    required String blockId,
    required int direction,
  }) async {
    await _repository.moveBlock(blockId: blockId, direction: direction);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> addTaskToBlock({
    required String blockId,
    required String title,
    required int estimatedMinutes,
  }) async {
    await _repository.addTaskToBlock(
      blockId: blockId,
      title: title,
      estimatedMinutes: estimatedMinutes,
    );
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> addInboxTask(String title) async {
    await _repository.addInboxTask(title: title);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> addInboxTasks(List<String> titles) async {
    await _repository.addInboxTasks(titles);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> moveInboxTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    await _repository.moveInboxTaskToBlock(taskId: taskId, blockId: blockId);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> movePlannedTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    await _repository.movePlannedTaskToBlock(taskId: taskId, blockId: blockId);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> toggleTask(String taskId) async {
    await _repository.toggleTask(taskId);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> applyTemplate(DayTemplate template) async {
    await _repository.applyTemplate(template);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<bool> undoLastRevision() async {
    final didUndo = await _repository.undoLastRevision();
    state = await AsyncValue.guard(_repository.loadToday);
    return didUndo;
  }

  ParsedCapture parseCapture(String input) {
    return _repository.parseCapture(input);
  }
}
