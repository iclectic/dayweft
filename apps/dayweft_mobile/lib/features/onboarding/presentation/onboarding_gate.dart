import 'package:dayweft_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dayweft_mobile/features/planning/application/planning_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingGate extends ConsumerStatefulWidget {
  const OnboardingGate({required this.child, super.key});

  final Widget? child;

  @override
  ConsumerState<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends ConsumerState<OnboardingGate> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(planningControllerProvider);
    return state.when(
      data: (snapshot) {
        if (!snapshot.preferences.onboardingCompleted) {
          return Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const OnboardingScreen(),
            ),
          );
        }
        return widget.child ?? const SizedBox.shrink();
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your local plan could not be opened. Your data has not been reset.',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      ref.read(planningControllerProvider.notifier).reload(),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
