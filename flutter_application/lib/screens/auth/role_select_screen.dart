import 'package:flutter/material.dart';

import '../child/child_main_navigation_screen.dart';
import '../parent/parent_main_navigation_screen.dart';
import '../../services/user_service.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  Widget buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),

        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(32),
        ),

        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: color,

              child: Icon(icon, color: Colors.white, size: 42),
            ),

            const SizedBox(height: 26),

            Text(
              title,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffffaff),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Life RPG',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1f1b24),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Chọn vai trò để tiếp tục',
                style: TextStyle(fontSize: 22, color: Colors.black54),
              ),

              const SizedBox(height: 50),

              buildRoleCard(
                context: context,
                title: 'Parent',
                subtitle: 'Quản lý nhiệm vụ và theo dõi tiến độ của trẻ',
                icon: Icons.admin_panel_settings,
                color: Colors.deepPurple,

                onTap: () async {
                  await UserService().saveUserRoleIfNotExists('parent');

                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParentMainNavigationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),

              buildRoleCard(
                context: context,
                title: 'Child',
                subtitle: 'Hoàn thành nhiệm vụ và nhận thưởng',
                icon: Icons.child_care,
                color: Colors.orange,

                onTap: () async {
                  await UserService().saveUserRoleIfNotExists('child');

                  if (!context.mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChildMainNavigationScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
