import 'package:dayweft_domain/dayweft_domain.dart' as domain;
import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showTaskEditor(BuildContext context, Task task) => Navigator.of(
  context,
).push<void>(MaterialPageRoute(builder: (_) => TaskEditorScreen(task: task)));

class TaskEditorScreen extends ConsumerStatefulWidget {
  const TaskEditorScreen({required this.task, super.key});
  final Task task;

  @override
  ConsumerState<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends ConsumerState<TaskEditorScreen> {
  late final _title = TextEditingController(text: widget.task.title);
  late final _estimate = TextEditingController(
    text: '${widget.task.estimatedMinutes}',
  );
  late final _category = TextEditingController(text: widget.task.category);
  late final _notes = TextEditingController(text: widget.task.notes);
  late final _minimum = TextEditingController(
    text: '${widget.task.minimumUsefulMinutes}',
  );
  late domain.TaskPriority _priority = domain.TaskPriority.values.byName(
    widget.task.priority,
  );
  late domain.EnergyLevel? _energy = taskDetailsFor(widget.task).energyRequired;
  late domain.CognitiveLoad? _load = taskDetailsFor(widget.task).cognitiveLoad;
  late DateTime? _deadline = widget.task.deadline;
  late bool _canSplit = widget.task.canSplit;
  late final Set<String> _dependencies = taskDependencyIds(widget.task).toSet();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [_title, _estimate, _category, _notes, _minimum]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final candidates = ref.watch(taskCandidatesProvider);
    final localizations = MaterialLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit task')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _title,
            maxLength: 500,
            decoration: const InputDecoration(labelText: 'Task title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _estimate,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Estimated minutes'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<domain.TaskPriority>(
            initialValue: _priority,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: [
              for (final value in domain.TaskPriority.values)
                DropdownMenuItem(value: value, child: Text(_label(value.name))),
            ],
            onChanged: (value) => setState(() => _priority = value!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _category,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Category (optional)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            minLines: 3,
            maxLines: 8,
            maxLength: 20000,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Deadline'),
            subtitle: Text(
              _deadline == null
                  ? 'No deadline'
                  : '${localizations.formatMediumDate(_deadline!)} · ${TimeOfDay.fromDateTime(_deadline!).format(context)}',
            ),
            onTap: _pickDeadline,
            trailing: _deadline == null
                ? const Icon(Icons.event_outlined)
                : IconButton(
                    tooltip: 'Clear deadline',
                    onPressed: () => setState(() => _deadline = null),
                    icon: const Icon(Icons.close),
                  ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<domain.EnergyLevel>(
            initialValue: _energy,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Energy requirement (optional)',
            ),
            hint: const Text('Not specified'),
            items: [
              const DropdownMenuItem(child: Text('Not specified')),
              for (final value in domain.EnergyLevel.values)
                DropdownMenuItem(value: value, child: Text(_label(value.name))),
            ],
            onChanged: (value) => setState(() => _energy = value),
          ),
          const SizedBox(height: 8),
          const Text(
            'Optional planning information. Leave this unset if you prefer.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<domain.CognitiveLoad>(
            initialValue: _load,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Cognitive load (optional)',
            ),
            hint: const Text('Not specified'),
            items: [
              const DropdownMenuItem(child: Text('Not specified')),
              for (final value in domain.CognitiveLoad.values)
                DropdownMenuItem(value: value, child: Text(_label(value.name))),
            ],
            onChanged: (value) => setState(() => _load = value),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Allow splitting'),
            subtitle: const Text('Work can use several useful fragments.'),
            value: _canSplit,
            onChanged: (value) => setState(() => _canSplit = value),
          ),
          if (_canSplit)
            TextField(
              controller: _minimum,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minimum useful fragment (minutes)',
              ),
            ),
          const SizedBox(height: 12),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: const Text('Predecessor tasks'),
            subtitle: Text(
              '${_dependencies.length} selected · must finish first',
            ),
            children: [
              candidates.when(
                data: (tasks) => Column(
                  children: [
                    if (tasks.every((task) => task.id == widget.task.id))
                      const Text('No other tasks yet.'),
                    for (final task in tasks.where(
                      (task) => task.id != widget.task.id,
                    ))
                      CheckboxListTile(
                        title: Text(task.title),
                        subtitle: Text(
                          task.status == 'completed'
                              ? 'Completed'
                              : 'Must finish first',
                        ),
                        value: _dependencies.contains(task.id),
                        onChanged: (selected) => setState(() {
                          if (selected!) {
                            _dependencies.add(task.id);
                          } else {
                            _dependencies.remove(task.id);
                          }
                        }),
                      ),
                  ],
                ),
                error: (_, _) => TextButton(
                  onPressed: () => ref.invalidate(taskCandidatesProvider),
                  child: const Text('Retry loading tasks'),
                ),
                loading: () => const LinearProgressIndicator(),
              ),
            ],
          ),
          if (_error != null)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving…' : 'Save task'),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100, 12, 31),
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: _deadline == null
          ? const TimeOfDay(hour: 17, minute: 0)
          : TimeOfDay.fromDateTime(_deadline!),
    );
    if (time != null && mounted) {
      setState(
        () => _deadline = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ),
      );
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(planningControllerProvider.notifier)
          .updateTask(
            taskId: widget.task.id,
            expectedVersion: widget.task.localVersion,
            details: domain.TaskDetails(
              title: _title.text,
              estimatedMinutes: int.tryParse(_estimate.text) ?? 0,
              priority: _priority,
              category: _category.text,
              notes: _notes.text,
              deadline: _deadline,
              energyRequired: _energy,
              cognitiveLoad: _load,
              canSplit: _canSplit,
              minimumUsefulMinutes: int.tryParse(_minimum.text) ?? 0,
              dependencyIds: _dependencies.toList(),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error is PlanningFailure
              ? error.message
              : 'The task could not be saved. Your changes are still here. Try again.';
        });
      }
    }
  }
}

String _label(String value) => '${value[0].toUpperCase()}${value.substring(1)}';
