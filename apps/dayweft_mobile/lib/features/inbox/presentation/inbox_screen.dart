import 'package:dayweft_mobile/features/inbox/presentation/capture_sheet.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/tasks/presentation/planning_task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(planningControllerProvider);

    return state.when(
      data: (snapshot) => Scaffold(
        appBar: AppBar(
          title: const Text('Inbox'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Brain Dump',
              onPressed: () => _showBrainDump(context, ref),
              icon: const Icon(Icons.notes),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            FilledButton.icon(
              onPressed: () => _showCapture(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Quick capture'),
            ),
            const SizedBox(height: 16),
            if (snapshot.inboxTasks.isEmpty)
              const _EmptyInbox()
            else
              for (final task in snapshot.inboxTasks)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: PlanningTaskTile(
                      task: task,
                      blocks: snapshot.blocks,
                    ),
                  ),
                ),
          ],
        ),
      ),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.inbox_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Nothing waiting',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Capture thoughts here and schedule them when ready.'),
        ],
      ),
    );
  }
}

Future<void> _showCapture(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const CaptureSheet(),
    );

Future<void> _showBrainDump(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const CaptureSheet(brainDump: true),
    );
