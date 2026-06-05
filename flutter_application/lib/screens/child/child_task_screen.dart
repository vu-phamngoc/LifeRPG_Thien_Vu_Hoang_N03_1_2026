import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/activity_provider.dart';
import '../../services/task_service.dart';
import 'dart:convert';

class ChildTaskScreen extends StatefulWidget {
  const ChildTaskScreen({super.key});

  @override
  State<ChildTaskScreen> createState() => _ChildTaskScreenState();
}

class _ChildTaskScreenState extends State<ChildTaskScreen> {
  String selectedFilter = 'All';

  XFile? selectedImage;

  Future<void> pickProofImage(ImageSource source) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(source: source, imageQuality: 70);

    if (image == null) return;

    setState(() {
      selectedImage = image;
    });
  }

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

  List<TaskModel> filterTasks(List<TaskModel> tasks) {
    if (selectedFilter == 'All') {
      return tasks;
    }

    return tasks.where((task) {
      return getStatusText(task.status) == selectedFilter;
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        decoration: BoxDecoration(
          color: active ? Colors.deepPurple : Colors.white,

          borderRadius: BorderRadius.circular(999),

          border: Border.all(
            color: active ? Colors.deepPurple : Colors.grey.shade300,
          ),
        ),

        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showSubmitDialog(BuildContext context, TaskModel task) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Gửi nhiệm vụ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thêm ghi chú và minh chứng hoàn thành nhiệm vụ.'),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú của trẻ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xfff3ecff),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xffd8c8ff), width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      selectedImage == null
                          ? 'Chưa chọn ảnh minh chứng'
                          : 'Đã chọn: ${selectedImage!.name}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                pickProofImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Thư viện'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => pickProofImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
                if (selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng chọn hoặc chụp ảnh minh chứng.'),
                    ),
                  );
                  return;
                }

                final imageToSubmit = selectedImage;
                final noteText = noteController.text.trim().isEmpty
                    ? 'Con đã hoàn thành nhiệm vụ được giao rồi ạ.'
                    : noteController.text.trim();

                Navigator.of(dialogContext).pop();

                setState(() {
                  selectedImage = null;
                });

                try {
                  final imageBytes = await imageToSubmit!.readAsBytes();

                  final proofImageUrl = base64Encode(imageBytes);

                  await TaskService().submitTask(
                    taskId: task.id,
                    childNote: noteText,
                    proofImage: proofImageUrl,
                  );

                  if (!context.mounted) return;

                  await context.read<ActivityProvider>().addActivity(
                    childId: task.childId,
                    title: 'Task Submitted',
                    description: task.title,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã gửi nhiệm vụ')),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi gửi nhiệm vụ: $e')),
                  );
                }
              },
              child: const Text('Gửi'),
            ),
          ],
        );
      },
    );
  }

  Widget buildTaskCard(BuildContext context, TaskModel task) {
    final isExpired = task.isExpired;
    final statusColor = isExpired ? Colors.grey : getStatusColor(task.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),

        border: Border.all(color: Colors.grey.shade200),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(999),
                ),

                child: Text(
                  isExpired ? 'Expired' : getStatusText(task.status),

                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            task.description,
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),

          const SizedBox(height: 12),

          Text(
            'Deadline: ${task.deadlineText}',
            style: TextStyle(
              color: isExpired ? Colors.red : Colors.grey.shade600,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Text(
                  '+${task.expReward} EXP',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Text(
                  '${task.rewardAmount}đ',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (task.status == TaskStatus.pending && !isExpired)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  showSubmitDialog(context, task);
                },
                child: const Text('Submit Task'),
              ),
            ),

          if (task.status == TaskStatus.pending && isExpired)
            const SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                child: Text('Task Locked - Deadline Expired'),
              ),
            ),

          if (task.status == TaskStatus.submitted)
            const SizedBox(
              width: double.infinity,

              child: FilledButton(
                onPressed: null,
                child: Text('Waiting for Parent'),
              ),
            ),

          if (task.status == TaskStatus.approved)
            const SizedBox(
              width: double.infinity,

              child: FilledButton(onPressed: null, child: Text('Completed')),
            ),

          if (task.status == TaskStatus.rejected)
            const SizedBox(
              width: double.infinity,

              child: FilledButton(onPressed: null, child: Text('Rejected')),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;

    final filteredTasks = filterTasks(tasks);

    return Scaffold(
      backgroundColor: const Color(0xfffffaff),

      appBar: AppBar(title: const Text('Tasks'), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Task Management',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Theo dõi tiến độ nhiệm vụ',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),

            const SizedBox(height: 24),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  buildFilterChip('All'),
                  const SizedBox(width: 10),

                  buildFilterChip('Pending'),

                  const SizedBox(width: 10),

                  buildFilterChip('Submitted'),

                  const SizedBox(width: 10),

                  buildFilterChip('Approved'),

                  const SizedBox(width: 10),

                  buildFilterChip('Rejected'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(child: Text('No Tasks'))
                  : ListView.builder(
                      itemCount: filteredTasks.length,

                      itemBuilder: (context, index) {
                        return buildTaskCard(context, filteredTasks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
