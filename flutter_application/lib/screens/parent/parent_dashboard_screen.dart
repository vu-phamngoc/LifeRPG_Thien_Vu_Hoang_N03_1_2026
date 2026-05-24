import 'package:flutter/material.dart';

import 'create_task_screen.dart';

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
          Text(title, style: const TextStyle(fontSize: 16)),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard'), centerTitle: true),
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
                  value: '12',
                  color: Colors.blue,
                ),
                buildCard(
                  icon: Icons.pending_actions,
                  title: 'Chờ xác nhận',
                  value: '5',
                  color: Colors.orange,
                ),
                buildCard(
                  icon: Icons.emoji_events,
                  title: 'Reward',
                  value: '120K',
                  color: Colors.green,
                ),
                buildCard(
                  icon: Icons.star,
                  title: 'Achievement',
                  value: '8',
                  color: Colors.purple,
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
            buildMenuButton(icon: Icons.verified, title: 'Xác nhận nhiệm vụ'),
            buildMenuButton(icon: Icons.child_care, title: 'Quản lý trẻ em'),
            buildMenuButton(icon: Icons.history, title: 'Lịch sử hoạt động'),
          ],
        ),
      ),
    );
  }
}
