import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/boss_raid_model.dart';
import '../models/hero_model.dart';
import 'inventory_service.dart';

class BossRaidService {
  BossRaidService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  final Random _random = Random();

  static const String defaultBossId = 'procrastination_dragon';

  static const BossRaidDefinition fallbackBoss = BossRaidDefinition(
    id: defaultBossId,
    name: 'THE PROCRASTINATION DRAGON',
    phase: 'ENRAGED',
    maxHp: 10000,
    skills: [
      BossSkill(
        id: 'ember_mark',
        name: 'Ember Mark',
        damage: 18,
        description: 'A direct burn on every hero that has attacked the boss.',
      ),
      BossSkill(
        id: 'tail_crash',
        name: 'Tail Crash',
        damage: 28,
        description: 'A heavy personal strike against active raiders.',
      ),
      BossSkill(
        id: 'deadline_roar',
        name: 'Deadline Roar',
        damage: 40,
        description: 'The boss punishes raiders who are still in combat.',
      ),
    ],
    lootTable: [
      BossLootDrop(equipmentId: 'w_str_2', type: 'WEAPON', dropRate: 0.08),
      BossLootDrop(equipmentId: 'w_int_2', type: 'WEAPON', dropRate: 0.08),
      BossLootDrop(equipmentId: 'w_spi_2', type: 'WEAPON', dropRate: 0.08),
      BossLootDrop(equipmentId: 'w_agi_2', type: 'WEAPON', dropRate: 0.08),
      BossLootDrop(equipmentId: 'a_str_2', type: 'ARMOR', dropRate: 0.06),
      BossLootDrop(equipmentId: 'a_int_2', type: 'ARMOR', dropRate: 0.06),
      BossLootDrop(equipmentId: 'a_spi_2', type: 'ARMOR', dropRate: 0.06),
      BossLootDrop(equipmentId: 'a_agi_2', type: 'ARMOR', dropRate: 0.06),
      BossLootDrop(equipmentId: 'p_dragonling_1', type: 'PET', dropRate: 0.04),
      BossLootDrop(
        equipmentId: 'p_guardian_wisp_1',
        type: 'PET',
        dropRate: 0.04,
      ),
      BossLootDrop(
        equipmentId: 'p_deadline_phoenix_1',
        type: 'PET',
        dropRate: 0.02,
      ),
    ],
  );

  static Map<String, dynamic> questSkillData({
    required String heroId,
    required String guildId,
    required String questId,
    required String questTitle,
    required String attribute,
  }) {
    final normalized = _normalizeAttribute(attribute);
    final formula = formulaForAttribute(normalized);
    final resourceType = switch (normalized) {
      'INTELLECT' || 'SPIRIT' => RaidResourceType.mana,
      _ => RaidResourceType.stamina,
    };
    final resourceCost = switch (normalized) {
      'STRENGTH' => 22,
      'INTELLECT' => 26,
      'SPIRIT' => 24,
      'AGILITY' => 20,
      _ => 22,
    };

    return RaidHeroSkill(
      id: questId,
      heroId: heroId,
      guildId: guildId,
      guildQuestId: questId,
      name: questTitle,
      attribute: normalized,
      effect: RaidSkillEffect.damage,
      resourceType: resourceType,
      resourceCost: resourceCost,
      formula: formula,
      iconKey: iconKeyForAttribute(normalized),
      colorValue: colorForAttribute(normalized),
      critChance: normalized == 'AGILITY' ? 0.22 : 0.15,
      critMultiplier: normalized == 'AGILITY' ? 2.0 : 1.8,
    ).toMap();
  }

  static RaidSkillFormula formulaForAttribute(String attribute) {
    return switch (_normalizeAttribute(attribute)) {
      'INTELLECT' => const RaidSkillFormula(
        strengthScale: 0.15,
        agilityScale: 0.25,
        intellectScale: 3.0,
        spiritScale: 0.65,
        levelScale: 14,
        flat: 24,
      ),
      'SPIRIT' => const RaidSkillFormula(
        strengthScale: 0.2,
        agilityScale: 0.2,
        intellectScale: 0.9,
        spiritScale: 2.8,
        levelScale: 13,
        flat: 22,
      ),
      'AGILITY' => const RaidSkillFormula(
        strengthScale: 0.75,
        agilityScale: 2.8,
        intellectScale: 0.15,
        spiritScale: 0.2,
        levelScale: 12,
        flat: 20,
      ),
      _ => const RaidSkillFormula(
        strengthScale: 3.0,
        agilityScale: 0.45,
        intellectScale: 0.1,
        spiritScale: 0.2,
        levelScale: 13,
        flat: 24,
      ),
    };
  }

