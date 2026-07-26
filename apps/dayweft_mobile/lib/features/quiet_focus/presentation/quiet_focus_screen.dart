import 'package:flutter/material.dart';

class QuietFocusScreen extends StatelessWidget {
  const QuietFocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiet Focus')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Offline focus sessions, interruption logging and notifications '
            'start from this surface.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
