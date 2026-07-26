import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(planningControllerProvider);
    return state.when(
      data: (snapshot) => _SettingsView(snapshot: snapshot),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Center(child: Text(error.toString())),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _SettingsView extends ConsumerWidget {
  const _SettingsView({required this.snapshot});

  final LocalDaySnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const SwitchListTile(
            value: true,
            onChanged: null,
            title: Text('Local-only mode'),
            subtitle: Text('Cloud features stay optional.'),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Planning defaults'),
            subtitle: Text(
              'Wake ${snapshot.preferences.wakeTime}, wind down '
              '${snapshot.preferences.windDownTime}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Sample data'),
            subtitle: Text(
              snapshot.preferences.sampleDataEnabled
                  ? 'Installed'
                  : 'Not installed',
            ),
            trailing: TextButton(
              onPressed: snapshot.preferences.sampleDataEnabled
                  ? () => ref
                        .read(planningControllerProvider.notifier)
                        .removeSampleData()
                  : null,
              child: const Text('Remove'),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy by design'),
            subtitle: Text('Analytics and AI controls will require consent.'),
          ),
          const ListTile(
            leading: Icon(Icons.download_outlined),
            title: Text('Data export'),
            subtitle: Text('Planned for a later Phase 3 vertical slice.'),
          ),
        ],
      ),
    );
  }
}
