import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/templates/application/template_library_controller.dart';
import 'package:dayweft_mobile/features/templates/data/template_recurrence_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurrenceEditor extends ConsumerStatefulWidget {
  const RecurrenceEditor({
    required this.template,
    required this.stored,
    required this.initialDay,
    super.key,
  });
  final DayTemplate template;
  final StoredTemplateRecurrence? stored;
  final DateTime initialDay;

  @override
  ConsumerState<RecurrenceEditor> createState() => _RecurrenceEditorState();
}

class _RecurrenceEditorState extends ConsumerState<RecurrenceEditor> {
  late Set<int> _weekdays;
  late DateTime _start;
  DateTime? _end;
  late Set<DateTime> _exceptions;
  bool _saving = false;
  String? _error;

  DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

  @override
  void initState() {
    super.initState();
    final rule = widget.stored?.rule;
    _weekdays = {...?rule?.weekdays};
    _start = _day(rule?.startsOn ?? widget.initialDay);
    _end = rule?.endsOn == null ? null : _day(rule!.endsOn!);
    _exceptions = {...?rule?.exceptions.map(_day)};
  }

  @override
  Widget build(BuildContext context) {
    final format = MaterialLocalizations.of(context).formatMediumDate;
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final exceptions = _exceptions.toList()..sort();
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(title: const Text('Weekly recurrence')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.template.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose days to suggest this template. Nothing is added automatically; preview each day before applying it.',
              ),
              const SizedBox(height: 16),
              const Text('Repeat on'),
              for (var i = 0; i < names.length; i++)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(names[i]),
                  value: _weekdays.contains(i + 1),
                  onChanged: _saving
                      ? null
                      : (value) => setState(() {
                          if (value == true) {
                            _weekdays.add(i + 1);
                          } else {
                            _weekdays.remove(i + 1);
                          }
                        }),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Starts on'),
                subtitle: Text(format(_start)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _saving
                    ? null
                    : () => _pickDate(_start, (date) => _start = date),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ends on'),
                subtitle: Text(_end == null ? 'No end date' : format(_end!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _saving
                    ? null
                    : () => _pickDate(_end ?? _start, (date) => _end = date),
              ),
              if (_end != null)
                TextButton(
                  onPressed: _saving ? null : () => setState(() => _end = null),
                  child: const Text('Remove end date'),
                ),
              const SizedBox(height: 16),
              Text(
                'Excluded dates',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Text(
                'These dates will not offer this recurrence. Existing plans stay unchanged.',
              ),
              for (final date in exceptions)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(format(date)),
                  trailing: IconButton(
                    tooltip: 'Remove exclusion for ${format(date)}',
                    onPressed: _saving
                        ? null
                        : () => setState(() => _exceptions.remove(date)),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: _saving
                    ? null
                    : () => _pickDate(
                        _day(widget.initialDay),
                        (date) => _exceptions.add(date),
                      ),
                icon: const Icon(Icons.event_busy),
                label: const Text('Exclude a date'),
              ),
              if (_error != null)
                Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving…' : 'Save recurrence'),
              ),
              if (widget.stored?.rule != null)
                TextButton(
                  onPressed: _saving ? null : _remove,
                  child: const Text('Remove recurrence'),
                ),
              TextButton(
                onPressed: _saving ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(
    DateTime initial,
    void Function(DateTime) update,
  ) async {
    final result = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1),
      lastDate: DateTime(9999, 12, 31),
    );
    if (result != null && mounted) setState(() => update(_day(result)));
  }

  Future<void> _save() async {
    if (_weekdays.isEmpty) {
      setState(() => _error = 'Choose at least one weekday.');
      return;
    }
    if (_end != null && _end!.isBefore(_start)) {
      setState(
        () => _error = 'The end date must not be before the start date.',
      );
      return;
    }
    await _write(
      TemplateRecurrence(
        weekdays: _weekdays,
        startsOn: _start,
        endsOn: _end,
        exceptions: _exceptions,
      ),
    );
  }

  Future<void> _remove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove recurrence?'),
        content: const Text('Existing plans and tasks stay in place.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) await _write(null);
  }

  Future<void> _write(TemplateRecurrence? rule) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(templateRecurrenceRepositoryProvider)
          .save(
            templateId: widget.template.id,
            expectedTemplateVersion: widget.template.version!,
            expectedVersion: widget.stored?.version,
            rule: rule,
          );
      if (mounted) Navigator.pop(context);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error is PlanningFailure
              ? error.message
              : 'The recurrence could not be saved. Please try again.';
        });
      }
    }
  }
}
