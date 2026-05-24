class TaskModel {
  final String id;
  final String title;
  final String description;
  final int expReward;
  final int goldReward;
  final bool status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.expReward,
    required this.goldReward,
    this.status = false,
  });
}
