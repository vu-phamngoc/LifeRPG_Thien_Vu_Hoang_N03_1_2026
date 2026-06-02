import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createTask({
    required String title,
    required String description,
    required String difficulty,
    required int expReward,
    required int rewardAmount,
    required String childId,
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
      'parentId': user.uid,
      'childId': childId,
      'status': 'pending',
      'proofImage': null,
      'childNote': null,
      'submittedAt': null,
      'verifiedAt': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<TaskModel>> getTasksStream() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
      .collection('tasks')
      .where('childId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return TaskModel.fromMap(
        doc.data(),
        doc.id,
      );
    }).toList();
  });
}

  Future<void> approveTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': 'approved',
      'verifiedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': 'rejected',
      'verifiedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> submitTask({
    required String taskId,
    required String childNote,
    required String proofImage,
  }) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': 'submitted',
      'childNote': childNote,
      'proofImage': proofImage,
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }
}