import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'providers/child_provider.dart';
import 'providers/activity_provider.dart';
import 'providers/achievement_provider.dart';
import 'providers/reward_provider.dart';

import 'screens/child/child_main_navigation_screen.dart';

class LifeRPGApp extends StatelessWidget {
  const LifeRPGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),

        ChangeNotifierProvider(create: (_) => ChildProvider()),

        ChangeNotifierProvider(create: (_) => ActivityProvider()),

        ChangeNotifierProvider(create: (_) => AchievementProvider()),

        ChangeNotifierProvider(create: (_) => RewardProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Life RPG',

        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
        ),

        home: const ChildMainNavigationScreen(),
      ),
    );
  }
}
