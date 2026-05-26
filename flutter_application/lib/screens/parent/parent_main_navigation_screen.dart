import 'package:flutter/material.dart';

import 'parent_dashboard_screen.dart';
import 'create_task_screen.dart';
import 'verify_task_screen.dart';
import '../shared/activity_log_screen.dart';
import 'parent_profile_screen.dart';

class ParentMainNavigationScreen extends StatefulWidget {
  const ParentMainNavigationScreen({super.key});

  @override
  State<ParentMainNavigationScreen> createState() =>
      _ParentMainNavigationScreenState();
}

class _ParentMainNavigationScreenState
    extends State<ParentMainNavigationScreen> {
  int currentIndex = 0;

  final screens = const [
    ParentDashboardScreen(),
    CreateTaskScreen(),
    VerifyTaskScreen(),
    ActivityLogScreen(),
    ParentProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_task_outlined),
            selectedIcon: Icon(Icons.add_task),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.verified_outlined),
            selectedIcon: Icon(Icons.verified),
            label: 'Verify',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