  static String iconKeyForAttribute(String attribute) {
    return switch (_normalizeAttribute(attribute)) {
      'INTELLECT' => 'fire',
      'SPIRIT' => 'sun',
      'AGILITY' => 'speed',
      _ => 'flash',
    };
  }

  static int colorForAttribute(String attribute) {
    return switch (_normalizeAttribute(attribute)) {
      'INTELLECT' => 0xFF7B1FA2,
      'SPIRIT' => 0xFFF9A825,
      'AGILITY' => 0xFF00897B,
      _ => 0xFFE53935,
    };
  }

  Stream<BossRaidState> raidStateStream(String guildId) {
    return _db.collection('guilds').doc(guildId).snapshots().asyncMap((
      doc,
    ) async {
      final guildData = doc.data() ?? {};
      final boss = await _bossForGuildData(guildData);
      return BossRaidState.fromGuildMap(guildData, guildId, boss);
    });
  }

  Stream<List<Map<String, dynamic>>> leaderboardStream(String guildId) {
    return _db
        .collection('guilds')
        .doc(guildId)
        .collection('raid_damage')
        .snapshots()
        .map((snap) {
          final entries = snap.docs.map((doc) {
            final data = doc.data();
            return {
              'heroId': doc.id,
              'name': data['name'] as String? ?? 'Unknown',
              'damage': (data['totalDamage'] as num?)?.toInt() ?? 0,
              'characterPath': data['characterPath'] as String? ?? 'STR',
              'lastAttack': data['lastAttack'],
            };
          }).toList();
          entries.sort(
            (a, b) => (b['damage'] as int).compareTo(a['damage'] as int),
          );
          return entries;
        });
  }

  Future<String> createBossRaidEvent({
    required String guildId,
    required String createdBy,
    String bossId = defaultBossId,
  }) async {
    final guildRef = _db.collection('guilds').doc(guildId);
    final eventRef = _db.collection('events').doc();
    final bossDoc = await _db.collection('bosses').doc(bossId).get();
    final boss = bossDoc.exists
        ? BossRaidDefinition.fromMap(bossDoc.data()!, bossDoc.id)
        : fallbackBoss;

    await _db.runTransaction((tx) async {
      final guildSnap = await tx.get(guildRef);
      if (!guildSnap.exists) throw Exception('Guild not found.');
      final guildData = guildSnap.data() ?? {};
      if (guildData['ownerId'] != createdBy) {
        throw Exception('Only the guild master can create events.');
      }

      tx.set(eventRef, {
        'guildId': guildId,
        'type': 'boss_raid',
        'status': 'active',
        'bossId': boss.id,
        'bossName': boss.name,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      });
      tx.update(guildRef, {
        'activeEventId': eventRef.id,
        'activeEventType': 'boss_raid',
        'activeBossId': boss.id,
        'bossHp': boss.maxHp,
        'bossDefeated': false,
        'lastBossAttackAt': null,
        'lastBossSkillId': null,
        'lastBossSkillName': null,
      });
    });

    return eventRef.id;
  }

  Stream<List<RaidHeroSkill>> skillsForHeroStream(String heroId) {
    return _db
        .collection('hero_raid_skills')
        .doc(heroId)
        .collection('skills')
        .snapshots()
        .map((snapshot) {
          final skills = snapshot.docs
              .map((doc) => RaidHeroSkill.fromMap(doc.data(), doc.id))
              .where((skill) => skill.usedAt == null)
              .toList();
          skills.sort((a, b) => a.name.compareTo(b.name));
          return skills;
        });
  }

