import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/templates/application/template_library_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

Future<void> showCustomTemplateEditor(
  BuildContext context, {
  DayTemplate? template,
  List<TemplateBlock>? initialBlocks,
}) => Navigator.of(context).push<void>(
  MaterialPageRoute(
    builder: (_) =>
        CustomTemplateEditor(template: template, initialBlocks: initialBlocks),
  ),
);

class CustomTemplateEditor extends ConsumerStatefulWidget {
  const CustomTemplateEditor({this.template, this.initialBlocks, super.key});
  final DayTemplate? template;
  final List<TemplateBlock>? initialBlocks;
  @override
  ConsumerState<CustomTemplateEditor> createState() =>
      _CustomTemplateEditorState();
}

class _CustomTemplateEditorState extends ConsumerState<CustomTemplateEditor> {
  late final _name = TextEditingController(text: widget.template?.name);
  late final _blocks = [
    ...widget.template?.blocks ?? widget.initialBlocks ?? <TemplateBlock>[],
  ];
  bool _saving = false;
  String? _error;
  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.template == null ? 'Create template' : 'Edit template',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _name,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Template name'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Saves block names, categories, times and buffers on this device. Task details and notes are not copied. Nothing changes in your day until you preview and apply it.',
          ),
          const SizedBox(height: 8),
          const Text(
            'Patterns start at your working-day start and retain offsets from the first block. Review any shifted or omitted blocks in the preview.',
          ),
          const SizedBox(height: 16),
          if (_blocks.isEmpty)
            const Text('Add a block to create your reusable day pattern.'),
          for (var index = 0; index < _blocks.length; index++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _blocks[index].title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${_blocks[index].startTime}–${_blocks[index].endTime} · ${_blocks[index].blockType}',
                    ),
                    Wrap(
                      children: [
                        IconButton(
                          tooltip: 'Edit ${_blocks[index].title}',
                          onPressed: _saving ? null : () => _edit(index),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Remove ${_blocks[index].title} from draft',
                          onPressed: _saving
                              ? null
                              : () => setState(() => _blocks.removeAt(index)),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: _saving || _blocks.length >= 100
                ? null
                : () => _edit(null),
            icon: const Icon(Icons.add),
            label: const Text('Add template block'),
          ),
          if (_error != null)
            Semantics(
              liveRegion: true,
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving…' : 'Save template'),
          ),
        ),
      ),
    ),
  );

  Future<void> _edit(int? index) async {
    final result = await showDialog<TemplateBlock>(
      context: context,
      builder: (_) =>
          _TemplateBlockDialog(block: index == null ? null : _blocks[index]),
    );
    if (result != null && mounted) {
      setState(() {
        if (index == null) {
          _blocks.add(result);
        } else {
          _blocks[index] = result;
        }
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(templateLibraryProvider.notifier)
          .save(original: widget.template, name: _name.text, blocks: _blocks);
      if (mounted) Navigator.pop(context);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error is PlanningFailure
              ? error.message
              : 'The template could not be saved. Your day has not changed.';
        });
      }
    }
  }
}

class _TemplateBlockDialog extends StatefulWidget {
  const _TemplateBlockDialog({this.block});
  final TemplateBlock? block;
  @override
  State<_TemplateBlockDialog> createState() => _TemplateBlockDialogState();
}

class _TemplateBlockDialogState extends State<_TemplateBlockDialog> {
  late final _title = TextEditingController(text: widget.block?.title);
  late final _category = TextEditingController(text: widget.block?.category);
  late final _buffers = [
    TextEditingController(text: '${widget.block?.travelBufferMinutes ?? 0}'),
    TextEditingController(
      text: '${widget.block?.preparationBufferMinutes ?? 0}',
    ),
    TextEditingController(
      text: '${widget.block?.transitionBufferMinutes ?? 0}',
    ),
    TextEditingController(text: '${widget.block?.recoveryBufferMinutes ?? 0}'),
  ];
  late String _type = widget.block?.blockType ?? 'flexible';
  late TimeOfDay _start = _parse(widget.block?.startTime ?? '09:00');
  late TimeOfDay _end = _parse(widget.block?.endTime ?? '10:00');
  String? _error;
  TimeOfDay _parse(String value) => TimeOfDay(
    hour: int.parse(value.substring(0, 2)),
    minute: int.parse(value.substring(3)),
  );
  String _time(TimeOfDay value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  @override
  void dispose() {
    for (final controller in [_title, _category, ..._buffers]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.block == null ? 'Add template block' : 'Edit template block',
    ),
    content: SizedBox(
      width: 480,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _title,
              maxLength: 500,
              decoration: const InputDecoration(labelText: 'Block title'),
            ),
            TextField(
              controller: _category,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
              ),
            ),
            DropdownButtonFormField<String>(
              initialValue: _type,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Block type'),
              items: const [
                DropdownMenuItem(value: 'fixed', child: Text('Fixed')),
                DropdownMenuItem(value: 'flexible', child: Text('Flexible')),
                DropdownMenuItem(value: 'optional', child: Text('Optional')),
              ],
              onChanged: (value) => setState(() => _type = value!),
            ),
            OutlinedButton(
              onPressed: () => _pick(true),
              child: Text('Start ${_start.format(context)}'),
            ),
            OutlinedButton(
              onPressed: () => _pick(false),
              child: Text('End ${_end.format(context)}'),
            ),
            if (_end.hour * 60 + _end.minute < _start.hour * 60 + _start.minute)
              const Text('Ends on the following day.'),
            ExpansionTile(
              title: const Text('Reserved buffers'),
              children: [
                for (var index = 0; index < _buffers.length; index++)
                  TextField(
                    controller: _buffers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText:
                          '${const ['Travel', 'Preparation', 'Transition', 'Recovery'][index]} minutes',
                    ),
                  ),
              ],
            ),
            if (_error != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: _save, child: const Text('Use block')),
    ],
  );

  Future<void> _pick(bool start) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: start ? _start : _end,
    );
    if (picked != null && mounted) {
      setState(() {
        if (start) {
          _start = picked;
        } else {
          _end = picked;
        }
      });
    }
  }

  void _save() {
    final values = _buffers
        .map((controller) => int.tryParse(controller.text) ?? -1)
        .toList();
    final block = TemplateBlock(
      id: widget.block?.id ?? const Uuid().v4(),
      title: _title.text.trim(),
      category: _category.text.trim(),
      startTime: _time(_start),
      endTime: _time(_end),
      blockType: _type,
      travelBufferMinutes: values[0],
      preparationBufferMinutes: values[1],
      transitionBufferMinutes: values[2],
      recoveryBufferMinutes: values[3],
    );
    final issue = templateDefinitionIssue(
      DayTemplate(id: 'draft', name: 'Draft', blocks: [block]),
    );
    if (issue != null) {
      setState(() => _error = issue);
      return;
    }
    Navigator.pop(context, block);
  }
}
