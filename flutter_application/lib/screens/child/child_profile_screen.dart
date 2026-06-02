import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../providers/child_provider.dart';
import '../../providers/reward_provider.dart';
import '../../providers/achievement_provider.dart';
import '../shared/settings_screen.dart';
import '../shared/edit_profile_screen.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class ChildProfileScreen extends StatelessWidget {
  const ChildProfileScreen({super.key});

  Widget topButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget statCard({
    required String icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xfff4e6d2)),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xff2d243b),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xff8b7c99),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title, {String? action}) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff2d243b),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (action != null)
            Text(
              action,
              style: const TextStyle(
                color: Color(0xffff8a00),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xfff5eee4))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xff8b7c99))),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff2d243b),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget achievementCard({
    required String icon,
    required String title,
    required String subtitle,
    required String status,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffff7e8),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xfff4e6d2)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xfffff0cf),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xff8b7c99),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xfffff0cf),
                    color: const Color(0xffff9f43),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffe7ffe9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Color(0xff1c9b43),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingCard({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xfff4e6d2)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xfffff0cf),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xff8b7c99),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '›',
            style: TextStyle(
              color: Color(0xffaaa0b5),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final childProvider = context.watch<ChildProvider>();
    final rewardProvider = context.watch<RewardProvider>();
    final achievementProvider = context.watch<AchievementProvider>();

    final unlockedAchievements = achievementProvider.achievements
        .where((achievement) => achievement.unlocked)
        .length;
    
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

return FutureBuilder<Map<String, dynamic>?>(
  key: ValueKey(currentUid),
  future: UserService().getCurrentChildProfile(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data!;
        
        final username =
            user['username'] ?? 'Hero';

        final email =
            user['email'] ?? '';

        final phone =
            user['phone'] ?? '';
        
        final avatar =
    user['avatar'] as String?;

    return Scaffold(
      backgroundColor: const Color(0xfffffdf8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  topButton('←', () => Navigator.pop(context)),
                  const Column(
                    children: [
                      Text(
                        'Child Profile',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff2d243b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Hồ sơ người chơi',
                        style: TextStyle(
                          color: Color(0xff8b7c99),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  topButton('⚙️', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffff9f43), Color(0xffff6b81)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
  radius: 42,
  backgroundColor: Colors.white.withValues(alpha: 0.25),
  backgroundImage: avatar == null || avatar.isEmpty
      ? null
      : MemoryImage(base64Decode(avatar)),
  child: avatar == null || avatar.isEmpty
      ? const Text('🧒', style: TextStyle(fontSize: 54))
      : null,
),
                    const SizedBox(height: 14),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Young Hero\nHoàn thành nhiệm vụ để nhận EXP và mở khóa huy hiệu',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _levelBadge('LV ${childProvider.level}'),
                        _levelBadge('🔥 4 Day Streak'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xfff4e6d2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'EXP Progress',
                          style: TextStyle(
                            color: Color(0xff2d243b),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(childProvider.expProgress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Color(0xffff8a00),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: childProvider.expProgress.clamp(0, 1),
                        minHeight: 12,
                        backgroundColor: const Color(0xfffff0cf),
                        color: const Color(0xffff9f43),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${childProvider.exp} / ${childProvider.maxExpForCurrentLevel} EXP',
                      style: const TextStyle(
                        color: Color(0xff8b7c99),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  statCard(
                    icon: '📋',
                    value: '${taskProvider.tasks.length}',
                    label: 'Tasks',
                  ),
                  const SizedBox(width: 12),
                  statCard(
                    icon: '🏆',
                    value: '$unlockedAchievements',
                    label: 'Badges',
                  ),
                  const SizedBox(width: 12),
                  statCard(
                    icon: '⭐',
                    value: '${rewardProvider.coins}',
                    label: 'Coins',
                  ),
                ],
              ),
              sectionTitle('Featured Achievement', action: 'View all'),
              achievementCard(
                icon: '📚',
                title: 'Study Hero',
                subtitle: 'Hoàn thành 10 nhiệm vụ học tập',
                status: '8/10',
                progress: 0.8,
              ),
              achievementCard(
                icon: '🧹',
                title: 'Clean Master',
                subtitle: 'Hoàn thành 5 nhiệm vụ dọn dẹp',
                status: 'DONE',
                progress: 1,
              ),
              sectionTitle('Profile Information'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xfff4e6d2)),
                ),
                child: Column(
                  children: [
                    infoRow('Email', email),
                    infoRow('Phone', phone),
                    infoRow('Role', 'Child'),
                    infoRow('Joined', 'May 2026'),
                  ],
                ),
              ),
              sectionTitle('Settings'),
              settingCard(
                icon: '🔔',
                title: 'Task Reminder',
                subtitle: 'Nhắc nhở nhiệm vụ hằng ngày',
              ),
              settingCard(
                icon: '🎨',
                title: 'Avatar Style',
                subtitle: 'Đổi nhân vật và giao diện',
              ),
              FilledButton(
                onPressed: () async {
  final updated = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditProfileScreen(
        username: username,
        phone: phone,
        role: 'child',
        accentColorHex: 'orange',
      ),
    ),
  );

  if (updated == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cập nhật profile thành công')),
    );
  }
},
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: const Color(0xffff9f43),
                ),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 12),
             OutlinedButton(
  onPressed: () async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  foregroundColor: const Color(0xffd94343),
                  backgroundColor: const Color(0xfffff0f0),
                  side: const BorderSide(color: Color(0xffffd4d4)),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
          ),
        ),
      );
    },
  );

  }

  Widget _levelBadge(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.24),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 13,
      ),
    ),
  );
}

}
