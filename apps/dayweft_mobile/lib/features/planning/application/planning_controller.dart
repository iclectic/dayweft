import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
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

  Future<void> completeOnboarding({
    required bool includeSampleData,
    OnboardingPreferences choices = const OnboardingPreferences(),
  }) async {
    await _repository.completeOnboarding(
      includeSampleData: includeSampleData,
      choices: choices,
    );
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> removeSampleData() async {
    await _repository.removeSampleData();
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> updatePlanningPreferences(OnboardingPreferences choices) async {
    await _repository.updatePlanningPreferences(choices);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> updatePlanningBuffers({
    required int preferredBreakMinutes,
    required int contingencyMinutes,
    required int transitionMinutes,
  }) async {
    await _repository.updatePlanningBuffers(
      preferredBreakMinutes: preferredBreakMinutes,
      contingencyMinutes: contingencyMinutes,
      transitionMinutes: transitionMinutes,
    );
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

  Future<void> reorderBlockToIndex({
    required String blockId,
    required int newIndex,
  }) async {
    await _repository.reorderBlockToIndex(blockId: blockId, newIndex: newIndex);
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

  Future<void> addConfirmedCaptures(List<ParsedCapture> captures) async {
    await _repository.addConfirmedCaptures(captures);
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

  Future<void> recordTaskActualDuration(
    String taskId, {
    required int actualMinutes,
  }) async {
    await _repository.recordTaskActualDuration(
      taskId,
      actualMinutes: actualMinutes,
    );
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> applyTemplate(DayTemplate template) async {
    await _repository.applyTemplate(template);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<String> exportLocalData() {
    return _repository.exportLocalData();
  }

  Future<void> importLocalData(String rawJson) async {
    await _repository.importLocalData(rawJson);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<List<RealityObservation>> realityCheckToday() {
    return _repository.realityCheckToday();
  }

  Future<ReweaveResult> reweaveToday({
    required domain.DisruptionType disruptionType,
  }) {
    return _repository.reweaveToday(disruptionType: disruptionType);
  }

  Future<void> applyReweaveAlternative(ReweaveAlternative alternative) async {
    await _repository.applyReweaveAlternative(alternative);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<RhythmSummary> loadRhythmSummary() {
    return _repository.loadRhythmSummary();
  }

  Future<void> recordEnergyCheckIn(String level) async {
    await _repository.recordEnergyCheckIn(level);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> setEnergyEnabled(bool enabled) async {
    await _repository.setEnergyEnabled(enabled);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> excludeEstimationRecord(
    String id, {
    required bool excluded,
  }) async {
    await _repository.excludeEstimationRecord(id, excluded: excluded);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> deleteEstimationRecord(String id) async {
    await _repository.deleteEstimationRecord(id);
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> deleteLearningHistory() async {
    await _repository.deleteLearningHistory();
    state = await AsyncValue.guard(_repository.loadToday);
  }

  Future<void> completeFocusSession({
    required String title,
    required int plannedMinutes,
    required int actualMinutes,
    required int interruptionCount,
  }) {
    return _repository.completeFocusSession(
      title: title,
      plannedMinutes: plannedMinutes,
      actualMinutes: actualMinutes,
      interruptionCount: interruptionCount,
    );
  }

  Future<LocalShareSummary> createLocalAvailabilityShare() {
    return _repository.createLocalAvailabilityShare();
  }

  Future<void> revokeLocalShares() {
    return _repository.revokeLocalShares();
  }

  Future<void> markCalendarPermission(String permissionState) {
    return _repository.markCalendarPermission(permissionState);
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
