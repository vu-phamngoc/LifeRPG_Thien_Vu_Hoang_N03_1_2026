import 'package:flutter/material.dart';

import '../models/reward_model.dart';

class RewardProvider extends ChangeNotifier {
  int coins = 1200;

  final List<RewardModel> _rewards = [
    const RewardModel(
      id: '1',
      title: 'Favorite Meal',
      description: 'Đổi một bữa ăn yêu thích cuối tuần.',
      price: 300,
      icon: '🍔',
      redeemed: false,
    ),
    const RewardModel(
      id: '2',
      title: 'Gaming Time',
      description: 'Thêm 1 giờ chơi game sau khi học xong.',
      price: 500,
      icon: '🎮',
      redeemed: false,
    ),
    const RewardModel(
      id: '3',
      title: 'Movie Night',
      description: 'Một buổi xem phim cùng gia đình.',
      price: 800,
      icon: '🍿',
      redeemed: false,
    ),
    const RewardModel(
      id: '4',
      title: 'New Headphone',
      description: 'Phần thưởng đặc biệt cần nhiều coin hơn.',
      price: 1500,
      icon: '🎧',
      redeemed: false,
    ),
  ];

  final List<RewardModel> _history = [];

  List<RewardModel> get rewards => _rewards;

  List<RewardModel> get history => List.unmodifiable(_history.reversed);

  int get redeemedCount {
    return _history.length;
  }

  bool canRedeem(int price) {
    return coins >= price;
  }

  void addCoins(int amount) {
    coins += amount;
    notifyListeners();
  }

  void redeemReward(String rewardId) {
    final index = _rewards.indexWhere((reward) => reward.id == rewardId);

    if (index == -1) return;

    final reward = _rewards[index];

    if (coins < reward.price) return;

    coins -= reward.price;

    _history.add(reward.copyWith(redeemed: true));

    notifyListeners();
  }
}
