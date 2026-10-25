import 'dart:async';

import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuietFocusScreen extends ConsumerStatefulWidget {
  const QuietFocusScreen({super.key});

  @override
  ConsumerState<QuietFocusScreen> createState() => _QuietFocusScreenState();
}

class _QuietFocusScreenState extends ConsumerState<QuietFocusScreen> {
  static const _plannedMinutes = 25;

  final _titleController = TextEditingController(text: 'Quiet Focus session');
  Timer? _timer;
  var _elapsedSeconds = 0;
  var _isRunning = false;
  var _interruptionCount = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingSeconds = (_plannedMinutes * 60 - _elapsedSeconds).clamp(
      0,
      _plannedMinutes * 60,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Quiet Focus')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Current task'),
          ),
          const SizedBox(height: 24),
          Semantics(
            label: 'Quiet Focus timer',
            value: _formatDuration(remainingSeconds),
            child: Center(
              child: Text(
                _formatDuration(remainingSeconds),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment(
                value: true,
                icon: Icon(Icons.play_arrow),
                label: Text('Run'),
              ),
              ButtonSegment(
                value: false,
                icon: Icon(Icons.pause),
                label: Text('Pause'),
              ),
            ],
            selected: <bool>{_isRunning},
            onSelectionChanged: (values) => values.first ? _start() : _pause(),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => setState(() => _interruptionCount += 1),
            icon: const Icon(Icons.notification_important_outlined),
            label: Text('Log interruption ($_interruptionCount)'),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _elapsedSeconds == 0 ? null : _complete,
            icon: const Icon(Icons.check),
            label: const Text('Complete'),
          ),
          TextButton.icon(
            onPressed: _elapsedSeconds == 0 ? null : _abandon,
            icon: const Icon(Icons.close),
            label: const Text('Abandon'),
          ),
        ],
      ),
    );
  }

  void _start() {
    if (_isRunning) {
      return;
    }
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds += 1;
        if (_elapsedSeconds >= _plannedMinutes * 60) {
          _pause();
        }
      });
    });
  }

  void _pause() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() => _isRunning = false);
    }
  }

  Future<void> _complete() async {
    _pause();
    await ref
        .read(planningControllerProvider.notifier)
        .completeFocusSession(
          title: _titleController.text.trim().isEmpty
              ? 'Quiet Focus session'
              : _titleController.text.trim(),
          plannedMinutes: _plannedMinutes,
          actualMinutes: (_elapsedSeconds / 60).ceil(),
          interruptionCount: _interruptionCount,
        );
    if (!mounted) {
      return;
    }
    setState(() {
      _elapsedSeconds = 0;
      _interruptionCount = 0;
    });
  }

  void _abandon() {
    _pause();
    setState(() {
      _elapsedSeconds = 0;
      _interruptionCount = 0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
  }
}
