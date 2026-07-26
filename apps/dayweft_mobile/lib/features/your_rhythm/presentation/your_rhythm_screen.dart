import 'package:flutter/material.dart';

class YourRhythmScreen extends StatelessWidget {
  const YourRhythmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Rhythm')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Insights will appear only when there is enough local evidence.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
