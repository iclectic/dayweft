import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/data_management/domain/day_import.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/planning/application/planning_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showDayImportDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const DayImportDialog());

class DayImportDialog extends ConsumerStatefulWidget {
  const DayImportDialog({super.key});
  @override
  ConsumerState<DayImportDialog> createState() => _DayImportDialogState();
}

class _DayImportDialogState extends ConsumerState<DayImportDialog> {
  final _text = TextEditingController();
  DayImport? _preview;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: Text(preview == null ? 'Import a day' : 'Review day import'),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (preview == null) ...[
                  const Text(
                    'Day exports can contain private task titles and notes. Paste only a file you trust. This merges one day; it is not a complete device backup.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _text,
                    minLines: 4,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Dayweft JSON',
                    ),
                  ),
                ] else ...[
                  Text(
                    'Add ${preview.blocks.length} blocks and ${preview.tasks.length} tasks to '
                    '${MaterialLocalizations.of(context).formatFullDate(preview.day)}.',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Existing work and preferences stay in place. Imported times are preserved; any overlapping commitments will need review in Reality Check. You can undo this batch from that day’s history.',
                  ),
                ],
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (preview != null)
            TextButton(
              onPressed: _saving
                  ? null
                  : () => setState(() {
                      _preview = null;
                      _error = null;
                    }),
              child: const Text('Edit JSON'),
            ),
          FilledButton(
            onPressed: _saving
                ? null
                : preview == null
                ? _review
                : _apply,
            child: Text(
              _saving
                  ? 'Importing…'
                  : preview == null
                  ? 'Review import'
                  : 'Confirm import',
            ),
          ),
        ],
      ),
    );
  }

  void _review() {
    try {
      final document = ref
          .read(planningControllerProvider.notifier)
          .previewLocalImport(_text.text);
      setState(() {
        _preview = document;
        _error = null;
      });
    } on Object catch (error) {
      _failed(error);
    }
  }

  Future<void> _apply() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(planningControllerProvider.notifier)
          .importLocalData(_text.text);
      if (mounted) {
        ref.read(planningDateProvider.notifier).select(_preview!.day);
        Navigator.pop(context);
      }
    } on Object catch (error) {
      if (mounted) _failed(error);
    }
  }

  void _failed(Object error) => setState(() {
    _saving = false;
    _error = error is PlanningFailure
        ? error.message
        : 'The day could not be imported. Check the file and try again.';
  });
}
