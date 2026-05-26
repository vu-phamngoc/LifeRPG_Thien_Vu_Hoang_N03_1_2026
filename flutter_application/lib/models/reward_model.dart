class RewardModel {
  final String id;
  final String title;
  final String description;
  final int price;
  final String icon;
  final bool redeemed;

  const RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.icon,
    required this.redeemed,
  });

  RewardModel copyWith({
    String? id,
    String? title,
    String? description,
    int? price,
    String? icon,
    bool? redeemed,
  }) {
    return RewardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      redeemed: redeemed ?? this.redeemed,
    );
  }
}
