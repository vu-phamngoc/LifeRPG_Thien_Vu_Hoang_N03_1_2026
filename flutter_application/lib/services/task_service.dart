import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createTask({
    required String title,
    required String description,
    required String difficulty,
    required int expReward,
    required int rewardAmount,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User chưa đăng nhập');
    }

    await _firestore.collection('tasks').add({
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'expReward': expReward,
      'rewardAmount': rewardAmount,
      'createdBy': user.uid,
      'createdByEmail': user.email,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
