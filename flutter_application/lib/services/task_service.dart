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

  Stream<List<TaskModel>> getTasksStream() async* {
  final user = _auth.currentUser;

  if (user == null) {
    yield <TaskModel>[];
    return;
  }

  final userDoc =
      await _firestore.collection('users').doc(user.uid).get();

  final role = userDoc.data()?['role'];

  Query<Map<String, dynamic>> query;

  if (role == 'parent') {
    query = _firestore
        .collection('tasks')
        .where('parentId', isEqualTo: user.uid);
  } else if (role == 'child') {
    query = _firestore
        .collection('tasks')
        .where('childId', isEqualTo: user.uid);
  } else {
    yield <TaskModel>[];
    return;
  }

  await for (final snapshot in query.snapshots()) {
    final tasks = snapshot.docs.map((doc) {
      return TaskModel.fromMap(doc.data(), doc.id);
    }).toList();

    yield tasks;
  }
}

  Future<void> approveTask(String taskId) async {
  final taskRef = _firestore.collection('tasks').doc(taskId);
  final taskDoc = await taskRef.get();

  if (!taskDoc.exists) {
    throw Exception('Không tìm thấy task');
  }

  final taskData = taskDoc.data()!;

  final childId = taskData['childId'];
  final expReward = taskData['expReward'] ?? 0;
  final rewardAmount = taskData['rewardAmount'] ?? 0;

  if (childId == null || childId.toString().isEmpty) {
    throw Exception('Task chưa có childId');
  }

  await _firestore.runTransaction((transaction) async {
    transaction.update(taskRef, {
      'status': 'approved',
      'verifiedAt': FieldValue.serverTimestamp(),
    });

    final childRef = _firestore.collection('children').doc(childId);
    final userRef = _firestore.collection('users').doc(childId);

    transaction.set(childRef, {
      'exp': FieldValue.increment(expReward),
      'coins': FieldValue.increment(rewardAmount),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    transaction.set(userRef, {
      'coins': FieldValue.increment(rewardAmount),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
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