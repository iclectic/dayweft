import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
import 'package:dayweft_mobile/features/onboarding/presentation/onboarding_screen.dart';
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
          _MinutePreferenceTile(
            icon: Icons.self_improvement,
            title: 'Preferred break',
            value: snapshot.preferences.preferredBreakMinutes,
            onChanged: (value) => ref
                .read(planningControllerProvider.notifier)
                .updatePlanningBuffers(
                  preferredBreakMinutes: value,
                  contingencyMinutes: snapshot.preferences.contingencyMinutes,
                  transitionMinutes: snapshot.preferences.transitionMinutes,
                ),
          ),
          _MinutePreferenceTile(
            icon: Icons.hourglass_empty,
            title: 'Contingency time',
            value: snapshot.preferences.contingencyMinutes,
            onChanged: (value) => ref
                .read(planningControllerProvider.notifier)
                .updatePlanningBuffers(
                  preferredBreakMinutes:
                      snapshot.preferences.preferredBreakMinutes,
                  contingencyMinutes: value,
                  transitionMinutes: snapshot.preferences.transitionMinutes,
                ),
          ),
          _MinutePreferenceTile(
            icon: Icons.swap_horiz,
            title: 'Transition buffer',
            value: snapshot.preferences.transitionMinutes,
            onChanged: (value) => ref
                .read(planningControllerProvider.notifier)
                .updatePlanningBuffers(
                  preferredBreakMinutes:
                      snapshot.preferences.preferredBreakMinutes,
                  contingencyMinutes: snapshot.preferences.contingencyMinutes,
                  transitionMinutes: value,
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
          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('Planning preferences'),
            subtitle: const Text(
              'Working pattern, day boundaries and calendar preferences',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (_) => OnboardingScreen(
                  editing: true,
                  initialPreferences: OnboardingPreferences(
                    workingPattern: WorkingPattern.values.firstWhere(
                      (value) =>
                          value.name == snapshot.preferences.workingPattern,
                      orElse: () => WorkingPattern.flexible,
                    ),
                    calendarPreference: CalendarPreference.values.firstWhere(
                      (value) =>
                          value.name == snapshot.preferences.calendarPreference,
                      orElse: () => CalendarPreference.later,
                    ),
                    planningStyle: PlanningStyle.values.firstWhere(
                      (value) =>
                          value.name == snapshot.preferences.planningStyle,
                      orElse: () => PlanningStyle.balanced,
                    ),
                    wakeTime: snapshot.preferences.wakeTime,
                    windDownTime: snapshot.preferences.windDownTime,
                    workStartTime: snapshot.preferences.workStartTime,
                    workEndTime: snapshot.preferences.workEndTime,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Data export'),
            subtitle: const Text('Copy a local JSON export from this device.'),
            trailing: TextButton(
              onPressed: () => _showExportDialog(context, ref),
              child: const Text('Export'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file_outlined),
            title: const Text('Data import'),
            subtitle: const Text('Merge a Dayweft JSON export into today.'),
            trailing: TextButton(
              onPressed: () => _showImportDialog(context, ref),
              child: const Text('Import'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: const Text('Share availability'),
            subtitle: const Text(
              'Creates a local expiring token without task details.',
            ),
            trailing: TextButton(
              onPressed: () => _showShareDialog(context, ref),
              child: const Text('Create'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.link_off),
            title: const Text('Revoke shares'),
            subtitle: const Text('Revokes locally created share tokens.'),
            trailing: TextButton(
              onPressed: () => ref
                  .read(planningControllerProvider.notifier)
                  .revokeLocalShares(),
              child: const Text('Revoke'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Calendar permission'),
            subtitle: const Text(
              'Device calendar integration is read-only by default.',
            ),
            trailing: TextButton(
              onPressed: () => ref
                  .read(planningControllerProvider.notifier)
                  .markCalendarPermission('not_requested'),
              child: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MinutePreferenceTile extends StatelessWidget {
  const _MinutePreferenceTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text('$value minutes'),
      trailing: Wrap(
        spacing: 4,
        children: <Widget>[
          IconButton(
            tooltip: 'Decrease $title',
            onPressed: value <= 0 ? null : () => onChanged(value - 5),
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            tooltip: 'Increase $title',
            onPressed: () => onChanged(value + 5),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

Future<void> _showExportDialog(BuildContext context, WidgetRef ref) async {
  final export = await ref
      .read(planningControllerProvider.notifier)
      .exportLocalData();
  if (!context.mounted) {
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Local data export'),
      content: SizedBox(width: double.maxFinite, child: SelectableText(export)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}

Future<void> _showImportDialog(BuildContext context, WidgetRef ref) async {
  final controller = TextEditingController();
  String? error;
  await showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Import local data'),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 6,
          maxLines: 12,
          decoration: InputDecoration(
            labelText: 'Dayweft JSON',
            errorText: error,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref
                    .read(planningControllerProvider.notifier)
                    .importLocalData(controller.text);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } on FormatException catch (exception) {
                setState(() => error = exception.message);
              } on Object {
                setState(
                  () => error = 'This does not look like a Dayweft export.',
                );
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showShareDialog(BuildContext context, WidgetRef ref) async {
  final share = await ref
      .read(planningControllerProvider.notifier)
      .createLocalAvailabilityShare();
  if (!context.mounted) {
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Availability share'),
      content: SelectableText(
        'Type: ${share.shareType}\nToken hash: ${share.tokenHash}\nExpires: ${share.expiresAt.toIso8601String()}',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    ),
  );
}
