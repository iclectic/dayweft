import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showActualDurationDialog(
  BuildContext context,
  WidgetRef ref, {
  required String taskId,
  int? previousMinutes,
}) => showDialog<void>(
  context: context,
  builder: (_) =>
      _ActualDurationDialog(taskId: taskId, previousMinutes: previousMinutes),
);

class _ActualDurationDialog extends ConsumerStatefulWidget {
  const _ActualDurationDialog({required this.taskId, this.previousMinutes});
  final String taskId;
  final int? previousMinutes;

  @override
  ConsumerState<_ActualDurationDialog> createState() =>
      _ActualDurationDialogState();
}

class _ActualDurationDialogState extends ConsumerState<_ActualDurationDialog> {
  late final TextEditingController _input;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _input = TextEditingController(
      text: widget.previousMinutes?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Record actual time'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter active work time, excluding pauses. An estimate is never used as a measurement.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _input,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Actual minutes',
              errorText: _error,
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        child: Text(_saving ? 'Saving…' : 'Save actual time'),
      ),
    ],
  );

  Future<void> _save() async {
    final minutes = int.tryParse(_input.text.trim());
    if (minutes == null || minutes <= 0) {
      setState(() => _error = 'Enter a positive number of minutes.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(planningControllerProvider.notifier)
          .recordTaskActualDuration(widget.taskId, actualMinutes: minutes);
      if (mounted) Navigator.pop(context);
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'The measurement could not be saved. Please try again.';
        });
      }
    }
  }
}
