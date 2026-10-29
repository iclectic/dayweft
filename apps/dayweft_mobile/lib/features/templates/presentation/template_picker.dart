import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/templates/data/starter_templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showTemplatePicker(
  BuildContext context,
) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) => Consumer(
    builder: (context, ref, _) => SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.8,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Templates', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text(
              'Preview blocks fitted around your commitments and working hours. Choose what to add; existing work stays in place.',
            ),
            for (final template in dayweftTemplates)
              ListTile(
                title: Text(template.name),
                subtitle: Text('${template.blocks.length} blocks'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  try {
                    final preview = await ref
                        .read(planningControllerProvider.notifier)
                        .previewTemplate(template);
                    if (!context.mounted) return;
                    final applied = await showDialog<bool>(
                      context: context,
                      builder: (_) => TemplatePreviewDialog(preview: preview),
                    );
                    if (applied == true && context.mounted) {
                      Navigator.pop(context);
                    }
                  } on Object catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error is PlanningFailure
                                ? error.message
                                : 'The template could not be opened. Try again.',
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
          ],
        ),
      ),
    ),
  ),
);

class TemplatePreviewDialog extends ConsumerStatefulWidget {
  const TemplatePreviewDialog({required this.preview, super.key});
  final TemplatePreview preview;
  @override
  ConsumerState<TemplatePreviewDialog> createState() =>
      _TemplatePreviewDialogState();
}

class _TemplatePreviewDialogState extends ConsumerState<TemplatePreviewDialog> {
  late final _selected = widget.preview.placements
      .map((item) => item.index)
      .toSet();
  bool _saving = false;
  String? _error;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: AlertDialog(
      title: Text(widget.preview.template.name),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Only selected blocks will be added. Nothing has changed yet.',
              ),
              for (final item in widget.preview.placements)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.block.title),
                  subtitle: Text(
                    '${MaterialLocalizations.of(context).formatCompactDate(item.window.start)} · '
                    '${TimeOfDay.fromDateTime(item.window.start).format(context)}–'
                    '${TimeOfDay.fromDateTime(item.window.end).format(context)}'
                    '${DateUtils.isSameDay(item.window.start, item.window.end) ? '' : ' (ends next day)'} · ${item.block.blockType}',
                  ),
                  value: _selected.contains(item.index),
                  onChanged: _saving
                      ? null
                      : (value) => setState(() {
                          if (value == true) {
                            _selected.add(item.index);
                          } else {
                            _selected.remove(item.index);
                          }
                        }),
                ),
              for (final item in widget.preview.omissions)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.info_outline),
                  title: Text(item.title),
                  subtitle: Text(item.reason),
                ),
              if (_error != null)
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
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
        FilledButton(
          onPressed: _saving || _selected.isEmpty ? null : _apply,
          child: Text(_saving ? 'Saving…' : 'Add selected blocks'),
        ),
      ],
    ),
  );

  Future<void> _apply() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(planningControllerProvider.notifier)
          .applyTemplatePreview(widget.preview, selectedIndices: _selected);
      if (mounted) Navigator.pop(context, true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error is PlanningFailure
              ? error.message
              : 'The blocks could not be saved. Your existing plan has not been replaced.';
        });
      }
    }
  }
}
