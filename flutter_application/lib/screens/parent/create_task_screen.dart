import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/activity_provider.dart';
import '../../services/task_service.dart';
import '../../providers/family_provider.dart';

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
  String? selectedChildId;
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
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final expReward = int.tryParse(expController.text.trim()) ?? 0;
    final rewardAmount = int.tryParse(rewardController.text.trim()) ?? 0;
    
    if (selectedChildId == null || selectedChildId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn Child')),
      );
      return;
    }

    if (title.isEmpty) {
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
        title: title,
        description: description,
        difficulty: difficulty,
        expReward: expReward,
        rewardAmount: rewardAmount,
        childId: selectedChildId!,
      );

      if (!mounted) return;

      context.read<ActivityProvider>().addActivity(
  childId: selectedChildId!,
  title: 'Task Created',
  description: title,
);

      titleController.clear();
      descriptionController.clear();
      expController.clear();
      rewardController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo nhiệm vụ thành công')),
      );
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

    final familyProvider = context.watch<FamilyProvider>();

    if (familyProvider.children.isEmpty) {
      Future.microtask(() {
        familyProvider.listenToLinkedChildren();
      });
    }  

    return Scaffold(
      backgroundColor: const Color(0xfffffaff),
      appBar: AppBar(
        title: const Text('Tạo nhiệm vụ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
  initialValue: selectedChildId,
  items: familyProvider.children.map(
    (child) {
      final childId = child['uid'] ?? '';
      final childName = child['username']?.toString().isNotEmpty == true
          ? child['username']
          : child['email'] ?? childId;

      return DropdownMenuItem<String>(
        value: childId,
        child: Text(childName),
      );
    },
  ).toList(),
  onChanged: isLoading
      ? null
      : (value) {
          setState(() {
            selectedChildId = value;
          });
        },
  decoration: InputDecoration(
    labelText: 'Chọn Child',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
),

const SizedBox(height: 16),
            TextField(
              controller: titleController,
              enabled: !isLoading,
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
              enabled: !isLoading,
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
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: isLoading
                  ? null
                  : (value) {
                      if (value == null) return;
                      setState(() {
                        difficulty = value;
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