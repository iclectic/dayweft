import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart' show Task;
import 'package:dayweft_mobile/core/time/app_clock.dart';
import 'package:dayweft_mobile/features/data_management/domain/day_import.dart';
import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
import 'package:dayweft_mobile/features/planning/application/planning_date.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localPlanningRepositoryProvider = Provider<LocalPlanningRepository>((
  ref,
) {
  return LocalPlanningRepository(
    ref.watch(dayweftDatabaseProvider),
    now: ref.watch(appClockProvider).now,
    planningDate: ref.watch(planningDateProvider),
  );
});

final planningControllerProvider =
    AsyncNotifierProvider<PlanningController, LocalDaySnapshot>(
      PlanningController.new,
    );

final taskCandidatesProvider = FutureProvider<List<Task>>((ref) {
  ref.watch(planningControllerProvider);
  return ref.watch(localPlanningRepositoryProvider).loadTaskCandidates();
});

class PlanningController extends AsyncNotifier<LocalDaySnapshot> {
  LocalPlanningRepository get _repository {
    return ref.read(localPlanningRepositoryProvider);
  }

  @override
  Future<LocalDaySnapshot> build() {
    return ref.watch(localPlanningRepositoryProvider).loadSelectedDay();
  }

  Future<void> reload() async {
    state = const AsyncLoading<LocalDaySnapshot>();
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> completeOnboarding({
    required bool includeSampleData,
    OnboardingPreferences choices = const OnboardingPreferences(),
  }) async {
    await _repository.completeOnboarding(
      includeSampleData: includeSampleData,
      choices: choices,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> removeSampleData() async {
    await _repository.removeSampleData();
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> updatePlanningPreferences(OnboardingPreferences choices) async {
    await _repository.updatePlanningPreferences(choices);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
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
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> addBlock({
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
    String? category,
    int travelBufferMinutes = 0,
    int preparationBufferMinutes = 0,
    int transitionBufferMinutes = 0,
    int recoveryBufferMinutes = 0,
  }) async {
    await _repository.addBlock(
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
      blockType: blockType,
      category: category,
      travelBufferMinutes: travelBufferMinutes,
      preparationBufferMinutes: preparationBufferMinutes,
      transitionBufferMinutes: transitionBufferMinutes,
      recoveryBufferMinutes: recoveryBufferMinutes,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> deleteBlock(String blockId) async {
    await _repository.deleteBlock(blockId);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> updateBlock({
    required String blockId,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required String blockType,
    int? expectedVersion,
    String? category,
    int? travelBufferMinutes,
    int? preparationBufferMinutes,
    int? transitionBufferMinutes,
    int? recoveryBufferMinutes,
  }) async {
    await _repository.updateBlock(
      blockId: blockId,
      title: title,
      startsAt: startsAt,
      endsAt: endsAt,
      blockType: blockType,
      expectedVersion: expectedVersion,
      category: category,
      travelBufferMinutes: travelBufferMinutes,
      preparationBufferMinutes: preparationBufferMinutes,
      transitionBufferMinutes: transitionBufferMinutes,
      recoveryBufferMinutes: recoveryBufferMinutes,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> moveBlock({
    required String blockId,
    required int direction,
  }) async {
    await _repository.moveBlock(blockId: blockId, direction: direction);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> reorderBlockToIndex({
    required String blockId,
    required int newIndex,
  }) async {
    await _repository.reorderBlockToIndex(blockId: blockId, newIndex: newIndex);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
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
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> addInboxTask(String title) async {
    await _repository.addInboxTask(title: title);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> addInboxTasks(List<String> titles) async {
    await _repository.addInboxTasks(titles);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> addConfirmedCaptures(
    List<ParsedCapture> captures, {
    String? blockId,
  }) async {
    await _repository.addConfirmedCaptures(captures, blockId: blockId);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> moveInboxTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    await _repository.moveInboxTaskToBlock(taskId: taskId, blockId: blockId);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> movePlannedTaskToBlock({
    required String taskId,
    required String blockId,
  }) async {
    await _repository.movePlannedTaskToBlock(taskId: taskId, blockId: blockId);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> toggleTask(String taskId) async {
    await _repository.toggleTask(taskId);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> updateTask({
    required String taskId,
    required int expectedVersion,
    required domain.TaskDetails details,
  }) async {
    await _repository.updateTask(
      taskId: taskId,
      expectedVersion: expectedVersion,
      details: details,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<String> deleteTask(
    String taskId, {
    required int expectedVersion,
  }) async {
    final revisionId = await _repository.deleteTask(
      taskId,
      expectedVersion: expectedVersion,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
    return revisionId;
  }

  Future<void> returnTaskToInbox(
    String taskId, {
    required int expectedVersion,
  }) async {
    await _repository.returnTaskToInbox(
      taskId,
      expectedVersion: expectedVersion,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> recordTaskActualDuration(
    String taskId, {
    required int actualMinutes,
  }) async {
    await _repository.recordTaskActualDuration(
      taskId,
      actualMinutes: actualMinutes,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<domain.TemplatePreview> previewTemplate(DayTemplate template) =>
      _repository.previewTemplate(template);

  Future<void> applyTemplatePreview(
    domain.TemplatePreview preview, {
    Set<int>? selectedIndices,
  }) async {
    await _repository.applyTemplatePreview(
      preview,
      selectedIndices: selectedIndices,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> applyTemplate(DayTemplate template) async {
    await _repository.applyTemplate(template);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<String> exportLocalData() {
    return _repository.exportLocalData();
  }

  Future<void> importLocalData(String rawJson) async {
    await _repository.importLocalData(rawJson);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  DayImport previewLocalImport(String rawJson) =>
      _repository.previewLocalImport(rawJson);

  Future<List<RealityObservation>> realityCheckToday() {
    return _repository.realityCheckToday();
  }

  Future<ReweaveResult> reweaveToday({
    required domain.DisruptionType disruptionType,
    int? unavailableMinutes,
  }) {
    return _repository.reweaveToday(
      disruptionType: disruptionType,
      unavailableMinutes: unavailableMinutes,
    );
  }

  Future<void> applyReweaveAlternative(ReweaveAlternative alternative) async {
    await _repository.applyReweaveAlternative(alternative);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<RhythmSummary> loadRhythmSummary() {
    return _repository.loadRhythmSummary();
  }

  Future<void> recordEnergyCheckIn(String level) async {
    await _repository.recordEnergyCheckIn(level);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> setEnergyEnabled(bool enabled) async {
    await _repository.setEnergyEnabled(enabled);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> excludeEstimationRecord(
    String id, {
    required bool excluded,
  }) async {
    await _repository.excludeEstimationRecord(id, excluded: excluded);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> deleteEstimationRecord(String id) async {
    await _repository.deleteEstimationRecord(id);
    state = await AsyncValue.guard(_repository.loadSelectedDay);
  }

  Future<void> deleteLearningHistory() async {
    await _repository.deleteLearningHistory();
    state = await AsyncValue.guard(_repository.loadSelectedDay);
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

  Future<bool> undoLastRevision({String? expectedRevisionId}) async {
    final didUndo = await _repository.undoLastRevision(
      expectedRevisionId: expectedRevisionId,
    );
    state = await AsyncValue.guard(_repository.loadSelectedDay);
    return didUndo;
  }

  ParsedCapture parseCapture(String input) {
    return _repository.parseCapture(input);
  }
}
