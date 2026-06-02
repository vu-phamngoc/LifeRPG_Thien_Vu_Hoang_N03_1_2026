import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'providers/child_provider.dart';
import 'providers/activity_provider.dart';
import 'providers/achievement_provider.dart';
import 'providers/reward_provider.dart';

import 'services/user_service.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/role_select_screen.dart';
import 'screens/parent/parent_main_navigation_screen.dart';
import 'screens/child/child_main_navigation_screen.dart';
import 'providers/family_provider.dart';

class LifeRPGApp extends StatelessWidget {
  const LifeRPGApp({super.key});

  Future<Widget> _getStartScreen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final role = await UserService().getCurrentUserRole();

    if (role == 'parent') {
      return const ParentMainNavigationScreen();
    }

    if (role == 'child') {
      return const ChildMainNavigationScreen();
    }

    return const RoleSelectScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ChildProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => AchievementProvider()),
        ChangeNotifierProvider(create: (_) => RewardProvider()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Life RPG',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
        ),
        home: FutureBuilder<Widget>(
          future: _getStartScreen(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return snapshot.data!;
          },
        ),
      ),
    );
  }
}