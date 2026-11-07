import 'package:dayweft_mobile/app/bootstrap/dayweft_app.dart';
import 'package:dayweft_mobile/core/config/app_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfiguration.fromBuild();
  runApp(const ProviderScope(child: DayweftApp()));
}
