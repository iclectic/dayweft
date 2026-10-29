import 'dart:async';

import 'package:dayweft_mobile/core/errors/planning_failure.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:dayweft_mobile/features/quiet_focus/application/focus_controller.dart';
import 'package:dayweft_mobile/features/quiet_focus/data/focus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuietFocusScreen extends ConsumerStatefulWidget {
  const QuietFocusScreen({super.key});
  @override
  ConsumerState<QuietFocusScreen> createState() => _QuietFocusScreenState();
}

class _QuietFocusScreenState extends ConsumerState<QuietFocusScreen>
    with WidgetsBindingObserver {
  final _title = TextEditingController(text: 'Quiet Focus session');
  final _minutes = TextEditingController(text: '25');
  FocusMode _mode = FocusMode.countdown;
  String? _taskId;
  Timer? _ticker;
  int _ticks = 0;
  bool _busy = false;
  bool _polling = false;
  bool _completeTask = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted ||
          _busy ||
          _polling ||
          !TickerMode.valuesOf(context).enabled ||
          ref.read(focusControllerProvider).value == null) {
        return;
      }
      _ticks++;
      unawaited(_refresh(checkpoint: _ticks % 30 == 0));
    });
  }

  Future<void> _refresh({bool checkpoint = false}) async {
    if (_polling) return;
    _polling = true;
    try {
      await ref
          .read(focusControllerProvider.notifier)
          .refresh(checkpoint: checkpoint);
    } on Object {
      if (mounted) {
        setState(
          () => _error =
              'The session could not be refreshed. Your last saved record is retained.',
        );
      }
    } finally {
      _polling = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTicker();
      unawaited(_refresh());
    } else {
      _ticker?.cancel();
      unawaited(_refresh(checkpoint: true));
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _title.dispose();
    _minutes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Quiet Focus')),
    body: ref
        .watch(focusControllerProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: FilledButton(
              onPressed: () => ref.invalidate(focusControllerProvider),
              child: const Text('Retry opening session'),
            ),
          ),
          data: (current) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (current == null) ..._setup() else ..._session(current),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
              const SizedBox(height: 20),
              const Text(
                'Focus time stays on this device. Completion alerts are not available yet. '
                'After a device restart, review the last saved time before resuming.',
              ),
            ],
          ),
        ),
  );

  List<Widget> _setup() {
    final tasks =
        ref
            .watch(taskCandidatesProvider)
            .value
            ?.where((task) => task.status != 'completed')
            .toList() ??
        [];
    return [
      TextField(
        controller: _title,
        maxLength: 500,
        decoration: const InputDecoration(labelText: 'Session title'),
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<FocusMode>(
        initialValue: _mode,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Timer mode'),
        items: const [
          DropdownMenuItem(
            value: FocusMode.countdown,
            child: Text('Countdown'),
          ),
          DropdownMenuItem(value: FocusMode.countUp, child: Text('Count up')),
        ],
        onChanged: _busy ? null : (value) => setState(() => _mode = value!),
      ),
      const SizedBox(height: 16),
      if (_mode == FocusMode.countdown)
        TextField(
          controller: _minutes,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Duration in minutes',
            helperText: '1–1440 minutes',
          ),
        ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        initialValue: tasks.any((task) => task.id == _taskId) ? _taskId : null,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Link a task (optional)'),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('No linked task'),
          ),
          for (final task in tasks)
            DropdownMenuItem(
              value: task.id,
              child: Text(task.title, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: _busy ? null : (value) => setState(() => _taskId = value),
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: _busy
            ? null
            : () => _perform(
                () => ref
                    .read(focusControllerProvider.notifier)
                    .start(
                      title: _title.text,
                      mode: _mode,
                      minutes: _mode == FocusMode.countUp
                          ? 25
                          : int.tryParse(_minutes.text) ?? 0,
                      taskId: tasks.any((task) => task.id == _taskId)
                          ? _taskId
                          : null,
                    ),
              ),
        icon: const Icon(Icons.play_arrow),
        label: Text(_busy ? 'Starting…' : 'Start session'),
      ),
    ];
  }

  List<Widget> _session(FocusSnapshot current) {
    final seconds = current.displayedSeconds;
    final displayed =
        '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
    final controller = ref.read(focusControllerProvider.notifier);
    return [
      Text(
        current.session.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 24),
      Semantics(
        label: 'Quiet Focus timer',
        value: displayed,
        child: Center(
          child: Text(
            displayed,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(switch (current.session.status) {
        'running' =>
          current.mode == FocusMode.countdown ? 'Counting down' : 'Counting up',
        'paused' => 'Paused · no time is counted until you resume',
        'ready' => 'Session limit reached · review and complete when ready',
        _ =>
          'Time reference changed. Only the last confirmed time is retained. Unknown time has not been added. Resume when ready.',
      }),
      const SizedBox(height: 16),
      if (current.session.status != 'ready')
        FilledButton.icon(
          onPressed: _busy
              ? null
              : () => _perform(
                  current.session.status == 'running'
                      ? controller.pause
                      : controller.resume,
                ),
          icon: Icon(
            current.session.status == 'running'
                ? Icons.pause
                : Icons.play_arrow,
          ),
          label: Text(current.session.status == 'running' ? 'Pause' : 'Resume'),
        ),
      OutlinedButton.icon(
        onPressed: _busy ? null : () => _perform(controller.interrupt),
        icon: const Icon(Icons.notification_important_outlined),
        label: Text('Log interruption (${current.session.interruptionCount})'),
      ),
      if (current.session.taskId != null)
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _completeTask,
          onChanged: _busy
              ? null
              : (value) => setState(() => _completeTask = value!),
          title: const Text('Complete linked task using recorded focus time'),
          subtitle: const Text(
            'Uses completed sessions for this task, excluding paused time. This replaces a manual actual-time value and can be undone in plan history.',
          ),
        ),
      FilledButton.icon(
        onPressed: _busy
            ? null
            : () => _perform(() async {
                await controller.finish(completeTask: _completeTask);
                _completeTask = false;
                await ref.read(planningControllerProvider.notifier).reload();
              }),
        icon: const Icon(Icons.check),
        label: const Text('Complete session'),
      ),
      TextButton(
        onPressed: _busy
            ? null
            : () => _confirm(
                'Restart this session?',
                'The current session will be kept as abandoned. A new session starts at zero.',
                controller.restart,
              ),
        child: const Text('Restart session'),
      ),
      TextButton(
        onPressed: _busy
            ? null
            : () => _confirm(
                'Abandon this session?',
                'Measured time and interruptions remain in local session history.',
                () => controller.finish(abandoned: true),
              ),
        child: const Text('Abandon session'),
      ),
    ];
  }

  Future<void> _confirm(
    String title,
    String body,
    Future<void> Function() action,
  ) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (accepted == true && mounted) await _perform(action);
  }

  Future<void> _perform(Future<void> Function() action) async {
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
              : 'The session could not be saved. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
