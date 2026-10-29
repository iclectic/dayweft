import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/templates/application/template_library_controller.dart';
import 'package:dayweft_mobile/features/templates/data/starter_templates.dart';
import 'package:dayweft_mobile/features/templates/presentation/custom_template_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showTemplatePicker(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const _TemplateLibrary(),
    );

class _TemplateLibrary extends ConsumerStatefulWidget {
  const _TemplateLibrary();
  @override
  ConsumerState<_TemplateLibrary> createState() => _TemplateLibraryState();
}

class _TemplateLibraryState extends ConsumerState<_TemplateLibrary> {
  bool _busy = false;
  String? _error;
  @override
  Widget build(BuildContext context) => SafeArea(
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
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => showCustomTemplateEditor(context),
                icon: const Icon(Icons.add),
                label: const Text('Create template'),
              ),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                        final snapshot = await ref
                            .read(localPlanningRepositoryProvider)
                            .loadSelectedDay();
                        final blocks = ref
                            .read(customTemplateRepositoryProvider)
                            .blocksFromDay(snapshot.blocks);
                        if (!context.mounted) return;
                        await showCustomTemplateEditor(
                          context,
                          initialBlocks: blocks,
                        );
                      }),
                icon: const Icon(Icons.bookmark_add_outlined),
                label: const Text('Save this day'),
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
          Text(
            'Your templates',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ref
              .watch(templateLibraryProvider)
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => TextButton(
                  onPressed: () => ref.invalidate(templateLibraryProvider),
                  child: const Text('Retry opening saved templates'),
                ),
                data: (templates) => Column(
                  children: [
                    if (templates.isEmpty)
                      const ListTile(
                        title: Text('No custom templates yet'),
                        subtitle: Text(
                          'Create a pattern or save the blocks from this day.',
                        ),
                      ),
                    for (final template in templates)
                      ListTile(
                        key: ValueKey(template.id),
                        title: Text(template.name),
                        subtitle: Text('${template.blocks.length} blocks'),
                        onTap: _busy
                            ? null
                            : () => _run(() => _preview(template)),
                        trailing: PopupMenuButton<String>(
                          tooltip: 'Actions for ${template.name}',
                          enabled: !_busy,
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit template'),
                            ),
                            PopupMenuItem(
                              value: 'duplicate',
                              child: Text('Duplicate template'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete template'),
                            ),
                          ],
                          onSelected: (action) {
                            if (action == 'edit') {
                              showCustomTemplateEditor(
                                context,
                                template: template,
                              );
                            } else if (action == 'duplicate') {
                              _run(
                                () => ref
                                    .read(templateLibraryProvider.notifier)
                                    .duplicate(template),
                              );
                            } else {
                              _run(() => _delete(template));
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
          const SizedBox(height: 16),
          Text(
            'Starter templates',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final template in dayweftTemplates)
            ListTile(
              title: Text(template.name),
              subtitle: Text('${template.blocks.length} blocks'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _busy ? null : () => _run(() => _preview(template)),
            ),
        ],
      ),
    ),
  );

  Future<void> _preview(DayTemplate template) async {
    final preview = await ref
        .read(planningControllerProvider.notifier)
        .previewTemplate(template);
    if (!mounted) return;
    final applied = await showDialog<bool>(
      context: context,
      builder: (_) => TemplatePreviewDialog(preview: preview),
    );
    if (applied == true && mounted) Navigator.pop(context);
  }

  Future<void> _delete(DayTemplate template) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${template.name}?'),
        content: const Text('Existing days and tasks stay in place.'),
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
    if (confirmed != true || !mounted) return;
    final version = await ref
        .read(templateLibraryProvider.notifier)
        .delete(template);
    if (!mounted) return;
    final controller = ref.read(templateLibraryProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Template deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            try {
              await controller.restore(template.id, version);
            } on Object catch (error) {
              if (messenger.mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      error is PlanningFailure
                          ? error.message
                          : 'The template could not be restored.',
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on Object catch (error) {
      if (mounted) {
        setState(
          () => _error = error is PlanningFailure
              ? error.message
              : 'This action could not be completed. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

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
