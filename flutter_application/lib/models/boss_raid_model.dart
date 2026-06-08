import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'hero_model.dart';

enum RaidSkillEffect { damage, heal, revive }

enum RaidResourceType { stamina, mana, hp, none }

class HeroBattleStats {
  final int strength;
  final int agility;
  final int intellect;
  final int spirit;
  final int level;

  const HeroBattleStats({
    required this.strength,
    required this.agility,
    required this.intellect,
    required this.spirit,
    required this.level,
  });

  factory HeroBattleStats.fromHero(HeroModel hero) {
    return HeroBattleStats(
      strength: hero.strength,
      agility: hero.agility,
      intellect: hero.intellect,
      spirit: hero.spirit,
      level: hero.level,
    );
  }
}

class RaidSkillFormula {
  final double strengthScale;
  final double agilityScale;
  final double intellectScale;
  final double spiritScale;
  final double levelScale;
  final int flat;
  final double multiplier;

  const RaidSkillFormula({
    this.strengthScale = 0,
    this.agilityScale = 0,
    this.intellectScale = 0,
    this.spiritScale = 0,
    this.levelScale = 0,
    this.flat = 0,
    this.multiplier = 1,
  });

  factory RaidSkillFormula.fromMap(Map<String, dynamic> map) {
    return RaidSkillFormula(
      strengthScale: (map['strengthScale'] as num?)?.toDouble() ?? 0,
      agilityScale: (map['agilityScale'] as num?)?.toDouble() ?? 0,
      intellectScale: (map['intellectScale'] as num?)?.toDouble() ?? 0,
      spiritScale: (map['spiritScale'] as num?)?.toDouble() ?? 0,
      levelScale: (map['levelScale'] as num?)?.toDouble() ?? 0,
      flat: (map['flat'] as num?)?.toInt() ?? 0,
      multiplier: (map['multiplier'] as num?)?.toDouble() ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'strengthScale': strengthScale,
      'agilityScale': agilityScale,
      'intellectScale': intellectScale,
      'spiritScale': spiritScale,
      'levelScale': levelScale,
      'flat': flat,
      'multiplier': multiplier,
    };
  }

  int evaluate(HeroBattleStats stats) {
    final raw =
        flat +
        (stats.strength * strengthScale) +
        (stats.agility * agilityScale) +
        (stats.intellect * intellectScale) +
        (stats.spirit * spiritScale) +
        (stats.level * levelScale);
    return max(0, (raw * multiplier).round());
  }
}

class RaidHeroSkill {
  final String id;
  final String heroId;
  final String guildId;
  final String guildQuestId;
  final String name;
  final String characterPath;
  final String attribute;
  final RaidSkillEffect effect;
  final RaidResourceType resourceType;
  final int resourceCost;
  final RaidSkillFormula formula;
  final String iconKey;
  final int colorValue;
  final bool canTargetAlly;
  final double critChance;
  final double critMultiplier;
  final DateTime? usedAt;

  const RaidHeroSkill({
    required this.id,
    this.heroId = '',
    this.guildId = '',
    this.guildQuestId = '',
    required this.name,
    this.characterPath = '',
    required this.attribute,
    required this.effect,
    required this.resourceType,
    required this.resourceCost,
    required this.formula,
    required this.iconKey,
    required this.colorValue,
    this.canTargetAlly = false,
    this.critChance = 0.15,
    this.critMultiplier = 1.8,
    this.usedAt,
  });

