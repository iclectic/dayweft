import 'package:dayweft_mobile/features/inbox/presentation/capture_sheet.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/tasks/presentation/actual_duration_dialog.dart';
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
                  child: ListTile(
                    leading: Checkbox(
                      value: task.status == 'completed',
                      onChanged: (_) => ref
                          .read(planningControllerProvider.notifier)
                          .toggleTask(task.id),
                    ),
                    title: Text(task.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${task.estimatedMinutes} min estimated • ${task.priority}',
                        ),
                        if (task.status == 'completed')
                          TextButton(
                            onPressed: () => showActualDurationDialog(
                              context,
                              ref,
                              taskId: task.id,
                              previousMinutes: task.actualMinutes,
                            ),
                            child: Text(
                              task.actualMinutes == null
                                  ? 'Record actual time'
                                  : '${task.actualMinutes} min actual · Edit',
                            ),
                          ),
                      ],
                    ),
                    trailing: snapshot.blocks.isEmpty
                        ? null
                        : PopupMenuButton<String>(
                            tooltip: 'Move to block',
                            icon: const Icon(Icons.drive_file_move_outline),
                            onSelected: (blockId) => ref
                                .read(planningControllerProvider.notifier)
                                .moveInboxTaskToBlock(
                                  taskId: task.id,
                                  blockId: blockId,
                                ),
                            itemBuilder: (context) => snapshot.blocks
                                .map(
                                  (block) => PopupMenuItem<String>(
                                    value: block.id,
                                    child: Text(block.title),
                                  ),
                                )
                                .toList(),
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
