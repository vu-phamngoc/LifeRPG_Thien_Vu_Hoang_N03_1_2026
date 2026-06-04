import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';

import '../auth/role_select_screen.dart';
import '../shared/settings_screen.dart';
import '../shared/activity_log_screen.dart';

import 'create_task_screen.dart';
import 'verify_task_screen.dart';
import 'parent_reward_management_screen.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  Widget buildCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: color),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(title),
        ],
      ),
    );
  }

  Widget buildMenuButton({required IconData icon, required String title}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        tileColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final totalTasks = taskProvider.tasks.length;

    final submittedTasks = taskProvider.submittedTasks.length;

    final firstChildId = taskProvider.tasks.isEmpty
        ? null
        : taskProvider.tasks.first.childId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectScreen()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xin chào phụ huynh 👋',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              'Quản lý nhiệm vụ và theo dõi tiến độ của trẻ',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 32),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: 2,

              mainAxisSpacing: 16,
              crossAxisSpacing: 16,

              children: [
                buildCard(
                  icon: Icons.task_alt,
                  title: 'Tổng nhiệm vụ',
                  value: '$totalTasks',
                  color: Colors.blue,
                ),

                buildCard(
                  icon: Icons.pending_actions,
                  title: 'Chờ xác nhận',
                  value: '$submittedTasks',
                  color: Colors.orange,
                ),

                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: firstChildId == null
                      ? null
                      : FirebaseFirestore.instance
                            .collection('children')
                            .doc(firstChildId)
                            .snapshots(),
                  builder: (context, snapshot) {
                    final coins = snapshot.data?.data()?['coins'] ?? 0;

                    return buildCard(
                      icon: Icons.emoji_events,
                      title: 'Reward',
                      value: '$coins đ',
                      color: Colors.green,
                    );
                  },
                ),

                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firstChildId == null
                      ? null
                      : FirebaseFirestore.instance
                            .collection('users')
                            .doc(firstChildId)
                            .collection('achievements')
                            .where('unlocked', isEqualTo: true)
                            .snapshots(),
                  builder: (context, snapshot) {
                    final unlockedAchievements =
                        snapshot.data?.docs.length ?? 0;

                    return buildCard(
                      icon: Icons.star,
                      title: 'Achievement',
                      value: '$unlockedAchievements',
                      color: Colors.purple,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Quản lý',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
                );
              },

              child: buildMenuButton(
                icon: Icons.add_task,
                title: 'Tạo nhiệm vụ',
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VerifyTaskScreen()),
                );
              },

              child: buildMenuButton(
                icon: Icons.verified,
                title: 'Xác nhận nhiệm vụ',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentRewardManagementScreen(),
                  ),
                );
              },
              child: buildMenuButton(
                icon: Icons.card_giftcard,
                title: 'Quản lý phần thưởng',
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivityLogScreen()),
                );
              },

              child: buildMenuButton(
                icon: Icons.history,
                title: 'Lịch sử hoạt động',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
