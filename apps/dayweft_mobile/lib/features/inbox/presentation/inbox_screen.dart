import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
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
                    subtitle: Text(
                      '${task.estimatedMinutes} min • ${task.priority}',
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

Future<void> _showCapture(BuildContext context, WidgetRef ref) async {
  final textController = TextEditingController();
  ParsedCapture? parsed;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              MediaQuery.viewInsetsOf(context).bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Capture',
                    hintText: 'Urgent: call Sam for 20 min',
                  ),
                  onChanged: (value) => setState(
                    () => parsed = value.trim().isEmpty
                        ? null
                        : ref
                              .read(planningControllerProvider.notifier)
                              .parseCapture(value),
                  ),
                ),
                const SizedBox(height: 12),
                if (parsed != null) _ParsedPreview(parsed: parsed!),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: parsed == null
                      ? null
                      : () {
                          ref
                              .read(planningControllerProvider.notifier)
                              .addInboxTask(parsed!.title);
                          Navigator.of(context).pop();
                        },
                  child: const Text('Confirm and add to Inbox'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> _showBrainDump(BuildContext context, WidgetRef ref) async {
  final textController = TextEditingController();
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: textController,
            autofocus: true,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Brain Dump',
              helperText: 'One task per line.',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ref
                  .read(planningControllerProvider.notifier)
                  .addInboxTasks(
                    textController.text
                        .split('\n')
                        .map((line) => line.trim())
                        .where((line) => line.isNotEmpty)
                        .toList(),
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Add lines'),
          ),
        ],
      ),
    ),
  );
}

class _ParsedPreview extends StatelessWidget {
  const _ParsedPreview({required this.parsed});

  final ParsedCapture parsed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Parsed values for confirmation',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Parsed values',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text('Title: ${parsed.title}'),
              Text('Estimate: ${parsed.estimatedMinutes} min'),
              Text('Priority: ${parsed.priority}'),
              if (parsed.hasSchedule)
                Text('Time: ${parsed.startTime}-${parsed.endTime}'),
            ],
          ),
        ),
      ),
    );
  }
}
