import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _controller = TextEditingController();

  // Example method showing correct usage of addTask
  Future<void> _addTaskExample() async {
    // You need to provide ALL required parameters
    await _firestore.addTask(
      projectId: 'your-project-id', // Required
      title: _controller.text,       // Required
      description: 'Task description', // Required
      deadline: DateTime.now().add(const Duration(days: 7)), // Required
      priority: 'medium',            // Required
      status: 'pending',             // Required
    );
  }

  // Example method showing correct usage of updateTask
  Future<void> _updateTaskExample(String taskId) async {
    // You need to provide ALL required parameters
    await _firestore.updateTask(
      taskId: taskId,                // Required
      title: 'Updated title',        // Required
      description: 'Updated description', // Required
      deadline: DateTime.now().add(const Duration(days: 7)), // Required
      priority: 'high',              // Required
      status: 'in-progress',         // Required
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Text('Dashboard Screen'),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}