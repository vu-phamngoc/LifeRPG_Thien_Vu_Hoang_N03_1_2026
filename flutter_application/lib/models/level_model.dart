import 'package:cloud_firestore/cloud_firestore.dart';

class LevelModel {
  final int level;
  final int expRequired;
  final int statPointsReward;
  final int goldReward;
  final List<String> unlocks; // e.g. ['TIER_1_EQUIPMENT']

  LevelModel({
    required this.level,
    required this.expRequired,
    required this.statPointsReward,
    required this.goldReward,
    required this.unlocks,
  });

  factory LevelModel.fromMap(Map<String, dynamic> map, String docId) {
    return LevelModel(
      level: (map['level'] as num?)?.toInt() ?? 1,
      expRequired: (map['expRequired'] as num?)?.toInt() ?? 1000,
      statPointsReward: (map['statPointsReward'] as num?)?.toInt() ?? 3,
      goldReward: (map['goldReward'] as num?)?.toInt() ?? 250,
      unlocks: List<String>.from(map['unlocks'] ?? []),
    );
  }

  factory LevelModel.fromDoc(DocumentSnapshot doc) {
    return LevelModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'expRequired': expRequired,
      'statPointsReward': statPointsReward,
      'goldReward': goldReward,
      'unlocks': unlocks,
    };
  }
}
