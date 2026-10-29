import 'dart:async';

import 'package:dayweft_mobile/core/time/app_clock.dart';
import 'package:dayweft_mobile/features/planning/application/planning_date.dart';
import 'package:dayweft_mobile/features/planning/data/local_planning_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineDateBar extends ConsumerStatefulWidget {
  const TimelineDateBar({required this.snapshot, super.key});
  final LocalDaySnapshot snapshot;

  @override
  ConsumerState<TimelineDateBar> createState() => _TimelineDateBarState();
}

class _TimelineDateBarState extends ConsumerState<TimelineDateBar>
    with WidgetsBindingObserver {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        _followCurrentDay();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _followCurrentDay();
      setState(() {});
    }
  }

  void _followCurrentDay() {
    if (ref.read(planningDateProvider) == null &&
        widget.snapshot.plan.day !=
            civilDate(ref.read(appClockProvider).now())) {
      ref.read(planningDateProvider.notifier).today();
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.snapshot.plan.day;
    final now = ref.watch(appClockProvider).now();
    final localisations = MaterialLocalizations.of(context);
    final next = [
      ...widget.snapshot.blocks.where((b) => b.startsAt.isAfter(now)),
    ]..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Previous day',
              icon: const Icon(Icons.chevron_left),
              onPressed: () => ref.read(planningDateProvider.notifier).move(-1),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  final chosen = await showDatePicker(
                    context: context,
                    initialDate: day,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2200, 12, 31),
                  );
                  if (chosen != null && mounted) {
                    ref.read(planningDateProvider.notifier).select(chosen);
                  }
                },
                child: Text(
                  localisations.formatFullDate(day),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Next day',
              icon: const Icon(Icons.chevron_right),
              onPressed: () => ref.read(planningDateProvider.notifier).move(1),
            ),
          ],
        ),
        if (!DateUtils.isSameDay(day, now))
          TextButton.icon(
            onPressed: () => ref.read(planningDateProvider.notifier).today(),
            icon: const Icon(Icons.today),
            label: const Text('Return to today'),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Now ${TimeOfDay.fromDateTime(now).format(context)}'
              '${next.isEmpty ? '' : ' · Next: ${next.first.title} at ${TimeOfDay.fromDateTime(next.first.startsAt).format(context)}'}',
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
