import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';

class VerifyTaskScreen extends StatelessWidget {
  const VerifyTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().submittedTasks;

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
