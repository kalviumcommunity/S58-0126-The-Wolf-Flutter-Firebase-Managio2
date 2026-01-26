import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreService _firestore = FirestoreService();
  final AuthService _authService = AuthService();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    final user = FirebaseAuth.instance.currentUser;
    print('Current user: ${user?.uid}');
    print('Current user email: ${user?.email}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGIO Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ADD TASK INPUT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'New Task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      try {
                        await _firestore.addTask(_controller.text);
                        _controller.clear();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Task added successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error adding task: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),

          // TASK LIST
          Expanded(
            child: StreamBuilder(
              stream: _firestore.getTasks(),
              builder: (context, snapshot) {
                // Show loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show error
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {}); // Rebuild to retry
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Show empty state
               // In the StreamBuilder's builder, replace the task list section:
if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.task_alt, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'No tasks yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        SizedBox(height: 8),
        Text(
          'Add your first task above',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

// Show tasks - SORT HERE
final docs = snapshot.data!.docs;

// Sort by createdAt descending (newest first)
docs.sort((a, b) {
  final aTime = a['createdAt'] as Timestamp;
  final bTime = b['createdAt'] as Timestamp;
  return bTime.compareTo(aTime);
});

print('Found ${docs.length} tasks');

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        title: Text(doc['title']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // EDIT BUTTON
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                try {
                                  await _firestore.updateTask(
                                    doc.id,
                                    '${doc['title']} (edited)',
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Task updated!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print('Error updating task: $e');
                                }
                              },
                            ),
                            // DELETE BUTTON
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await _firestore.deleteTask(doc.id);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Task deleted!'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print('Error deleting task: $e');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}