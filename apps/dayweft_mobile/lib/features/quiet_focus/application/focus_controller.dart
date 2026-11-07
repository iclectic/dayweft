import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/features/quiet_focus/data/focus_repository.dart';
import 'package:dayweft_mobile/features/quiet_focus/data/platform_focus_time.dart';
import 'package:dayweft_mobile/features/quiet_focus/domain/focus_time.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final focusTimeSourceProvider = Provider<FocusTimeSource>(
  (ref) => PlatformFocusTime(),
);
final focusRepositoryProvider = Provider<FocusRepository>(
  (ref) => FocusRepository(
    ref.watch(dayweftDatabaseProvider),
    ref.watch(focusTimeSourceProvider),
  ),
);
final focusControllerProvider =
    AsyncNotifierProvider<FocusController, FocusSnapshot?>(FocusController.new);

class FocusController extends AsyncNotifier<FocusSnapshot?> {
  FocusRepository get _repository => ref.read(focusRepositoryProvider);
  @override
  Future<FocusSnapshot?> build() =>
      ref.watch(focusRepositoryProvider).loadActive();

  Future<void> refresh({bool checkpoint = false}) async {
    final next = checkpoint
        ? await _repository.checkpoint()
        : await _repository.loadActive();
    state = AsyncData(next);
  }

  Future<void> start({
    required String title,
    required FocusMode mode,
    required int minutes,
    String? taskId,
  }) async {
    state = AsyncData(
      await _repository.start(
        title: title,
        mode: mode,
        plannedMinutes: minutes,
        taskId: taskId,
      ),
    );
  }

  Future<void> pause() async {
    final current = state.requireValue!;
    state = AsyncData(
      await _repository.pause(current.session.id, current.version),
    );
  }

  Future<void> resume() async {
    final current = state.requireValue!;
    state = AsyncData(
      await _repository.resume(current.session.id, current.version),
    );
  }

  Future<void> interrupt() async {
    final current = state.requireValue!;
    state = AsyncData(
      await _repository.interrupt(current.session.id, current.version),
    );
  }

  Future<void> restart() async {
    final current = state.requireValue!;
    state = AsyncData(
      await _repository.restart(current.session.id, current.version),
    );
  }

  Future<void> finish({
    bool abandoned = false,
    bool completeTask = false,
  }) async {
    final current = state.requireValue!;
    await _repository.finish(
      current.session.id,
      current.version,
      abandoned: abandoned,
      completeTask: completeTask,
    );
    state = const AsyncData(null);
  }
}
