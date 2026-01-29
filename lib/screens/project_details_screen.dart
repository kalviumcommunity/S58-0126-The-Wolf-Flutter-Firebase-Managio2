import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;
  final Map<String, dynamic> projectData;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    required this.projectData,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> with SingleTickerProviderStateMixin {
  final FirestoreService _firestore = FirestoreService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectData['title']),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tasks'),
            Tab(text: 'Payments'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTasksTab(),
          _buildPaymentsTab(),
        ],
      ),
    );
  }

  Widget _buildTasksTab() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDeadline;
    String selectedPriority = 'medium';

    return StatefulBuilder(
      builder: (context, setTaskState) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _showAddTaskDialog(titleController, descriptionController, setTaskState),
              child: const Text('Add Task'),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.getTasksByProject(widget.projectId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No tasks yet'));
                }

                final tasks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final data = task.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(data['title']),
                        subtitle: Text(data['priority']),
                        trailing: Checkbox(
                          value: data['status'] == 'completed',
                          onChanged: (value) async {
                            await _firestore.updateTask(
                              taskId: task.id,
                              title: data['title'],
                              description: data['description'],
                              deadline: (data['deadline'] as Timestamp).toDate(),
                              priority: data['priority'],
                              status: value ?? false ? 'completed' : 'pending',
                            );
                          },
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

  Widget _buildPaymentsTab() {
    final amountController = TextEditingController();
    DateTime? selectedDate;
    String selectedMethod = 'bank-transfer';

    return StatefulBuilder(
      builder: (context, setPaymentState) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => _showAddPaymentDialog(amountController, setPaymentState),
              child: const Text('Add Payment'),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.getPaymentsByProject(widget.projectId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No payments yet'));
                }

                final payments = snapshot.data!.docs;
                double totalReceived = 0;
                for (var payment in payments) {
                  if (payment['status'] == 'completed') {
                    totalReceived += payment['amount'];
                  }
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text('Total Earned: \$${totalReceived.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Budget: \$${widget.projectData['budget']}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          final data = payment.data() as Map<String, dynamic>;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text('\$${data['amount']}'),
                              subtitle: Text(data['paymentMethod']),
                              trailing: Chip(
                                label: Text(data['status']),
                                backgroundColor: data['status'] == 'completed' ? Colors.green : Colors.orange,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(TextEditingController titleController, TextEditingController descriptionController, StateSetter setTaskState) {
    DateTime? selectedDeadline;
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedPriority,
                  items: ['high', 'medium', 'low']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (value) => setDialogState(() => selectedPriority = value!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(selectedDeadline == null ? 'Select Deadline' : '${selectedDeadline!.toLocal()}'.split('.')[0]),
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
                      child: const Text('Pick'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && selectedDeadline != null) {
                  await _firestore.addTask(
                    projectId: widget.projectId,
                    title: titleController.text,
                    description: descriptionController.text,
                    deadline: selectedDeadline!,
                    priority: selectedPriority,
                    status: 'pending',
                  );
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentDialog(TextEditingController amountController, StateSetter setPaymentState) {
    DateTime? selectedDate;
    String selectedMethod = 'bank-transfer';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount (\$)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedMethod,
                  items: ['cash', 'bank-transfer', 'credit-card', 'paypal']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (value) => setDialogState(() => selectedMethod = value!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(selectedDate == null ? 'Select Date' : '${selectedDate!.toLocal()}'.split('.')[0]),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setDialogState(() => selectedDate = date);
                        }
                      },
                      child: const Text('Pick'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (amountController.text.isNotEmpty && selectedDate != null) {
                  await _firestore.addPayment(
                    projectId: widget.projectId,
                    clientId: widget.projectData['clientId'],
                    amount: double.parse(amountController.text),
                    paymentDate: selectedDate!,
                    paymentMethod: selectedMethod,
                    status: 'completed',
                  );
                  if (mounted) Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
