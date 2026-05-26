import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

class ChildTaskScreen extends StatefulWidget {
  const ChildTaskScreen({super.key});

  @override
  State<ChildTaskScreen> createState() =>
      _ChildTaskScreenState();
}

class _ChildTaskScreenState
    extends State<ChildTaskScreen> {
  String selectedFilter = 'All';

  Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;

      case TaskStatus.submitted:
        return Colors.blue;

      case TaskStatus.approved:
        return Colors.green;

      case TaskStatus.rejected:
        return Colors.red;
    }
  }

  String getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';

      case TaskStatus.submitted:
        return 'Submitted';

      case TaskStatus.approved:
        return 'Approved';

      case TaskStatus.rejected:
        return 'Rejected';
    }
  }

  List<TaskModel> filterTasks(
    List<TaskModel> tasks,
  ) {
    if (selectedFilter == 'All') {
      return tasks;
    }

    return tasks.where((task) {
      return getStatusText(task.status) ==
          selectedFilter;
    }).toList();
  }

  Widget buildFilterChip(String label) {
    final active = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: active
              ? Colors.deepPurple
              : Colors.white,

          borderRadius: BorderRadius.circular(999),

          border: Border.all(
            color: active
                ? Colors.deepPurple
                : Colors.grey.shade300,
          ),
        ),

        child: Text(
          label,
          style: TextStyle(
            color: active
                ? Colors.white
                : Colors.black87,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildTaskCard(
    BuildContext context,
    TaskModel task,
  ) {
    final statusColor =
        getStatusColor(task.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.04,
            ),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.12,
                  ),

                  borderRadius:
                      BorderRadius.circular(999),
                ),

                child: Text(
                  getStatusText(task.status),

                  style: TextStyle(
                    color: statusColor,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            task.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: Colors.orange
                      .withValues(alpha: 0.12),

                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Text(
                  '+${task.expReward} EXP',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: Colors.green
                      .withValues(alpha: 0.12),

                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Text(
                  '${task.rewardAmount}đ',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (task.status ==
              TaskStatus.pending)
            SizedBox(
              width: double.infinity,

              child: FilledButton(
                onPressed: () {
                  context
                      .read<TaskProvider>()
                      .submitTask(task.id);
                },

                child:
                    const Text('Submit Task'),
              ),
            ),

          if (task.status ==
              TaskStatus.submitted)
            const SizedBox(
              width: double.infinity,

              child: FilledButton(
                onPressed: null,
                child: Text(
                  'Waiting for Parent',
                ),
              ),
            ),

          if (task.status ==
              TaskStatus.approved)
            const SizedBox(
              width: double.infinity,

              child: FilledButton(
                onPressed: null,
                child: Text('Completed'),
              ),
            ),

          if (task.status ==
              TaskStatus.rejected)
            const SizedBox(
              width: double.infinity,

              child: FilledButton(
                onPressed: null,
                child: Text('Rejected'),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks =
        context.watch<TaskProvider>().tasks;

    final filteredTasks =
        filterTasks(tasks);

    return Scaffold(
      backgroundColor:
          const Color(0xfffffaff),

      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Task Management',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Theo dõi tiến độ nhiệm vụ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,

              child: Row(
                children: [
                  buildFilterChip('All'),
                  const SizedBox(width: 10),

                  buildFilterChip(
                    'Pending',
                  ),

                  const SizedBox(width: 10),

                  buildFilterChip(
                    'Submitted',
                  ),

                  const SizedBox(width: 10),

                  buildFilterChip(
                    'Approved',
                  ),

                  const SizedBox(width: 10),

                  buildFilterChip(
                    'Rejected',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No Tasks',
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          filteredTasks.length,

                      itemBuilder:
                          (context, index) {
                        return buildTaskCard(
                          context,
                          filteredTasks[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}