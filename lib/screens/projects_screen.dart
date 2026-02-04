import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'project_details_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final FirestoreService _firestore = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final budgetController = TextEditingController();
  DateTime? selectedDeadline;
  String selectedStatus = 'active';
  String? selectedClientId;

  bool isLoading = false;

  Future<void> _addProject() async {
    if (_formKey.currentState!.validate() && selectedClientId != null && selectedDeadline != null) {
      setState(() => isLoading = true);

      try {
        await _firestore.addProject(
          clientId: selectedClientId!,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          budget: double.parse(budgetController.text),
          deadline: selectedDeadline!,
          status: selectedStatus,
        );

        titleController.clear();
        descriptionController.clear();
        budgetController.clear();
        selectedDeadline = null;
        selectedClientId = null;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project added!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Project'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore.getClients(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      return DropdownButton<String>(
                        hint: const Text('Select Client'),
                        value: selectedClientId,
                        items: snapshot.data!.docs
                            .map((doc) => DropdownMenuItem(
                                  value: doc.id,
                                  child: Text(doc['name']),
                                ))
                            .toList(),
                        onChanged: (value) => setDialogState(() => selectedClientId = value),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Project Title'),
                    validator: (value) => value?.isEmpty ?? true ? 'Title required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: budgetController,
                    decoration: const InputDecoration(labelText: 'Budget (\$)'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value?.isEmpty ?? true ? 'Budget required' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(selectedDeadline == null
                            ? 'Select Deadline'
                            : '${selectedDeadline!.toLocal()}'.split('.')[0]),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setDialogState(() => selectedDeadline = date);
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedStatus,
                    items: ['active', 'completed', 'on-hold']
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (value) => setDialogState(() => selectedStatus = value!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _addProject, child: const Text('Add')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Projects')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.getProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.work, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No projects yet!', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddProjectDialog,
                    child: const Text('Create Your First Project'),
                  ),
                ],
              ),
            );
          }

          final projects = snapshot.data!.docs;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              final data = project.data() as Map<String, dynamic>;
              final deadline = (data['deadline'] as Timestamp).toDate();
              final isOverdue = deadline.isBefore(DateTime.now()) && data['status'] != 'completed';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isOverdue ? Colors.red : Colors.blue,
                    child: const Icon(Icons.work, color: Colors.white),
                  ),
                  title: Text(data['title']),
                  subtitle: Text('\$${data['budget']} • ${data['status']}'),
                  trailing: isOverdue ? const Icon(Icons.warning, color: Colors.red) : null,
                  onTap: () => Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        ProjectDetailsScreen(projectId: project.id, projectData: data),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 600),
  ),
),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    super.dispose();
  }
}
