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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    final tasks = provider.tasks.where((task) {
      return task.status == TaskStatus.submitted;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận nhiệm vụ'), centerTitle: true),

      body: tasks.isEmpty
          ? const Center(child: Text('Không có nhiệm vụ chờ xác nhận'))
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(task.description),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                context.read<TaskProvider>().approveTask(
                                  task.id,
                                );

                                context.read<ActivityProvider>().addActivity(
                                  title: 'Nhiệm vụ được xác nhận',
                                  description: task.title,
                                );

                                context.read<ChildProvider>().addExp(
                                  task.expReward,
                                );

                                context.read<ChildProvider>().addReward(
                                  task.rewardAmount,
                                );

                                context.read<RewardProvider>().addCoins(
                                  task.rewardAmount,
                                );

                                final childProvider = context
                                    .read<ChildProvider>();

                                context
                                    .read<AchievementProvider>()
                                    .checkAchievements(childProvider.level);
                              },
                              child: const Text('Approve'),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.read<TaskProvider>().rejectTask(
                                  task.id,
                                );
                              },
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
