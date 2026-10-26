import 'package:dayweft_mobile/core/database/dayweft_database.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showBlockEditor(BuildContext context, {TimeBlock? block}) =>
    Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => BlockEditorScreen(block: block)),
    );

class BlockEditorScreen extends ConsumerStatefulWidget {
  const BlockEditorScreen({this.block, super.key});
  final TimeBlock? block;

  @override
  ConsumerState<BlockEditorScreen> createState() => _BlockEditorScreenState();
}

class _BlockEditorScreenState extends ConsumerState<BlockEditorScreen> {
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
  late TimeOfDay _start = widget.block == null
      ? const TimeOfDay(hour: 9, minute: 0)
      : TimeOfDay.fromDateTime(widget.block!.startsAt);
  late TimeOfDay _end = widget.block == null
      ? const TimeOfDay(hour: 10, minute: 0)
      : TimeOfDay.fromDateTime(widget.block!.endsAt);
  late bool _nextDay =
      widget.block != null &&
      !DateUtils.isSameDay(widget.block!.startsAt, widget.block!.endsAt);
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    for (final controller in [_title, _category, ..._buffers]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.block == null ? 'Add block' : 'Edit or resize block'),
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          controller: _title,
          maxLength: 500,
          decoration: const InputDecoration(labelText: 'Block title'),
        ),
        const SizedBox(height: 16),
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
        if (_type == 'fixed')
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Recovery suggestions keep this commitment in place.'),
          ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => _pickTime(true),
          child: Text('Start ${_start.format(context)}'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _pickTime(false),
          child: Text('End ${_end.format(context)}'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ends the next day'),
          value: _nextDay,
          onChanged: (value) => setState(() => _nextDay = value),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _category,
          maxLength: 80,
          decoration: const InputDecoration(labelText: 'Category (optional)'),
        ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: const Text('Travel, preparation and recovery'),
          subtitle: const Text('Reserve time inside the block'),
          children: [
            for (var index = 0; index < _buffers.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _buffers[index],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        '${const ['Travel', 'Preparation', 'Transition', 'Recovery'][index]} minutes',
                  ),
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
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(
            _saving
                ? 'Saving…'
                : widget.block == null
                ? 'Save block'
                : 'Save changes',
          ),
        ),
      ),
    ),
  );

  Future<void> _pickTime(bool start) async {
    final result = await showTimePicker(
      context: context,
      initialTime: start ? _start : _end,
    );
    if (result != null && mounted) {
      setState(() {
        if (start) {
          _start = result;
        } else {
          _end = result;
        }
      });
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final day =
        widget.block?.startsAt ??
        ref.read(planningControllerProvider).value?.plan.day ??
        DateTime.now();
    final start = DateTime(
      day.year,
      day.month,
      day.day,
      _start.hour,
      _start.minute,
    );
    final end = DateTime(
      day.year,
      day.month,
      day.day + (_nextDay ? 1 : 0),
      _end.hour,
      _end.minute,
    );
    final buffers = _buffers
        .map((controller) => int.tryParse(controller.text) ?? -1)
        .toList();
    try {
      final controller = ref.read(planningControllerProvider.notifier);
      if (widget.block == null) {
        await controller.addBlock(
          title: _title.text.trim(),
          startsAt: start,
          endsAt: end,
          blockType: _type,
          category: _category.text.trim(),
          travelBufferMinutes: buffers[0],
          preparationBufferMinutes: buffers[1],
          transitionBufferMinutes: buffers[2],
          recoveryBufferMinutes: buffers[3],
        );
      } else {
        await controller.updateBlock(
          blockId: widget.block!.id,
          expectedVersion: widget.block!.localVersion,
          title: _title.text.trim(),
          startsAt: start,
          endsAt: end,
          blockType: _type,
          category: _category.text.trim(),
          travelBufferMinutes: buffers[0],
          preparationBufferMinutes: buffers[1],
          transitionBufferMinutes: buffers[2],
          recoveryBufferMinutes: buffers[3],
        );
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error is PlanningFailure
              ? error.message
              : 'The block could not be saved. Your changes are still here.';
        });
      }
    }
  }
}
