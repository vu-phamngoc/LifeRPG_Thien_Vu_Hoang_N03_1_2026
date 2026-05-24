import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/child_provider.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  Widget buildTaskCard({
    required BuildContext context,
    required TaskModel task,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: const Icon(Icons.task, color: Colors.white),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '+${task.expReward} EXP',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          FilledButton(
            onPressed: () {
              context.read<TaskProvider>().submitTask(task.id);
            },
            child: const Text('Hoàn thành'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().pendingTasks;
    final childProvider = context.watch<ChildProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Life RPG'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${childProvider.level}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${childProvider.exp} / ${childProvider.maxExpForCurrentLevel} EXP',
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: childProvider.expProgress.clamp(0.0, 1.0),
                      minHeight: 14,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Nhiệm vụ hôm nay',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            if (tasks.isEmpty)
              const Center(child: Text('Chưa có nhiệm vụ'))
            else
              Column(
                children: tasks.map((task) {
                  return buildTaskCard(
                    context: context,
                    task: task,
                    color: Colors.blue,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
