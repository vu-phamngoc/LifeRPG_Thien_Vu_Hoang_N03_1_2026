import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<TaskModel> _taskList = [];

  List<TaskModel> get taskList => _taskList;

  void addTask({
    required String id,
    required String title,
    required String description,
    required int expReward,
    required int goldReward,
  }) {
    final task = TaskModel(
      id: id,
      title: title,
      description: description,
      expReward: expReward,
      goldReward: goldReward,
    );

    _taskList.add(task);

    notifyListeners();
  }

  void removeTask(String id) {
    _taskList.removeWhere((task) => task.id == id);

    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _taskList.indexWhere((task) => task.id == id);

    if (index != -1) {
      final currentTask = _taskList[index];

      _taskList[index] = TaskModel(
        id: currentTask.id,
        title: currentTask.title,
        description: currentTask.description,
        expReward: currentTask.expReward,
        goldReward: currentTask.goldReward,
        status: !currentTask.status,
      );

      notifyListeners();
    }
  }
}
