class AchievementModel {
  final String title;
  final String description;
  final int requiredLevel;
  final bool unlocked;

  const AchievementModel({
    required this.title,
    required this.description,
    required this.requiredLevel,
    required this.unlocked,
  });

  AchievementModel copyWith({
    String? title,
    String? description,
    int? requiredLevel,
    bool? unlocked,
  }) {
    return AchievementModel(
      title: title ?? this.title,
      description: description ?? this.description,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
