import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _activitiesRef(String childId) {
    return _firestore
        .collection('users')
        .doc(childId)
        .collection('activities');
  }

  Future<void> addActivity({
    required String childId,
    required String title,
    required String description,
  }) async {
    await _activitiesRef(childId).add({
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getActivities(String childId) {
    return _activitiesRef(childId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
