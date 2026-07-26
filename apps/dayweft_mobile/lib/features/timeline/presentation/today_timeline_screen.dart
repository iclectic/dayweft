import 'package:adaptive_day_engine/adaptive_day_engine.dart';
import 'package:dayweft_design_system/dayweft_design_system.dart';
import 'package:dayweft_domain/dayweft_domain.dart';
import 'package:flutter/material.dart';

class TodayTimelineScreen extends StatelessWidget {
  const TodayTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final plan = DayPlan(
      id: 'sample-local-plan',
      day: DateTime(now.year, now.month, now.day),
      timeZone: 'local',
      workingWindow: TimeWindow(
        start: DateTime(now.year, now.month, now.day, 8),
        end: DateTime(now.year, now.month, now.day, 18),
      ),
      blocks: <TimeBlock>[
        TimeBlock(
          id: 'fixed-standup',
          title: 'Team stand-up',
          window: TimeWindow(
            start: DateTime(now.year, now.month, now.day, 9),
            end: DateTime(now.year, now.month, now.day, 9, 30),
          ),
          type: BlockType.fixed,
        ),
        TimeBlock(
          id: 'flex-build',
          title: 'Build planning MVP',
          window: TimeWindow(
            start: DateTime(now.year, now.month, now.day, 10),
            end: DateTime(now.year, now.month, now.day, 12),
          ),
          type: BlockType.flexible,
        ),
      ],
    );
    final observations = const DayweftAdaptiveEngine().realityCheck(plan);

    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar.large(title: Text('Today Timeline')),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverList.list(
            children: <Widget>[
              Text(
                'Dayweft: Adaptive Day Planner',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'A day that adapts with you.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              for (final block in plan.blocks) ...<Widget>[
                _TimelineBlock(block: block),
                const ThreadDivider(),
              ],
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Reweave My Day'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.fact_check_outlined),
                label: Text('Reality Check (${observations.length})'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineBlock extends StatelessWidget {
  const _TimelineBlock({required this.block});

  final TimeBlock block;

  @override
  Widget build(BuildContext context) {
    final label = switch (block.type) {
      BlockType.fixed => 'Fixed',
      BlockType.flexible => 'Flexible',
      BlockType.optional => 'Optional',
    };
    return Semantics(
      label: '$label block, ${block.title}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Icon(
                block.type == BlockType.fixed
                    ? Icons.lock_clock
                    : Icons.schedule,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      block.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(label),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
