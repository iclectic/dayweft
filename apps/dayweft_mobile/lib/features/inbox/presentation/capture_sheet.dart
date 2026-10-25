import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaptureSheet extends ConsumerStatefulWidget {
  const CaptureSheet({this.brainDump = false, super.key});
  final bool brainDump;
  @override
  ConsumerState<CaptureSheet> createState() => _CaptureSheetState();
}

class _CaptureSheetState extends ConsumerState<CaptureSheet> {
  List<ParsedCapture> _captures = const [];
  String? _error;
  bool _saving = false;

  void _parse(String value) {
    try {
      final lines = (widget.brainDump ? value.split('\n') : [value])
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      if (lines.length > 200) {
        throw const FormatException('Review up to 200 tasks at a time.');
      }
      final captures = lines
          .map(ref.read(planningControllerProvider.notifier).parseCapture)
          .toList();
      setState(() {
        _captures = captures;
        _error = null;
      });
    } on FormatException catch (error) {
      setState(() {
        _captures = const [];
        _error = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.brainDump ? 'Brain Dump' : 'Quick capture',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            autofocus: true,
            minLines: widget.brainDump ? 4 : 1,
            maxLines: widget.brainDump ? 8 : 4,
            maxLength: 16000,
            onChanged: _parse,
            enabled: !_saving,
            decoration: InputDecoration(
              labelText: widget.brainDump ? 'One task per line' : 'Capture',
              hintText: 'Read tomorrow around 2pm for 30m #study',
              errorText: _error,
            ),
          ),
          if (_captures.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Review the parsed values. Edit the text above to correct them. Preferred times do not schedule a block.',
              ),
            ),
          for (var index = 0; index < _captures.length; index++)
            _CapturePreview(capture: _captures[index], number: index + 1),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving || _captures.isEmpty ? null : _save,
            child: Text(
              _saving ? 'Saving locally…' : 'Confirm and add to Inbox',
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(planningControllerProvider.notifier)
          .addConfirmedCaptures(_captures);
      if (mounted) Navigator.of(context).pop();
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error =
              'Capture could not be saved. Your text is still here; please try again.';
        });
      }
    }
  }
}

class _CapturePreview extends StatelessWidget {
  const _CapturePreview({required this.capture, required this.number});
  final ParsedCapture capture;
  final int number;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Parsed task $number for confirmation',
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(capture.title, style: Theme.of(context).textTheme.titleMedium),
          Text(
            'Estimate: ${capture.estimatedMinutes} min · Priority: ${capture.priority}',
          ),
          if (capture.category != null) Text('Category: ${capture.category}'),
          if (capture.energyRequired != null)
            Text('Energy: ${capture.energyRequired}'),
          if (capture.plannedDate != null)
            Text(
              'Preferred day: ${MaterialLocalizations.of(context).formatMediumDate(capture.plannedDate!)}',
            ),
          if (capture.startTime != null)
            Text(
              '${capture.approximateTime ? 'Around' : 'Preferred time'}: ${capture.startTime}${capture.endTime == null ? '' : '–${capture.endTime}'}',
            ),
          if (capture.deadline != null)
            Text(
              'Deadline: ${MaterialLocalizations.of(context).formatMediumDate(capture.deadline!)} ${TimeOfDay.fromDateTime(capture.deadline!).format(context)}',
            ),
          for (final warning in capture.warnings)
            Text(
              warning,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const Divider(),
        ],
      ),
    ),
  );
}
