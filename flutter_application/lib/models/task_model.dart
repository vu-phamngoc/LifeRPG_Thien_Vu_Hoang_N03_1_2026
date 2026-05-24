enum TaskStatus { pending, submitted, approved, rejected }

class TaskModel {
  final String id;
  final String parentId;
  final String childId;
  final String title;
  final String description;
  final String difficulty;
  final int expReward;
  final int rewardAmount;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? verifiedAt;

  const TaskModel({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.expReward,
    required this.rewardAmount,
    required this.status,
    required this.createdAt,
    this.submittedAt,
    this.verifiedAt,
  });

  TaskModel copyWith({
    String? id,
    String? parentId,
    String? childId,
    String? title,
    String? description,
    String? difficulty,
    int? expReward,
    int? rewardAmount,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? submittedAt,
    DateTime? verifiedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      childId: childId ?? this.childId,
      title: title ?? this.title,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      expReward: expReward ?? this.expReward,
      rewardAmount: rewardAmount ?? this.rewardAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }

  String get statusText {
    switch (status) {
      case TaskStatus.pending:
        return 'Đang chờ làm';
      case TaskStatus.submitted:
        return 'Chờ phụ huynh xác nhận';
      case TaskStatus.approved:
        return 'Đã xác nhận';
      case TaskStatus.rejected:
        return 'Bị từ chối';
    }
  }
}
