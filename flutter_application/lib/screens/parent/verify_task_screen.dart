import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/child_provider.dart';
import '../../providers/activity_provider.dart';
import '../../providers/achievement_provider.dart';
import '../../providers/reward_provider.dart';

class VerifyTaskScreen extends StatelessWidget {
  const VerifyTaskScreen({super.key});

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

  Widget sectionTitle(String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xff2d243b),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            actionText,
            style: const TextStyle(
              color: Color(0xff7048ff),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget historyCard({
    required String icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xfff0e7fb)),
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
                const SizedBox(height: 4),
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
          Text(
            time,
            style: const TextStyle(
              color: Color(0xffaaa0b5),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  void approveTask(BuildContext context, TaskModel task) {
    context.read<TaskProvider>().approveTask(task.id);

    context.read<ChildProvider>().addExp(task.expReward);
    context.read<ChildProvider>().addReward(task.rewardAmount);
    context.read<RewardProvider>().addCoins(task.rewardAmount);

    context.read<ActivityProvider>().addActivity(
      title: 'Task Approved',
      description: task.title,
    );

    final childProvider = context.read<ChildProvider>();

    final unlockedAchievements = context
        .read<AchievementProvider>()
        .checkAchievements(childProvider.level);

    for (final achievement in unlockedAchievements) {
      context.read<ActivityProvider>().addActivity(
        title: 'Achievement Unlocked',
        description: achievement,
      );
    }
  }

  void rejectTask(BuildContext context, TaskModel task) {
    context.read<TaskProvider>().rejectTask(task.id);

    context.read<ActivityProvider>().addActivity(
      title: 'Task Rejected',
      description: task.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks.where((task) {
      return task.status == TaskStatus.submitted;
    }).toList();

    final childProvider = context.watch<ChildProvider>();

    final task = tasks.isNotEmpty ? tasks.first : null;

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
                        'Verify Task',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff2d243b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Parent Approval System',
                        style: TextStyle(
                          color: Color(0xff8b7c99),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  topButton('⋯', () {}),
                ],
              ),
              const SizedBox(height: 24),
              if (task == null)
                const Padding(
                  padding: EdgeInsets.only(top: 160),
                  child: Center(
                    child: Text(
                      'Không có nhiệm vụ chờ xác nhận',
                      style: TextStyle(fontSize: 18, color: Color(0xff8b7c99)),
                    ),
                  ),
                )
              else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff7048ff), Color(0xff9d72ff)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '📝 ${task.title}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'SUBMITTED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        task.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _badge('⭐ +${task.expReward} EXP'),
                          _badge('🎁 +${task.rewardAmount} Coins'),
                        ],
                      ),
                    ],
                  ),
                ),
                sectionTitle('Child Information', 'LV ${childProvider.level}'),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xfff0e7fb)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xffffb347), Color(0xffff7b54)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('🧒', style: TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Minh Nguyen',
                              style: TextStyle(
                                color: Color(0xff2d243b),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Current EXP Progress',
                              style: TextStyle(
                                color: Color(0xff8b7c99),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: childProvider.expProgress.clamp(0, 1),
                                minHeight: 8,
                                backgroundColor: const Color(0xffeee7f7),
                                color: const Color(0xff7048ff),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                sectionTitle('Submitted Proof', 'Image Evidence'),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xfff0e7fb)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 220,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xfff3ecff),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: const Color(0xffd8c8ff),
                            width: 2,
                          ),
                        ),
                        child: const Text('📸', style: TextStyle(fontSize: 70)),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _proofItem(
                            'Submitted Time',
                            task.submittedAt == null
                                ? 'Just now'
                                : '${task.submittedAt!.hour}:${task.submittedAt!.minute.toString().padLeft(2, '0')}',
                          ),
                          const SizedBox(width: 12),
                          _proofItem('Task Difficulty', task.difficulty),
                        ],
                      ),
                    ],
                  ),
                ),
                sectionTitle('Child Note', 'Message'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0xfff0e7fb)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📝 Message from Child',
                        style: TextStyle(
                          color: Color(0xff2d243b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '"${task.childNote ?? 'Con đã hoàn thành nhiệm vụ được giao rồi ạ.'}"',
                        style: TextStyle(color: Color(0xff6f6280), height: 1.7),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => rejectTask(context, task),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(58),
                          foregroundColor: const Color(0xffd94343),
                          side: const BorderSide(color: Color(0xffffd4d4)),
                          backgroundColor: const Color(0xfffff0f0),
                        ),
                        child: const Text('❌ Reject'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => approveTask(context, task),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(58),
                          backgroundColor: const Color(0xff7048ff),
                        ),
                        child: const Text('✔ Approve'),
                      ),
                    ),
                  ],
                ),
                sectionTitle('Recent Verify History', 'Today'),
                historyCard(
                  icon: '📘',
                  title: 'Homework Approved',
                  subtitle: '+40 EXP granted to Minh',
                  time: '7:10 PM',
                ),
                historyCard(
                  icon: '🏆',
                  title: 'Achievement Unlocked',
                  subtitle: 'Study Hero badge unlocked',
                  time: '6:40 PM',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _proofItem(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xfffaf7ff),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xff8b7c99),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xff2d243b),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
