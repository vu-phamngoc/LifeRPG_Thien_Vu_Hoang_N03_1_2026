import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/achievement_provider.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = context.watch<AchievementProvider>().achievements;

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: achievement.unlocked
                  ? Colors.green.withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(
                  achievement.unlocked ? Icons.emoji_events : Icons.lock,
                  size: 40,
                  color: achievement.unlocked ? Colors.orange : Colors.grey,
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(achievement.description),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
