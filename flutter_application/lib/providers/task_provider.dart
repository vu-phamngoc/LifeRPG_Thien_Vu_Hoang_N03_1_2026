import 'dart:async';

import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<TaskModel> _tasks = [];
  StreamSubscription<List<TaskModel>>? _tasksSubscription;

  TaskProvider() {
    listenToTasks();
  }

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

  void listenToTasks() {
    _tasksSubscription?.cancel();

    _tasksSubscription = _taskService.getTasksStream().listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
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

  void submitTask(String taskId, {String? childNote, String? proofImage}) {
    final index = _tasks.indexWhere((task) => task.id == taskId);

    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(
      status: TaskStatus.submitted,
      submittedAt: DateTime.now(),
      childNote: childNote,
      proofImage: proofImage,
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

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}