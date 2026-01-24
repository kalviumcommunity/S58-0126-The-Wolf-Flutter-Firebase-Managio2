import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final FirestoreService firestoreService = FirestoreService();
    final TextEditingController taskController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGIO Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration:
                        const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (taskController.text.isNotEmpty) {
                      firestoreService.addTask(taskController.text);
                      taskController.clear();
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestoreService.getTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView(
                  children: docs
                      .map(
                        (doc) => ListTile(
                          title: Text(doc['title']),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
