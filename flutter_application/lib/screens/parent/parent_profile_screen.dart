import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../providers/child_provider.dart';
import '../shared/settings_screen.dart';
import '../../services/user_service.dart';
import '../../providers/family_provider.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

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
          border: Border.all(color: const Color(0xfff0e7fb)),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withValues(alpha: 0.08),
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

  Widget sectionTitle(
    String title, {
    String? action,
    VoidCallback? onActionTap,
    }) {
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
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                action,
                style: const TextStyle(
                  color: Color(0xff7048ff),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showAddChildDialog(BuildContext context) {
  final childIdController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Add Child'),
        content: TextField(
          controller: childIdController,
          decoration: const InputDecoration(
            labelText: 'Child UID',
            hintText: 'Nhập UID tài khoản Child',
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Hủy'),
          ),

          FilledButton(
            onPressed: () async {
              final childId =
                  childIdController.text.trim();

              if (childId.isEmpty) {
                return;
              }

              try {
                await context
                    .read<FamilyProvider>()
                    .linkChild(childId);

                if (!context.mounted) return;

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Liên kết Child thành công',
                    ),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      'Lỗi: $e',
                    ),
                  ),
                );
              }
            },

            child: const Text('Liên kết'),
          ),
        ],
      );
    },
  );
}

  Widget infoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xfff3edf8))),
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
        border: Border.all(color: const Color(0xfff0e7fb)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: 0.08),
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
              color: const Color(0xfff1e9ff),
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

  Widget childCard({
    required String icon,
    required String name,
    required String level,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xfff0e7fb)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffffb347), Color(0xffff7b54)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '$level • EXP Progress',
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
                    backgroundColor: const Color(0xffeee7f7),
                    color: const Color(0xff7048ff),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffefe7ff),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              level,
              style: const TextStyle(
                color: Color(0xff7048ff),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
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
    final familyProvider = context.watch<FamilyProvider>();

    if (familyProvider.children.isEmpty) {
      Future.microtask(() {
        familyProvider.listenToLinkedChildren();
      });
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: UserService().getCurrentUserProfile(),
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
            user['username'] ?? 'User';

        final email =
            user['email'] ?? '';

        final phone =
            user['phone'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xfffffaff),
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
                        'Parent Profile',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff2d243b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Thông tin phụ huynh',
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
                    colors: [Color(0xff7048ff), Color(0xff9d72ff)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    Text('👨‍👧', style: TextStyle(fontSize: 50)),
                    SizedBox(height: 14),
                    Text(
                      username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Parent Account\nQuản lý nhiệm vụ, xác nhận và trao thưởng cho con',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  statCard(
                    icon: '👦', 
                    value: '${familyProvider.children.length}',
                    label: 'Children',
                  ),
                  const SizedBox(width: 12),
                  statCard(
                    icon: '📋',
                    value: '${taskProvider.tasks.length}',
                    label: 'Tasks',
                  ),
                  const SizedBox(width: 12),
                  statCard(
                    icon: '🎁',
                    value: '${childProvider.totalReward}',
                    label: 'Rewards',
                  ),
                ],
              ),
              sectionTitle('Account Information', action: 'Edit'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: const Color(0xfff0e7fb)),
                ),
                child: Column(
                  children: [
                    infoRow('Email', email),
                    infoRow('Phone', phone),
                    infoRow('Role', 'Parent'),
                    infoRow('Joined', 'May 2026'),
                  ],
                ),
              ),
              sectionTitle(
                'My Children', 
                action: 'Add Child',
                onActionTap: () {
                  showAddChildDialog(context);
                },
              ),

              ...familyProvider.children.map(
                (child) {
                  return childCard(
                    icon: '🧒',
                    name: child['username'] ?? 'Child',
                    level: 'LV ${child['level'] ?? 1}',
                    progress: ((child['exp'] ?? 0) / 100).clamp(0, 1),
                  );
                },
              ),
              sectionTitle('Settings'),
              settingCard(
                icon: '🔔',
                title: 'Notifications',
                subtitle: 'Task approval alerts',
              ),
              settingCard(
                icon: '🌙',
                title: 'Dark Mode',
                subtitle: 'Change app appearance',
              ),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: const Color(0xff7048ff),
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
}