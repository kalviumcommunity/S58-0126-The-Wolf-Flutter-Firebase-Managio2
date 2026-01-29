import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final FirestoreService _firestore = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final companyController = TextEditingController();

  bool isLoading = false;

  Future<void> _addClient() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await _firestore.addClient(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          company: companyController.text.trim(),
        );

        nameController.clear();
        emailController.clear();
        phoneController.clear();
        companyController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Client added successfully!'), backgroundColor: Colors.green),
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

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Client'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Client Name'),
                  validator: (value) => value?.isEmpty ?? true ? 'Name required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) => value?.isEmpty ?? true ? 'Email required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) => value?.isEmpty ?? true ? 'Phone required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: 'Company'),
                  validator: (value) => value?.isEmpty ?? true ? 'Company required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          isLoading
              ? const Padding(padding: EdgeInsets.all(8.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()))
              : ElevatedButton(onPressed: _addClient, child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Clients')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.getClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No clients yet!', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showAddClientDialog,
                    child: const Text('Add Your First Client'),
                  ),
                ],
              ),
            );
          }

          final clients = snapshot.data!.docs;

          // Using ListView.builder for efficient scrolling (Assignment 2.19)
          return ListView.builder(
            itemCount: clients.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final client = clients[index];
              final data = client.data() as Map<String, dynamic>;

              // Enhanced Card design with better visual hierarchy
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.primaries[index % Colors.primaries.length],
                    child: Text(
                      data['name'][0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    data['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.business, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(data['company']),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data['email'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                        onTap: () => _showEditDialog(client.id, data),
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        onTap: () => _deleteClient(client.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(String clientId, Map<String, dynamic> data) {
    nameController.text = data['name'];
    emailController.text = data['email'];
    phoneController.text = data['phone'];
    companyController.text = data['company'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Client'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 12),
                TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 12),
                TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                const SizedBox(height: 12),
                TextFormField(controller: companyController, decoration: const InputDecoration(labelText: 'Company')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestore.updateClient(
                  clientId: clientId,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  company: companyController.text,
                );
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteClient(String clientId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: const Text('Are you sure you want to delete this client?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestore.deleteClient(clientId);
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyController.dispose();
    super.dispose();
  }
}