  Future<RaidSkillResult> useSkill({
    required String guildId,
    required String heroId,
    required String skillId,
    String? targetHeroId,
  }) async {
    final guildRef = _db.collection('guilds').doc(guildId);
    final heroRef = _db.collection('heroes').doc(heroId);
    final skillRef = _db
        .collection('hero_raid_skills')
        .doc(heroId)
        .collection('skills')
        .doc(skillId);
    final raidRef = guildRef.collection('raid_damage').doc(heroId);
    final now = DateTime.now();

    final result = await _db.runTransaction((tx) async {
      final guildSnap = await tx.get(guildRef);
      final heroSnap = await tx.get(heroRef);
      final skillSnap = await tx.get(skillRef);
      final raidSnap = await tx.get(raidRef);

      if (!guildSnap.exists) throw Exception('Guild not found.');
      if (!heroSnap.exists) throw Exception('Hero not found.');
      if (!skillSnap.exists) {
        throw Exception('Hero has not unlocked this guild quest skill.');
      }

      final guildData = guildSnap.data() ?? {};
      final bossId = guildData['activeBossId'] as String? ?? defaultBossId;
      final bossRef = _db.collection('bosses').doc(bossId);
      final bossSnap = await tx.get(bossRef);
      final boss = bossSnap.exists
          ? BossRaidDefinition.fromMap(bossSnap.data()!, bossSnap.id)
          : fallbackBoss;

      final hero = HeroModel.fromMap({...heroSnap.data()!, 'uid': heroSnap.id});
      final skill = RaidHeroSkill.fromMap(skillSnap.data()!, skillSnap.id);
      if (skill.usedAt != null) {
        throw Exception('This skill has already been used.');
      }
      if (hero.guildId != guildId) {
        throw Exception('Only guild heroes can attack this boss.');
      }
      if (skill.guildId != guildId || skill.heroId != heroId) {
        throw Exception('This skill does not belong to this hero raid.');
      }

      var heroHp = hero.hp;
      var heroStamina = hero.stamina;
      var heroMana = hero.mana;
      var heroStatus = hero.status;
      DateTime? reviveUntil = hero.reviveUntil;
      var heroUpdates = <String, dynamic>{};

      if (_shouldRefreshResources(hero.lastResourceRefreshAt, now)) {
        heroStamina = 100;
        heroMana = 100;
        heroUpdates['stamina'] = heroStamina;
        heroUpdates['mana'] = heroMana;
        heroUpdates['lastResourceRefreshAt'] = Timestamp.fromDate(now);
      }

      if (heroStatus == 'reviving' &&
          reviveUntil != null &&
          !reviveUntil.isAfter(now)) {
        heroStatus = 'active';
        reviveUntil = null;
        heroHp = hero.maxHp;
        heroUpdates.addAll({
          'status': heroStatus,
          'reviveUntil': null,
          'hp': heroHp,
        });
      }

      if (heroStatus == 'reviving') {
        throw Exception('Hero is reviving and cannot use skills yet.');
      }
      if (heroHp <= 0) {
        throw Exception('Hero has no HP and cannot use skills.');
      }

      switch (skill.resourceType) {
        case RaidResourceType.stamina:
          if (heroStamina < skill.resourceCost) {
            throw Exception('Not enough stamina.');
          }
          heroStamina -= skill.resourceCost;
          heroUpdates['stamina'] = heroStamina;
          break;
        case RaidResourceType.mana:
          if (heroMana < skill.resourceCost) {
            throw Exception('Not enough mana.');
          }
          heroMana -= skill.resourceCost;
          heroUpdates['mana'] = heroMana;
          break;
        case RaidResourceType.hp:
          if (heroHp <= skill.resourceCost) {
            throw Exception('Not enough HP.');
          }
          heroHp -= skill.resourceCost;
          heroUpdates['hp'] = heroHp;
          break;
        case RaidResourceType.none:
          break;
      }

      var amount = skill.evaluate(hero);
      var critical = _random.nextDouble() < skill.critChance;
      if (critical) amount = (amount * skill.critMultiplier).round();

      final bossHp = (guildData['bossHp'] as num?)?.toInt() ?? boss.maxHp;
      if (bossHp <= 0) throw Exception('Boss is already defeated.');
      final nextBossHp = max(0, bossHp - amount);

      final previousDamage =
          (raidSnap.data()?['totalDamage'] as num?)?.toInt() ?? 0;
      tx.set(raidRef, {
        'name': hero.displayName,
        'characterPath': hero.characterPath,
        'totalDamage': previousDamage + amount,
        'lastAttack': FieldValue.serverTimestamp(),
        'lastSkill': skill.name,
        'lastSkillId': skill.id,
        'lastSkillAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      tx.update(guildRef, {
        'activeBossId': boss.id,
        'bossHp': nextBossHp,
        'bossDefeated': nextBossHp <= 0,
      });
      tx.update(skillRef, {'usedAt': FieldValue.serverTimestamp()});
      if (heroUpdates.isNotEmpty) tx.update(heroRef, heroUpdates);

      return RaidSkillResult(
        skillUsed: skill,
        progressContributed: amount,
        critical: critical,
        currentProgress: nextBossHp,
        heroHp: heroHp,
        heroStamina: heroStamina,
        heroMana: heroMana,
      );
    });

    if (result.bossHp <= 0) await grantBossLootToParticipants(guildId);
    return result;
  }

