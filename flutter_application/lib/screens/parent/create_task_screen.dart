import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import '../../providers/activity_provider.dart';
import '../../services/task_service.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final expController = TextEditingController();
  final rewardController = TextEditingController();

  String difficulty = 'Dễ';
  bool isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    expController.dispose();
    rewardController.dispose();
    super.dispose();
  }

  Future<void> createTask() async {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên nhiệm vụ')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await TaskService().createTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        difficulty: difficulty,
        expReward: int.tryParse(expController.text) ?? 0,
        rewardAmount: int.tryParse(rewardController.text) ?? 0,
      );
      
      if (!mounted) return;

      context.read<TaskProvider>().addTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        difficulty: difficulty,
        expReward: int.tryParse(expController.text) ?? 0,
        rewardAmount: int.tryParse(rewardController.text) ?? 0,
      );

      context.read<ActivityProvider>().addActivity(
        title: 'Task Created',
        description: titleController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo nhiệm vụ thành công')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tạo nhiệm vụ: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo nhiệm vụ'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tên nhiệm vụ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: difficulty,
              items: ['Dễ', 'Trung bình', 'Khó']
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        difficulty = value!;
                      });
                    },
              decoration: InputDecoration(
                labelText: 'Độ khó',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: expController,
              enabled: !isLoading,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'EXP thưởng',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rewardController,
              enabled: !isLoading,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tiền thưởng',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading ? null : createTask,
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Tạo nhiệm vụ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}