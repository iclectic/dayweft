import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:dayweft_mobile/core/database/database_provider.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/core/time/app_clock.dart';
import 'package:dayweft_mobile/features/templates/data/custom_template_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customTemplateRepositoryProvider = Provider<CustomTemplateRepository>(
  (ref) => CustomTemplateRepository(
    ref.watch(dayweftDatabaseProvider),
    now: ref.watch(appClockProvider).now,
  ),
);
final templateLibraryProvider =
    AsyncNotifierProvider<TemplateLibraryController, List<DayTemplate>>(
      TemplateLibraryController.new,
      retry: (count, error) => error is PlanningFailure
          ? null
          : ProviderContainer.defaultRetry(count, error),
    );

class TemplateLibraryController extends AsyncNotifier<List<DayTemplate>> {
  CustomTemplateRepository get _repository =>
      ref.read(customTemplateRepositoryProvider);
  @override
  Future<List<DayTemplate>> build() =>
      ref.watch(customTemplateRepositoryProvider).loadAll();

  Future<DayTemplate> save({
    DayTemplate? original,
    required String name,
    required List<TemplateBlock> blocks,
  }) async {
    final saved = original == null
        ? await _repository.create(name: name, blocks: blocks)
        : await _repository.update(
            id: original.id,
            expectedVersion: original.version!,
            name: name,
            blocks: blocks,
          );
    await _reload();
    return saved;
  }

  Future<void> duplicate(DayTemplate template) async {
    await _repository.duplicate(
      template.id,
      expectedVersion: template.version!,
    );
    await _reload();
  }

  Future<int> delete(DayTemplate template) async {
    final version = await _repository.delete(
      template.id,
      expectedVersion: template.version!,
    );
    await _reload();
    return version;
  }

  Future<void> restore(String id, int expectedVersion) async {
    await _repository.restore(id, expectedVersion: expectedVersion);
    await _reload();
  }

  // A library read failure must not report a completed write as unsuccessful.
  Future<void> _reload() async =>
      state = await AsyncValue.guard(_repository.loadAll);
}
