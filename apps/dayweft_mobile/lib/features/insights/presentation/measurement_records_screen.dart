import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeasurementRecordsScreen extends ConsumerWidget {
  const MeasurementRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(planningControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Measurement records')),
      body: FutureBuilder<List<EstimationRecord>>(
        future: ref
            .read(localPlanningRepositoryProvider)
            .loadEstimationRecords(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Records could not be loaded. Please try again.'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final records = snapshot.requireData;
          if (records.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No measured work yet. Complete a task and record its actual time to build evidence.',
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${record.estimatedMinutes} min estimated → ${record.actualMinutes} min actual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${record.category ?? 'Uncategorised'} · ${record.timeOfDay} · ${record.measurementSource == 'legacy_unknown' ? 'Legacy evidence: not used' : 'Manually measured'}',
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton.icon(
                          onPressed: () => ref
                              .read(planningControllerProvider.notifier)
                              .excludeEstimationRecord(
                                record.id,
                                excluded: !record.excluded,
                              ),
                          icon: Icon(
                            record.excluded
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                          ),
                          label: Text(record.excluded ? 'Include' : 'Exclude'),
                        ),
                        TextButton.icon(
                          onPressed: () => ref
                              .read(planningControllerProvider.notifier)
                              .deleteEstimationRecord(record.id),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete record'),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
