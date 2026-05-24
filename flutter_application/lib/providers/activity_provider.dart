import 'package:flutter/material.dart';

import '../models/activity_model.dart';

class ActivityProvider extends ChangeNotifier {
  final List<ActivityModel> _activities = [];

  List<ActivityModel> get activities => List.unmodifiable(_activities.reversed);

  void addActivity({required String title, required String description}) {
    _activities.add(
      ActivityModel(
        title: title,
        description: description,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
