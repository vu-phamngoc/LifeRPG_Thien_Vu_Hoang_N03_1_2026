import 'package:flutter/material.dart';

import 'child_home_screen.dart';
import 'child_reward_screen.dart';
import '../shared/achievement_screen.dart';
import '../shared/activity_log_screen.dart';
import 'child_profile_screen.dart';

class ChildMainNavigationScreen extends StatefulWidget {
  const ChildMainNavigationScreen({super.key});

  @override
  State<ChildMainNavigationScreen> createState() =>
      _ChildMainNavigationScreenState();
}

class _ChildMainNavigationScreenState extends State<ChildMainNavigationScreen> {
  int currentIndex = 0;

  final screens = const [
    ChildHomeScreen(),
    AchievementScreen(),
    ChildRewardScreen(),
    ActivityLogScreen(),
    ChildProfileScreen(),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Achievement',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            selectedIcon: Icon(Icons.card_giftcard),
            label: 'Reward',
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
