class Task {
  String id;
  String title;
  String description;
  String status; // pending / submitted / approved / rejected
  int expReward;
  String childId;
  String parentId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.expReward,
    required this.childId,
    required this.parentId,
  });
}