import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  bool _includeSampleData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            const SizedBox(height: 24),
            Icon(
              Icons.auto_awesome_motion,
              color: Theme.of(context).colorScheme.primary,
              size: 56,
            ),
            const SizedBox(height: 24),
            Text(
              'Dayweft: Adaptive Day Planner',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'A day that adapts with you.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            const _OnboardingPoint(
              icon: Icons.phone_iphone,
              title: 'Local first',
              body:
                  'Your plan is saved on this device first. An account is optional.',
            ),
            const _OnboardingPoint(
              icon: Icons.cloud_off_outlined,
              title: 'Cloud sync is optional',
              body: 'You can use Dayweft without network access or sign-in.',
            ),
            const _OnboardingPoint(
              icon: Icons.fact_check_outlined,
              title: 'Transparent changes',
              body: 'Dayweft previews schedule changes and keeps undo history.',
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _includeSampleData,
              onChanged: (value) => setState(() => _includeSampleData = value),
              title: const Text('Add removable sample data'),
              subtitle: const Text('Useful for trying the Today Timeline.'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => ref
                  .read(planningControllerProvider.notifier)
                  .completeOnboarding(includeSampleData: _includeSampleData),
              child: const Text('Start locally'),
            ),
            TextButton(
              onPressed: () => ref
                  .read(planningControllerProvider.notifier)
                  .completeOnboarding(includeSampleData: false),
              child: const Text('Skip sample data'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPoint extends StatelessWidget {
  const _OnboardingPoint({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
}
