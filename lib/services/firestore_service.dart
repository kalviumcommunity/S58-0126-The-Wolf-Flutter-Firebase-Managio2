import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserProfile(String email) async {
    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final uid = user.uid;
      print('Creating user profile for UID: $uid');

      await _db.collection('users').doc(uid).set({
        'email': email,
        'createdAt': Timestamp.now(),
      });

      print('User profile created successfully!');
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  Future<void> addTask(String title) async {
    try {
      final user = _auth.currentUser;
      
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final uid = user.uid;

      await _db.collection('tasks').add({
        'uid': uid,
        'title': title,
        'createdAt': Timestamp.now(),
      });

      print('Task added successfully!');
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

Stream<QuerySnapshot> getTasks() {
  final user = _auth.currentUser;
  
  if (user == null) {
    return const Stream.empty();
  }

  final uid = user.uid;

  // Query without orderBy (no index required)
  return _db
      .collection('tasks')
      .where('uid', isEqualTo: uid)
      .snapshots();
}

  Future<void> updateTask(String docId, String newTitle) async {
    try {
      await _db.collection('tasks').doc(docId).update({
        'title': newTitle,
      });
      print('Task updated successfully!');
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String docId) async {
    try {
      await _db.collection('tasks').doc(docId).delete();
      print('Task deleted successfully!');
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }
}