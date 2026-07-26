import 'package:dayweft_design_system/dayweft_design_system.dart';
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodayTimelineScreen extends ConsumerWidget {
  const TodayTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(planningControllerProvider);

    return state.when(
      data: (snapshot) => RefreshIndicator(
        onRefresh: () => ref.read(planningControllerProvider.notifier).reload(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar.large(
              title: const Text('Today Timeline'),
              actions: <Widget>[
                IconButton(
                  tooltip: 'Undo last change',
                  onPressed: snapshot.revisions.isEmpty
                      ? null
                      : () => ref
                            .read(planningControllerProvider.notifier)
                            .undoLastRevision(),
                  icon: const Icon(Icons.undo),
                ),
                IconButton(
                  tooltip: 'Apply template',
                  onPressed: () => _showTemplatePreview(context, ref),
                  icon: const Icon(Icons.view_timeline_outlined),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList.list(
                children: <Widget>[
                  Text(
                    'A day that adapts with you.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (snapshot.preferences.sampleDataEnabled)
                    _SampleDataBanner(
                      onRemove: () => ref
                          .read(planningControllerProvider.notifier)
                          .removeSampleData(),
                    ),
                  if (snapshot.blocks.isEmpty)
                    const _EmptyTimeline()
                  else
                    for (final block in snapshot.blocks) ...<Widget>[
                      _TimelineBlock(block: block, snapshot: snapshot),
                      const ThreadDivider(),
                    ],
                  FilledButton.icon(
                    onPressed: () => _showAddBlockSheet(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add block'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _showRealityCheck(context, snapshot),
                    icon: const Icon(Icons.fact_check_outlined),
                    label: const Text('Reality Check'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _showRevisionHistory(context, snapshot),
                    icon: const Icon(Icons.history),
                    label: Text(
                      'Revision history (${snapshot.revisions.length})',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => _FailureState(message: error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _TimelineBlock extends ConsumerWidget {
  const _TimelineBlock({required this.block, required this.snapshot});

  final TimeBlock block;
  final LocalDaySnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = snapshot.tasksForBlock(block.id);
    return Semantics(
      label: '${block.blockType} block, ${block.title}, ${tasks.length} tasks',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(_iconForBlockType(block.blockType)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          block.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${_formatTime(block.startsAt)}-${_formatTime(block.endsAt)}'
                          ' • ${block.blockType}',
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Move block earlier',
                    onPressed: () => ref
                        .read(planningControllerProvider.notifier)
                        .moveBlock(blockId: block.id, direction: -1),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  IconButton(
                    tooltip: 'Move block later',
                    onPressed: () => ref
                        .read(planningControllerProvider.notifier)
                        .moveBlock(blockId: block.id, direction: 1),
                    icon: const Icon(Icons.arrow_downward),
                  ),
                  IconButton(
                    tooltip: 'Edit or resize block',
                    onPressed: () => _showEditBlockSheet(context, ref, block),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: 'Delete block',
                    onPressed: () => ref
                        .read(planningControllerProvider.notifier)
                        .deleteBlock(block.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (tasks.isEmpty)
                Text(
                  'No tasks in this block yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else
                for (final task in tasks)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
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
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Move task',
                      icon: const Icon(Icons.drive_file_move_outline),
                      onSelected: (blockId) => ref
                          .read(planningControllerProvider.notifier)
                          .movePlannedTaskToBlock(
                            taskId: task.id,
                            blockId: blockId,
                          ),
                      itemBuilder: (context) => snapshot.blocks
                          .where((candidate) => candidate.id != block.id)
                          .map(
                            (candidate) => PopupMenuItem<String>(
                              value: candidate.id,
                              child: Text(candidate.title),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _showAddTaskSheet(context, ref, block),
                  icon: const Icon(Icons.add_task),
                  label: const Text('Add task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SampleDataBanner extends StatelessWidget {
  const _SampleDataBanner({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialBanner(
        content: const Text('Sample data is installed and can be removed.'),
        leading: const Icon(Icons.info_outline),
        actions: <Widget>[
          TextButton(onPressed: onRemove, child: const Text('Remove')),
        ],
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.view_timeline_outlined,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text('Start planning', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Add a block or apply a template.'),
        ],
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: const EdgeInsets.all(24), child: Text(message)),
    );
  }
}

Future<void> _showAddBlockSheet(BuildContext context, WidgetRef ref) async {
  final titleController = TextEditingController();
  var type = 'flexible';
  var start = const TimeOfDay(hour: 9, minute: 0);
  var end = const TimeOfDay(hour: 10, minute: 0);

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
              children: <Widget>[
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Block title'),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment(value: 'fixed', label: Text('Fixed')),
                    ButtonSegment(value: 'flexible', label: Text('Flexible')),
                    ButtonSegment(value: 'optional', label: Text('Optional')),
                  ],
                  selected: <String>{type},
                  onSelectionChanged: (values) =>
                      setState(() => type = values.first),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: start,
                          );
                          if (picked != null) {
                            setState(() => start = picked);
                          }
                        },
                        child: Text('Start ${start.format(context)}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: end,
                          );
                          if (picked != null) {
                            setState(() => end = picked);
                          }
                        },
                        child: Text('End ${end.format(context)}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) {
                      return;
                    }
                    ref
                        .read(planningControllerProvider.notifier)
                        .addBlock(
                          title: title,
                          startsAt: _todayAt(start),
                          endsAt: _todayAt(end),
                          blockType: type,
                        );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save block'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> _showEditBlockSheet(
  BuildContext context,
  WidgetRef ref,
  TimeBlock block,
) async {
  final titleController = TextEditingController(text: block.title);
  var type = block.blockType;
  var start = TimeOfDay.fromDateTime(block.startsAt);
  var end = TimeOfDay.fromDateTime(block.endsAt);

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
              children: <Widget>[
                TextField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Block title'),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment(value: 'fixed', label: Text('Fixed')),
                    ButtonSegment(value: 'flexible', label: Text('Flexible')),
                    ButtonSegment(value: 'optional', label: Text('Optional')),
                  ],
                  selected: <String>{type},
                  onSelectionChanged: (values) =>
                      setState(() => type = values.first),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: start,
                          );
                          if (picked != null) {
                            setState(() => start = picked);
                          }
                        },
                        child: Text('Start ${start.format(context)}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: end,
                          );
                          if (picked != null) {
                            setState(() => end = picked);
                          }
                        },
                        child: Text('End ${end.format(context)}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    if (title.isEmpty) {
                      return;
                    }
                    ref
                        .read(planningControllerProvider.notifier)
                        .updateBlock(
                          blockId: block.id,
                          title: title,
                          startsAt: _todayAt(start),
                          endsAt: _todayAt(end),
                          blockType: type,
                        );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save changes'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> _showAddTaskSheet(
  BuildContext context,
  WidgetRef ref,
  TimeBlock block,
) async {
  final controller = TextEditingController();
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
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
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Task',
                helperText:
                    'Basic parsing understands durations like "45 min".',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final parsed = ref
                    .read(planningControllerProvider.notifier)
                    .parseCapture(controller.text);
                if (parsed.title.isEmpty) {
                  return;
                }
                ref
                    .read(planningControllerProvider.notifier)
                    .addTaskToBlock(
                      blockId: block.id,
                      title: parsed.title,
                      estimatedMinutes: parsed.estimatedMinutes,
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Add task'),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _showTemplatePreview(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: <Widget>[
          Text('Templates', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Applying a template adds blocks after preview. Existing commitments stay intact.',
          ),
          const SizedBox(height: 16),
          for (final template in dayweftTemplates)
            Card(
              child: ListTile(
                title: Text(template.name),
                subtitle: Text('${template.blocks.length} blocks'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTemplateBlocks(context, ref, template),
              ),
            ),
        ],
      );
    },
  );
}

Future<void> _showTemplateBlocks(
  BuildContext context,
  WidgetRef ref,
  DayTemplate template,
) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(template.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final block in template.blocks)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(block.title),
              subtitle: Text(
                '${block.startTime}-${block.endTime} • ${block.blockType}',
              ),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            ref
                .read(planningControllerProvider.notifier)
                .applyTemplate(template);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    ),
  );
}

void _showRealityCheck(BuildContext context, LocalDaySnapshot snapshot) {
  final observations = <String>[];
  for (var index = 1; index < snapshot.blocks.length; index += 1) {
    final previous = snapshot.blocks[index - 1];
    final current = snapshot.blocks[index];
    if (previous.endsAt.isAfter(current.startsAt)) {
      observations.add('${previous.title} overlaps ${current.title}.');
    }
    final gap = current.startsAt.difference(previous.endsAt);
    if (!gap.isNegative && gap.inMinutes < 10) {
      observations.add(
        '${current.title} has only ${gap.inMinutes} minutes of transition time.',
      );
    }
  }
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reality Check'),
      content: observations.isEmpty
          ? const Text('No local timeline issues found in this scaffold check.')
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: observations
                  .map((observation) => ListTile(title: Text(observation)))
                  .toList(),
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

void _showRevisionHistory(BuildContext context, LocalDaySnapshot snapshot) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: <Widget>[
        Text('Revision history', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (snapshot.revisions.isEmpty)
          const Text('No revisions yet.')
        else
          for (final revision in snapshot.revisions)
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(revision.reason),
              subtitle: Text('Revision ${revision.revisionNumber}'),
            ),
      ],
    ),
  );
}

IconData _iconForBlockType(String blockType) {
  return switch (blockType) {
    'fixed' => Icons.lock_clock,
    'optional' => Icons.low_priority,
    _ => Icons.schedule,
  };
}

DateTime _todayAt(TimeOfDay value) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, value.hour, value.minute);
}

String _formatTime(DateTime value) {
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}
