import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          SwitchListTile(
            value: true,
            onChanged: null,
            title: const Text('Local-only mode'),
            subtitle: const Text('Cloud features stay optional.'),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy by design'),
            subtitle: Text('Analytics and AI controls will require consent.'),
          ),
        ],
      ),
    );
  }
}
