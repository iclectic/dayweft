import 'package:dayweft_mobile/features/insights/presentation/measurement_records_screen.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourRhythmScreen extends ConsumerWidget {
  const YourRhythmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planning = ref.watch(planningControllerProvider);
    final energyEnabled = planning.value?.preferences.energyEnabled ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Your Rhythm')),
      body: FutureBuilder(
        future: ref
            .watch(planningControllerProvider.notifier)
            .loadRhythmSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final summary = snapshot.requireData;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              if (summary.insufficientDataWarning != null)
                MaterialBanner(
                  content: Text(summary.insufficientDataWarning!),
                  leading: const Icon(Icons.info_outline),
                  actions: const <Widget>[SizedBox.shrink()],
                ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('Measurement records'),
                subtitle: const Text(
                  'Inspect, exclude or delete individual observations',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => const MeasurementRecordsScreen(),
                  ),
                ),
              ),
              _MetricTile(
                icon: Icons.timer_outlined,
                title: 'Estimate evidence',
                value: '${summary.estimationSampleSize} record(s)',
                subtitle: summary.medianEstimateFactor == null
                    ? 'No personal factor shown yet.'
                    : 'Median actual/estimate ratio: ×${summary.medianEstimateFactor!.toStringAsFixed(2)}. '
                          'Middle half: ×${summary.estimateLowerQuartile!.toStringAsFixed(2)}–×${summary.estimateUpperQuartile!.toStringAsFixed(2)}. This spread is not a prediction.',
              ),
              _MetricTile(
                icon: Icons.low_priority,
                title: 'Frequently deferred work',
                value: '${summary.deferredTaskCount} task(s)',
                subtitle:
                    'Deferred work is counted locally without scoring you.',
              ),
              _MetricTile(
                icon: Icons.auto_fix_high_outlined,
                title: 'Successful reweaves',
                value: '${summary.successfulReweaves}',
                subtitle: 'Confirmed Reweave My Day changes.',
              ),
              _MetricTile(
                icon: Icons.hourglass_bottom,
                title: 'Quiet Focus',
                value: '${summary.totalFocusMinutes} minutes',
                subtitle: '${summary.focusSessionCount} completed session(s).',
              ),
              _MetricTile(
                icon: Icons.bolt_outlined,
                title: 'Latest energy check-in',
                value: summary.latestEnergyLevel ?? 'Not set',
                subtitle: 'Energy data is optional and local.',
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Enable energy check-ins'),
                value: energyEnabled,
                subtitle: const Text(
                  'Optional. Disabling stops collection and use; delete learning history to remove stored records.',
                ),
                onChanged: (enabled) => ref
                    .read(planningControllerProvider.notifier)
                    .setEnergyEnabled(enabled),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final choice in const {
                    'low': 'Low',
                    'steady': 'Steady',
                    'high': 'High',
                  }.entries)
                    ChoiceChip(
                      label: Text(choice.value),
                      selected:
                          energyEnabled &&
                          summary.latestEnergyLevel == choice.key,
                      onSelected: !energyEnabled
                          ? null
                          : (_) => ref
                                .read(planningControllerProvider.notifier)
                                .recordEnergyCheckIn(choice.key),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => ref
                    .read(planningControllerProvider.notifier)
                    .deleteLearningHistory(),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete learning history'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(subtitle),
        ],
      ),
    );
  }
}
