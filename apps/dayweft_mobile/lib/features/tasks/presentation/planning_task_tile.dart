import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/tasks/presentation/actual_duration_dialog.dart';
import 'package:dayweft_mobile/features/tasks/presentation/task_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanningTaskTile extends ConsumerWidget {
  const PlanningTaskTile({required this.task, required this.blocks, super.key});
  final Task task;
  final List<TimeBlock> blocks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tile = ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => showTaskEditor(context, task),
      leading: Checkbox(
        value: task.status == 'completed',
        semanticLabel: 'Complete ${task.title}',
        onChanged: (_) => _run(
          context,
          () =>
              ref.read(planningControllerProvider.notifier).toggleTask(task.id),
        ),
      ),
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${task.estimatedMinutes} min estimated · ${task.priority}'),
          if (task.category != null) Text(task.category!),
          if (task.deadline != null)
            Text(
              'Due ${MaterialLocalizations.of(context).formatMediumDate(task.deadline!)} · ${TimeOfDay.fromDateTime(task.deadline!).format(context)}',
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
      trailing: PopupMenuButton<String>(
        tooltip: 'Task actions for ${task.title}',
        onSelected: (action) => _act(context, ref, action),
        itemBuilder: (_) => [
          const PopupMenuItem(value: 'edit', child: Text('Edit task')),
          if (task.blockId != null || task.status == 'deferred')
            const PopupMenuItem(value: 'inbox', child: Text('Return to Inbox')),
          for (final block in blocks.where((block) => block.id != task.blockId))
            PopupMenuItem(
              value: 'move:${block.id}',
              child: Text('Move to ${block.title}'),
            ),
          const PopupMenuItem(value: 'delete', child: Text('Delete task')),
        ],
      ),
    );
    return LongPressDraggable<Task>(
      data: task,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(task.title),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: tile),
      child: tile,
    );
  }

  Future<void> _act(BuildContext context, WidgetRef ref, String action) async {
    if (action == 'edit') {
      return showTaskEditor(context, task);
    }
    final controller = ref.read(planningControllerProvider.notifier);
    if (action == 'delete') {
      final messenger = ScaffoldMessenger.of(context);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete task?'),
          content: Text(task.title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
      String? revisionId;
      await _run(
        context,
        () async {
          revisionId = await controller.deleteTask(
            task.id,
            expectedVersion: task.localVersion,
          );
        },
        after: () {
          if (messenger.mounted) {
            messenger.showSnackBar(
              SnackBar(
                content: const Text('Task deleted'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () async {
                    try {
                      await controller.undoLastRevision(
                        expectedRevisionId: revisionId,
                      );
                    } on PlanningFailure catch (error) {
                      if (messenger.mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(error.message)),
                        );
                      }
                    }
                  },
                ),
              ),
            );
          }
        },
      );
    } else if (action == 'inbox') {
      await _run(
        context,
        () => controller.returnTaskToInbox(
          task.id,
          expectedVersion: task.localVersion,
        ),
      );
    } else if (action.startsWith('move:')) {
      await moveTaskIntoBlock(context, ref, task, action.substring(5));
    }
  }
}

Future<void> moveTaskIntoBlock(
  BuildContext context,
  WidgetRef ref,
  Task task,
  String blockId,
) => _run(context, () {
  final controller = ref.read(planningControllerProvider.notifier);
  return task.blockId == null
      ? controller.moveInboxTaskToBlock(taskId: task.id, blockId: blockId)
      : controller.movePlannedTaskToBlock(taskId: task.id, blockId: blockId);
});

Future<void> _run(
  BuildContext context,
  Future<void> Function() action, {
  VoidCallback? after,
}) async {
  try {
    await action();
    after?.call();
  } on Object catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error is PlanningFailure
                ? error.message
                : 'The change could not be saved. Please try again.',
          ),
        ),
      );
    }
  }
}