  Future<BossSkill?> processDueBossAttack(String guildId) async {
    final guildRef = _db.collection('guilds').doc(guildId);
    final participants = await guildRef.collection('raid_damage').get();
    if (participants.docs.isEmpty) return null;

    final now = DateTime.now();
    return _db.runTransaction((tx) async {
      final guildSnap = await tx.get(guildRef);
      if (!guildSnap.exists) throw Exception('Guild not found.');
      final guildData = guildSnap.data() ?? {};
      final bossId = guildData['activeBossId'] as String? ?? defaultBossId;
      final bossSnap = await tx.get(_db.collection('bosses').doc(bossId));
      final boss = bossSnap.exists
          ? BossRaidDefinition.fromMap(bossSnap.data()!, bossSnap.id)
          : fallbackBoss;
      if (boss.skills.isEmpty) return null;

      final lastAttackAt = (guildData['lastBossAttackAt'] as Timestamp?)
          ?.toDate();
      if (lastAttackAt != null &&
          now.difference(lastAttackAt) < boss.bossAttackInterval) {
        return null;
      }

      final skill = boss.skills[now.hour % boss.skills.length];
      for (final participant in participants.docs) {
        final heroRef = _db.collection('heroes').doc(participant.id);
        final heroSnap = await tx.get(heroRef);
        if (!heroSnap.exists) continue;
        final hero = HeroModel.fromMap({
          ...heroSnap.data()!,
          'uid': heroSnap.id,
        });
        if (hero.guildId != guildId || hero.status == 'reviving') continue;

        final newHp = max(0, hero.hp - skill.damage);
        final updates = <String, dynamic>{'hp': newHp};
        if (newHp <= 0) {
          updates.addAll({
            'status': 'reviving',
            'reviveUntil': Timestamp.fromDate(now.add(boss.heroReviveDuration)),
          });
        }
        tx.update(heroRef, updates);
      }

      tx.update(guildRef, {
        'activeBossId': boss.id,
        'lastBossAttackAt': Timestamp.fromDate(now),
        'lastBossSkillId': skill.id,
        'lastBossSkillName': skill.name,
      });
      return skill;
    });
  }

  Future<List<String>> grantBossLootToParticipants(String guildId) async {
    final guildDoc = await _db.collection('guilds').doc(guildId).get();
    final boss = await _bossForGuildData(guildDoc.data() ?? {});
    final participants = await _db
        .collection('guilds')
        .doc(guildId)
        .collection('raid_damage')
        .get();
    final granted = <String>[];

    for (final participant in participants.docs) {
      for (final drop in boss.lootTable) {
        if (_random.nextDouble() > drop.dropRate) continue;
        await InventoryService.grantItem(
          heroId: participant.id,
          equipmentId: drop.equipmentId,
          source: 'boss',
          tradable: true,
        );
        granted.add('${participant.id}:${drop.equipmentId}');
      }
    }
    return granted;
  }

  Future<BossRaidDefinition> _bossForGuildData(
    Map<String, dynamic> guildData,
  ) async {
    final bossId = guildData['activeBossId'] as String? ?? defaultBossId;
    final bossDoc = await _db.collection('bosses').doc(bossId).get();
    if (!bossDoc.exists) return fallbackBoss;
    return BossRaidDefinition.fromMap(bossDoc.data()!, bossDoc.id);
  }

  bool _shouldRefreshResources(DateTime? lastRefresh, DateTime now) {
    if (lastRefresh == null) return true;
    return now.difference(lastRefresh) >= const Duration(days: 1);
  }

  static String _normalizeAttribute(String attribute) {
    return switch (attribute) {
      'STR' => 'STRENGTH',
      'INT' => 'INTELLECT',
      'SPI' => 'SPIRIT',
      'AGI' => 'AGILITY',
      _ => attribute,
    };
  }
}