  factory RaidHeroSkill.fromMap(Map<String, dynamic> map, String id) {
    return RaidHeroSkill(
      id: id,
      heroId: map['heroId'] as String? ?? '',
      guildId: map['guildId'] as String? ?? '',
      guildQuestId: map['guildQuestId'] as String? ?? id,
      name: map['name'] as String? ?? 'Guild Skill',
      characterPath: map['characterPath'] as String? ?? '',
      attribute: map['attribute'] as String? ?? 'STRENGTH',
      effect: _effectFromString(map['effect'] as String?),
      resourceType: _resourceFromString(map['resourceType'] as String?),
      resourceCost: (map['resourceCost'] as num?)?.toInt() ?? 10,
      formula: RaidSkillFormula.fromMap(
        Map<String, dynamic>.from(map['formula'] as Map? ?? {}),
      ),
      iconKey: map['iconKey'] as String? ?? 'flash',
      colorValue: (map['colorValue'] as num?)?.toInt() ?? 0xFFE53935,
      canTargetAlly: map['canTargetAlly'] as bool? ?? false,
      critChance: (map['critChance'] as num?)?.toDouble() ?? 0.15,
      critMultiplier: (map['critMultiplier'] as num?)?.toDouble() ?? 1.8,
      usedAt: (map['usedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'heroId': heroId,
      'guildId': guildId,
      'guildQuestId': guildQuestId,
      'name': name,
      'characterPath': characterPath,
      'attribute': attribute,
      'effect': effect.name,
      'resourceType': resourceType.name,
      'resourceCost': resourceCost,
      'formula': formula.toMap(),
      'iconKey': iconKey,
      'colorValue': colorValue,
      'canTargetAlly': canTargetAlly,
      'critChance': critChance,
      'critMultiplier': critMultiplier,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  int evaluate(HeroModel hero) =>
      formula.evaluate(HeroBattleStats.fromHero(hero));

  static RaidSkillEffect _effectFromString(String? value) {
    return RaidSkillEffect.values.firstWhere(
      (effect) => effect.name == value,
      orElse: () => RaidSkillEffect.damage,
    );
  }

  static RaidResourceType _resourceFromString(String? value) {
    return RaidResourceType.values.firstWhere(
      (resource) => resource.name == value,
      orElse: () => RaidResourceType.stamina,
    );
  }
}

class BossSkill {
  final String id;
  final String name;
  final int damage;
  final String description;

  const BossSkill({
    required this.id,
    required this.name,
    required this.damage,
    required this.description,
  });

  factory BossSkill.fromMap(Map<String, dynamic> map) {
    return BossSkill(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      damage: (map['damage'] as num?)?.toInt() ?? 0,
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'damage': damage,
      'description': description,
    };
  }
}

class BossLootDrop {
  final String equipmentId;
  final String type;
  final double dropRate;

  const BossLootDrop({
    required this.equipmentId,
    required this.type,
    required this.dropRate,
  });

  factory BossLootDrop.fromMap(Map<String, dynamic> map) {
    return BossLootDrop(
      equipmentId: map['equipmentId'] as String? ?? '',
      type: map['type'] as String? ?? 'WEAPON',
      dropRate: (map['dropRate'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'equipmentId': equipmentId, 'type': type, 'dropRate': dropRate};
  }
}

class BossRaidDefinition {
  final String id;
  final String name;
  final String phase;
  final int maxHp;
  final List<BossSkill> skills;
  final List<BossLootDrop> lootTable;
  final Duration bossAttackInterval;
  final Duration heroReviveDuration;

  const BossRaidDefinition({
    required this.id,
    required this.name,
    required this.phase,
    required this.maxHp,
    required this.skills,
    required this.lootTable,
    this.bossAttackInterval = const Duration(hours: 1),
    this.heroReviveDuration = const Duration(days: 1),
  });

  factory BossRaidDefinition.fromMap(Map<String, dynamic> map, String id) {
    return BossRaidDefinition(
      id: id,
      name: map['name'] as String? ?? 'Unknown Boss',
      phase: map['phase'] as String? ?? 'NORMAL',
      maxHp: (map['maxHp'] as num?)?.toInt() ?? 10000,
      skills: (map['skills'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((skill) => BossSkill.fromMap(Map<String, dynamic>.from(skill)))
          .toList(),
      lootTable: (map['lootTable'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((drop) => BossLootDrop.fromMap(Map<String, dynamic>.from(drop)))
          .toList(),
      bossAttackInterval: Duration(
        minutes: (map['bossAttackIntervalMinutes'] as num?)?.toInt() ?? 60,
      ),
      heroReviveDuration: Duration(
        hours: (map['heroReviveHours'] as num?)?.toInt() ?? 24,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phase': phase,
      'maxHp': maxHp,
      'skills': skills.map((skill) => skill.toMap()).toList(),
      'lootTable': lootTable.map((drop) => drop.toMap()).toList(),
      'bossAttackIntervalMinutes': bossAttackInterval.inMinutes,
      'heroReviveHours': heroReviveDuration.inHours,
    };
  }
}

class BossRaidState {
  final String guildId;
  final String bossId;
  final String bossName;
  final String bossPhase;
  final int bossMaxHp;
  final int currentHp;
  final DateTime? lastBossAttackAt;
  final bool defeated;

  const BossRaidState({
    required this.guildId,
    required this.bossId,
    required this.bossName,
    required this.bossPhase,
    required this.bossMaxHp,
    required this.currentHp,
    this.lastBossAttackAt,
    this.defeated = false,
  });

  factory BossRaidState.fromGuildMap(
    Map<String, dynamic> map,
    String guildId,
    BossRaidDefinition boss,
  ) {
    return BossRaidState(
      guildId: guildId,
      bossId:
          (map['activeBossId'] as String?) ??
          (map['bossId'] as String?) ??
          boss.id,
      bossName: boss.name,
      bossPhase: boss.phase,
      bossMaxHp: boss.maxHp,
      currentHp: (map['bossHp'] as num?)?.toInt() ?? boss.maxHp,
      lastBossAttackAt: (map['lastBossAttackAt'] as Timestamp?)?.toDate(),
      defeated: map['bossDefeated'] as bool? ?? false,
    );
  }
}

class RaidSkillResult {
  final RaidHeroSkill skill;
  final int amount;
  final bool critical;
  final int bossHp;
  final int heroHp;
  final int heroStamina;
  final int heroMana;

  const RaidSkillResult({
    required this.skill,
    required this.amount,
    required this.critical,
    required this.bossHp,
    required this.heroHp,
    required this.heroStamina,
    required this.heroMana,
  });
}
