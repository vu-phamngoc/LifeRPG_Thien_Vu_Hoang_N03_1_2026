import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: 'task_1',
      parentId: 'parent_1',
      childId: 'child_1',
      title: 'Làm bài tập toán',
      description: 'Hoàn thành bài tập toán trong vở bài tập.',
      difficulty: 'Dễ',
      expReward: 20,
      rewardAmount: 5000,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    ),
    TaskModel(
      id: 'task_2',
      parentId: 'parent_1',
      childId: 'child_1',
      title: 'Dọn phòng',
      description: 'Sắp xếp lại bàn học và giường ngủ.',
      difficulty: 'Trung bình',
      expReward: 30,
      rewardAmount: 10000,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    ),
  ];

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  List<TaskModel> get pendingTasks {
    return _tasks.where((task) => task.status == TaskStatus.pending).toList();
  }

  List<TaskModel> get submittedTasks {
    return _tasks.where((task) => task.status == TaskStatus.submitted).toList();
  }

  List<TaskModel> get approvedTasks {
    return _tasks.where((task) => task.status == TaskStatus.approved).toList();
  }

  void addTask({
    required String title,
    required String description,
    required String difficulty,
    required int expReward,
    required int rewardAmount,
  }) {
    final task = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: 'parent_1',
      childId: 'child_1',
      title: title,
      description: description,
      difficulty: difficulty,
      expReward: expReward,
      rewardAmount: rewardAmount,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );

    _tasks.add(task);
    notifyListeners();
  }

  void submitTask(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);

    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(
      status: TaskStatus.submitted,
      submittedAt: DateTime.now(),
    );

    notifyListeners();
  }

  void approveTask(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);

    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(
      status: TaskStatus.approved,
      verifiedAt: DateTime.now(),
    );

    notifyListeners();
  }

  void rejectTask(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);

    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(
      status: TaskStatus.rejected,
      verifiedAt: DateTime.now(),
    );

    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}
