import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ==================== USER PROFILE ====================
  Future<void> createUserProfile(String email) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      final uid = user.uid;
      print('Creating user profile for UID: $uid');

      await _db.collection('users').doc(uid).set({
        'email': email,
        'fullName': '',
        'phone': '',
        'bio': '',
        'hourlyRate': 0.0,
        'skills': [],
        'profileImage': '',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      print('User profile created successfully!');
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
    required String bio,
    required double hourlyRate,
    required List<String> skills,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _db.collection('users').doc(user.uid).update({
        'fullName': fullName,
        'phone': phone,
        'bio': bio,
        'hourlyRate': hourlyRate,
        'skills': skills,
        'updatedAt': Timestamp.now(),
      });

      print('User profile updated successfully!');
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> getUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      return await _db.collection('users').doc(user.uid).get();
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  // ==================== CLIENT MANAGEMENT ====================
  Future<void> addClient({
    required String name,
    required String email,
    required String phone,
    required String company,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _db.collection('clients').add({
        'uid': user.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'company': company,
        'totalEarnings': 0.0,
        'projectCount': 0,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      print('Client added successfully!');
    } catch (e) {
      print('Error adding client: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getClients() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('clients')
        .where('uid', isEqualTo: user.uid)
        .snapshots();
  }

  Future<void> updateClient({
    required String clientId,
    required String name,
    required String email,
    required String phone,
    required String company,
  }) async {
    try {
      await _db.collection('clients').doc(clientId).update({
        'name': name,
        'email': email,
        'phone': phone,
        'company': company,
        'updatedAt': Timestamp.now(),
      });

      print('Client updated successfully!');
    } catch (e) {
      print('Error updating client: $e');
      rethrow;
    }
  }

  Future<void> deleteClient(String clientId) async {
    try {
      await _db.collection('clients').doc(clientId).delete();
      print('Client deleted successfully!');
    } catch (e) {
      print('Error deleting client: $e');
      rethrow;
    }
  }

  // ==================== PROJECT MANAGEMENT ====================
  Future<void> addProject({
    required String clientId,
    required String title,
    required String description,
    required double budget,
    required DateTime deadline,
    required String status,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _db.collection('projects').add({
        'uid': user.uid,
        'clientId': clientId,
        'title': title,
        'description': description,
        'budget': budget,
        'deadline': Timestamp.fromDate(deadline),
        'status': status, // active, completed, on-hold
        'completedTasks': 0,
        'totalTasks': 0,
        'amountEarned': 0.0,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      print('Project added successfully!');
    } catch (e) {
      print('Error adding project: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getProjects() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('projects')
        .where('uid', isEqualTo: user.uid)
        .snapshots();
  }

  Future<void> updateProject({
    required String projectId,
    required String title,
    required String description,
    required double budget,
    required DateTime deadline,
    required String status,
  }) async {
    try {
      await _db.collection('projects').doc(projectId).update({
        'title': title,
        'description': description,
        'budget': budget,
        'deadline': Timestamp.fromDate(deadline),
        'status': status,
        'updatedAt': Timestamp.now(),
      });

      print('Project updated successfully!');
    } catch (e) {
      print('Error updating project: $e');
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _db.collection('projects').doc(projectId).delete();
      print('Project deleted successfully!');
    } catch (e) {
      print('Error deleting project: $e');
      rethrow;
    }
  }

  // ==================== TASK MANAGEMENT ====================
  Future<void> addTask({
    required String projectId,
    required String title,
    required String description,
    required DateTime deadline,
    required String priority,
    required String status,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _db.collection('tasks').add({
        'uid': user.uid,
        'projectId': projectId,
        'title': title,
        'description': description,
        'deadline': Timestamp.fromDate(deadline),
        'priority': priority, // high, medium, low
        'status': status, // pending, in-progress, completed
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      print('Task added successfully!');
    } catch (e) {
      print('Error adding task: $e');
      rethrow;
    }
  }

  // FIXED: Removed orderBy to avoid index requirement
  Stream<QuerySnapshot> getTasks() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('tasks')
        .where('uid', isEqualTo: user.uid)
        .snapshots();
  }

  // FIXED: Removed orderBy to avoid index requirement
  Stream<QuerySnapshot> getTasksByProject(String projectId) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('tasks')
        .where('uid', isEqualTo: user.uid)
        .where('projectId', isEqualTo: projectId)
        .snapshots();
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
    required DateTime deadline,
    required String priority,
    required String status,
  }) async {
    try {
      await _db.collection('tasks').doc(taskId).update({
        'title': title,
        'description': description,
        'deadline': Timestamp.fromDate(deadline),
        'priority': priority,
        'status': status,
        'updatedAt': Timestamp.now(),
      });

      print('Task updated successfully!');
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('tasks').doc(taskId).delete();
      print('Task deleted successfully!');
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  // ==================== PAYMENT TRACKING ====================
  Future<void> addPayment({
    required String projectId,
    required String clientId,
    required double amount,
    required DateTime paymentDate,
    required String paymentMethod,
    required String status,
    String notes = '',
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _db.collection('payments').add({
        'uid': user.uid,
        'projectId': projectId,
        'clientId': clientId,
        'amount': amount,
        'paymentDate': Timestamp.fromDate(paymentDate),
        'paymentMethod': paymentMethod, // cash, bank-transfer, credit-card, paypal
        'status': status, // pending, completed, cancelled
        'notes': notes,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });

      print('Payment added successfully!');
    } catch (e) {
      print('Error adding payment: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getPayments() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('payments')
        .where('uid', isEqualTo: user.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getPaymentsByProject(String projectId) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection('payments')
        .where('uid', isEqualTo: user.uid)
        .where('projectId', isEqualTo: projectId)
        .snapshots();
  }

  Future<void> updatePayment({
    required String paymentId,
    required double amount,
    required DateTime paymentDate,
    required String paymentMethod,
    required String status,
    required String notes,
  }) async {
    try {
      await _db.collection('payments').doc(paymentId).update({
        'amount': amount,
        'paymentDate': Timestamp.fromDate(paymentDate),
        'paymentMethod': paymentMethod,
        'status': status,
        'notes': notes,
        'updatedAt': Timestamp.now(),
      });

      print('Payment updated successfully!');
    } catch (e) {
      print('Error updating payment: $e');
      rethrow;
    }
  }

  Future<void> deletePayment(String paymentId) async {
    try {
      await _db.collection('payments').doc(paymentId).delete();
      print('Payment deleted successfully!');
    } catch (e) {
      print('Error deleting payment: $e');
      rethrow;
    }
  }

  // ==================== ANALYTICS ====================
  // FIXED: Removed isNotEqualTo and filter in memory instead
  Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      final uid = user.uid;

      // Total projects
      final projectsSnapshot = await _db
          .collection('projects')
          .where('uid', isEqualTo: uid)
          .get();

      // Total earned
      final paymentsSnapshot = await _db
          .collection('payments')
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: 'completed')
          .get();

      double totalEarned = 0;
      for (var doc in paymentsSnapshot.docs) {
        totalEarned += doc['amount'] as double;
      }

      // Pending payments
      final pendingPaymentsSnapshot = await _db
          .collection('payments')
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: 'pending')
          .get();

      double pendingAmount = 0;
      for (var doc in pendingPaymentsSnapshot.docs) {
        pendingAmount += doc['amount'] as double;
      }

      // Get ALL tasks (removed status filter)
      final tasksSnapshot = await _db
          .collection('tasks')
          .where('uid', isEqualTo: uid)
          .get();

      // Filter in memory instead of Firestore query
      int overdueTasks = 0;
      int completedTasks = 0;
      final now = DateTime.now();
      
      for (var doc in tasksSnapshot.docs) {
        final status = doc['status'] as String;
        final deadline = (doc['deadline'] as Timestamp).toDate();
        
        if (status == 'completed') {
          completedTasks++;
        } else if (deadline.isBefore(now)) {
          overdueTasks++;
        }
      }

      return {
        'totalProjects': projectsSnapshot.docs.length,
        'totalEarned': totalEarned,
        'pendingAmount': pendingAmount,
        'overdueTasks': overdueTasks,
        'totalTasks': tasksSnapshot.docs.length,
        'completedTasks': completedTasks,
      };
    } catch (e) {
      print('Error fetching analytics: $e');
      rethrow;
    }
  }
}