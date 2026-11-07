import 'package:dayweft_mobile/features/onboarding/domain/onboarding_preferences.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({
    super.key,
    this.editing = false,
    this.initialPreferences = const OnboardingPreferences(),
  });
  final bool editing;
  final OnboardingPreferences initialPreferences;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  bool _includeSampleData = false;
  bool _saving = false;
  String? _error;
  WorkingPattern _pattern = WorkingPattern.flexible;
  CalendarPreference _calendar = CalendarPreference.later;
  PlanningStyle _style = PlanningStyle.balanced;
  TimeOfDay _wake = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _windDown = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _workStart = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _workEnd = const TimeOfDay(hour: 17, minute: 0);

  int get _lastStep => widget.editing ? 3 : 4;

  @override
  void initState() {
    super.initState();
    final choices = widget.initialPreferences;
    _pattern = choices.workingPattern;
    _calendar = choices.calendarPreference;
    _style = choices.planningStyle;
    TimeOfDay parse(String value) {
      final parts = value.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    _wake = parse(choices.wakeTime);
    _windDown = parse(choices.windDownTime);
    _workStart = parse(choices.workStartTime);
    _workEnd = parse(choices.workEndTime);
    if (widget.editing) _step = 1;
  }

  @override
  Widget build(BuildContext context) {
    const headings = [
      'Welcome to Dayweft',
      'Your working pattern',
      'Your day boundaries',
      'Your planning preferences',
      'Try a sample day',
    ];
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              widget.editing
                  ? 'Planning preferences'
                  : 'Step ${_step + 1} of ${headings.length}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(
                headings[_step],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 16),
            if (_step == 0) ...[
              const Text('A day that adapts with you.'),
              const SizedBox(height: 24),
              const _Point(
                icon: Icons.phone_iphone,
                title: 'Local first',
                body: 'Your plan stays on this device. An account is optional.',
              ),
              const _Point(
                icon: Icons.cloud_off_outlined,
                title: 'Cloud sync is optional',
                body:
                    'Plan, capture and focus without internet access. Connecting cloud services is a separate choice.',
              ),
              const _Point(
                icon: Icons.fact_check_outlined,
                title: 'You choose every change',
                body:
                    'Review suggestions before applying them. Accepted changes keep an undo record.',
              ),
              const Text(
                'Every setup step is optional. Change your choices later in Settings.',
              ),
            ],
            if (_step == 1) ...[
              const Text(
                'Choose what fits for now. Work can continue overnight.',
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<WorkingPattern>(
                initialValue: _pattern,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Working pattern'),
                items: const [
                  DropdownMenuItem(
                    value: WorkingPattern.regular,
                    child: Text('Regular hours'),
                  ),
                  DropdownMenuItem(
                    value: WorkingPattern.flexible,
                    child: Text('Flexible or mixed hours'),
                  ),
                  DropdownMenuItem(
                    value: WorkingPattern.shift,
                    child: Text('Shift work'),
                  ),
                  DropdownMenuItem(
                    value: WorkingPattern.study,
                    child: Text('Study'),
                  ),
                  DropdownMenuItem(
                    value: WorkingPattern.caring,
                    child: Text('Caring and other responsibilities'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _pattern = value ?? _pattern),
              ),
              const SizedBox(height: 16),
              _TimeChoice(
                label: 'Work starts',
                value: _workStart,
                onChanged: (value) => setState(() => _workStart = value),
              ),
              _TimeChoice(
                label: 'Work ends',
                value: _workEnd,
                onChanged: (value) => setState(() => _workEnd = value),
              ),
              if (_workEnd.hour * 60 + _workEnd.minute <
                  _workStart.hour * 60 + _workStart.minute)
                const Text('This working window ends on the following day.'),
            ],
            if (_step == 2) ...[
              const Text(
                'These are planning preferences, not targets. No reminders are enabled during setup.',
              ),
              _TimeChoice(
                label: 'Wake time',
                value: _wake,
                onChanged: (value) => setState(() => _wake = value),
              ),
              _TimeChoice(
                label: 'Wind-down time',
                value: _windDown,
                onChanged: (value) => setState(() => _windDown = value),
              ),
            ],
            if (_step == 3) ...[
              DropdownButtonFormField<PlanningStyle>(
                initialValue: _style,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Planning style'),
                items: const [
                  DropdownMenuItem(
                    value: PlanningStyle.structured,
                    child: Text('Structured'),
                  ),
                  DropdownMenuItem(
                    value: PlanningStyle.balanced,
                    child: Text('Balanced'),
                  ),
                  DropdownMenuItem(
                    value: PlanningStyle.spacious,
                    child: Text('More breathing room'),
                  ),
                ],
                onChanged: (value) => setState(() => _style = value ?? _style),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<CalendarPreference>(
                initialValue: _calendar,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Calendar preference',
                ),
                items: const [
                  DropdownMenuItem(
                    value: CalendarPreference.later,
                    child: Text('Decide later'),
                  ),
                  DropdownMenuItem(
                    value: CalendarPreference.device,
                    child: Text('Connect a device calendar later'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _calendar = value ?? _calendar),
              ),
              const SizedBox(height: 12),
              const Text(
                'Permission is requested only when you connect a calendar.',
              ),
            ],
            if (_step == 4) ...[
              const Text(
                'Start with an empty day or add labelled examples. Removing samples preserves your own tasks.',
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _includeSampleData,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _includeSampleData = value),
                title: const Text('Add removable sample data'),
              ),
            ],
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
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving
                  ? null
                  : () => _step == _lastStep ? _finish() : _advance(),
              child: Text(
                _saving
                    ? 'Saving locally…'
                    : _step == _lastStep
                    ? (widget.editing ? 'Save preferences' : 'Start locally')
                    : 'Continue',
              ),
            ),
            if (_step > (widget.editing ? 1 : 0))
              TextButton(
                onPressed: _saving
                    ? null
                    : () => setState(() {
                        _step -= 1;
                        _error = null;
                      }),
                child: const Text('Back'),
              ),
            if (!widget.editing && _step > 0 && _step < 4)
              TextButton(
                onPressed: _saving ? null : _skipStep,
                child: const Text('Skip this step'),
              ),
            TextButton(
              onPressed: _saving
                  ? null
                  : () {
                      if (widget.editing) {
                        Navigator.of(context).pop();
                      } else {
                        _finish(skip: _step != 4, skipSamples: true);
                      }
                    },
              child: Text(
                widget.editing
                    ? 'Cancel'
                    : _step == 4
                    ? 'Skip sample data'
                    : 'Skip setup',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _storedTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  OnboardingPreferences get _choices => OnboardingPreferences(
    workingPattern: _pattern,
    wakeTime: _storedTime(_wake),
    windDownTime: _storedTime(_windDown),
    workStartTime: _storedTime(_workStart),
    workEndTime: _storedTime(_workEnd),
    calendarPreference: _calendar,
    planningStyle: _style,
  );

  void _advance() {
    if (_step == 1 && _workStart == _workEnd) {
      setState(() => _error = 'Choose different work start and end times.');
      return;
    }
    setState(() {
      _step += 1;
      _error = null;
    });
  }

  void _skipStep() {
    setState(() {
      if (_step == 1) {
        _pattern = WorkingPattern.flexible;
        _workStart = const TimeOfDay(hour: 9, minute: 0);
        _workEnd = const TimeOfDay(hour: 17, minute: 0);
      } else if (_step == 2) {
        _wake = const TimeOfDay(hour: 7, minute: 0);
        _windDown = const TimeOfDay(hour: 22, minute: 0);
      } else if (_step == 3) {
        _style = PlanningStyle.balanced;
        _calendar = CalendarPreference.later;
      }
    });
    _advance();
  }

  Future<void> _finish({bool skip = false, bool skipSamples = false}) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (widget.editing) {
        await ref
            .read(planningControllerProvider.notifier)
            .updatePlanningPreferences(_choices);
        if (mounted) Navigator.of(context).pop();
        return;
      }
      await ref
          .read(planningControllerProvider.notifier)
          .completeOnboarding(
            includeSampleData: !skip && !skipSamples && _includeSampleData,
            choices: skip ? const OnboardingPreferences() : _choices,
          );
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Your choices could not be saved. Please try again.';
        });
      }
    }
  }
}

class _TimeChoice extends StatelessWidget {
  const _TimeChoice({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text(value.format(context)),
    trailing: const Icon(Icons.schedule),
    onTap: () async {
      final result = await showTimePicker(
        context: context,
        initialTime: value,
        helpText: label,
      );
      if (result != null && context.mounted) onChanged(result);
    },
  );
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(body),
            ],
          ),
        ),
      ],
    ),
  );
}
