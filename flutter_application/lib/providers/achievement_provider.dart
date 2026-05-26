import 'package:flutter/material.dart';

import '../models/achievement_model.dart';

class AchievementProvider extends ChangeNotifier {
  final List<AchievementModel> _achievements = [
    const AchievementModel(
      title: 'Beginner',
      description: 'Đạt level 2',
      requiredLevel: 2,
      unlocked: false,
    ),
    const AchievementModel(
      title: 'Task Master',
      description: 'Đạt level 3',
      requiredLevel: 3,
      unlocked: false,
    ),
    const AchievementModel(
      title: 'RPG Hero',
      description: 'Đạt level 5',
      requiredLevel: 5,
      unlocked: false,
    ),
  ];

  List<AchievementModel> get achievements => _achievements;

  void checkAchievements(int level) {
    for (int i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];

      if (level >= achievement.requiredLevel && achievement.unlocked == false) {
        _achievements[i] = achievement.copyWith(unlocked: true);
      }
    }

    notifyListeners();
  }
}
