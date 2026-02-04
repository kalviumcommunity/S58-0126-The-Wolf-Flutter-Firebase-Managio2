import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController taskController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
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
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                // AnimatedSwitcher: smoothly transitions between add icon and spinner
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: _isAdding
                      ? const SizedBox(
                          key: ValueKey('spinner'),
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          key: ValueKey('addButton'),
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            if (taskController.text.isNotEmpty) {
                              setState(() => _isAdding = true);
                              try {
                                await firestoreService.addTask(
                                  projectId: 'default-project',
                                  title: taskController.text,
                                  description: '',
                                  deadline: DateTime.now().add(const Duration(days: 7)),
                                  priority: 'medium',
                                  status: 'pending',
                                );
                                taskController.clear();
                              } finally {
                                if (mounted) setState(() => _isAdding = false);
                              }
                            }
                          },
                        ),
                ),
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

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // AnimatedOpacity: each list item fades in
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 300 + (index * 60)),
                      curve: Curves.easeIn,
                      child: ListTile(
                        title: Text(docs[index]['title']),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
} 