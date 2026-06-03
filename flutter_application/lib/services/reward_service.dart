import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reward_model.dart';

class RewardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User chưa đăng nhập');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _rewardsRef {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('rewards');
  }

  Stream<List<RewardModel>> getRewardsStream() {
    return _rewardsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return RewardModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> seedDefaultRewardsIfNeeded() async {
    final snapshot = await _rewardsRef.limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      return;
    }

    final defaultRewards = [
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

    for (final reward in defaultRewards) {
      await _rewardsRef.doc(reward.id).set(reward.toMap());
    }
  }

  Future<void> redeemReward({
    required RewardModel reward,
  }) async {
    final userRef = _firestore.collection('users').doc(_uid);
    final rewardRef = _rewardsRef.doc(reward.id);
    final historyRef = userRef.collection('rewardHistory').doc();

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);

      final currentCoins = userSnapshot.data()?['coins'] ?? 0;

      if (currentCoins < reward.price) {
        throw Exception('Không đủ coins để đổi thưởng');
      }

      transaction.update(userRef, {
        'coins': currentCoins - reward.price,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.update(rewardRef, {
        'redeemed': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.set(historyRef, {
        ...reward.toMap(),
        'rewardId': reward.id,
        'redeemedAt': FieldValue.serverTimestamp(),
      });
    });
  }
  Stream<int> getCoinsStream() {
  return _firestore.collection('users').doc(_uid).snapshots().map((doc) {
    final data = doc.data();

    if (data == null) return 0;

    return data['coins'] ?? 0;
  });
}
}
