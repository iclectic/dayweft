import 'package:dayweft_design_system/dayweft_design_system.dart';
import 'package:dayweft_mobile/app/routing/app_router.dart';
import 'package:flutter/material.dart';

class DayweftApp extends StatelessWidget {
  const DayweftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dayweft: Adaptive Day Planner',
      theme: DayweftTheme.light(),
      darkTheme: DayweftTheme.dark(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
