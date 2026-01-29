import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestore = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _hourlyRateController;

  bool isLoading = false;
  bool isEditing = false;
  List<String> skills = [];
  TextEditingController skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _hourlyRateController = TextEditingController();
  }

  Future<void> _loadProfile() async {
    try {
      final snapshot = await _firestore.getUserProfile();
      final data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        _fullNameController.text = data['fullName'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _hourlyRateController.text = (data['hourlyRate'] ?? 0).toString();
        skills = List<String>.from(data['skills'] ?? []);
      });
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> _updateProfile() async {
    if (_fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full name is required'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await _firestore.updateUserProfile(
        fullName: _fullNameController.text,
        phone: _phoneController.text,
        bio: _bioController.text,
        hourlyRate: double.parse(_hourlyRateController.text.isEmpty ? '0' : _hourlyRateController.text),
        skills: skills,
      );

      setState(() => isEditing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green),
        );
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Profile not found'));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final email = _auth.currentUser?.email ?? 'No email';

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Text(
                      userData['fullName'].isNotEmpty
                          ? userData['fullName'][0].toUpperCase()
                          : email[0].toUpperCase(),
                      style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData['fullName'] ?? 'User',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(email, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Edit/Save Button
            Center(
              child: isEditing
                  ? isLoading
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => setState(() => isEditing = false),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _updateProfile,
                              child: const Text('Save'),
                            ),
                          ],
                        )
                  : ElevatedButton(
                      onPressed: () {
                        _loadProfile();
                        setState(() => isEditing = true);
                      },
                      child: const Text('Edit Profile'),
                    ),
            ),

            const SizedBox(height: 24),

            // Profile Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameController,
                      enabled: isEditing,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      enabled: isEditing,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _hourlyRateController,
                      enabled: isEditing,
                      decoration: const InputDecoration(labelText: 'Hourly Rate (\$)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bioController,
                      enabled: isEditing,
                      decoration: const InputDecoration(labelText: 'Bio'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Skills Section
            const Text('Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (isEditing)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: skillController,
                      decoration: const InputDecoration(
                        labelText: 'Add skill',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (skillController.text.isNotEmpty) {
                        setState(() {
                          skills.add(skillController.text);
                          skillController.clear();
                        });
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            if (skills.isNotEmpty)
              Wrap(
                spacing: 8,
                children: skills
                    .map((skill) => Chip(
                          label: Text(skill),
                          onDeleted: isEditing
                              ? () => setState(() => skills.remove(skill))
                              : null,
                        ))
                    .toList(),
              )
            else
              const Text('No skills added yet', style: TextStyle(color: Colors.grey)),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _hourlyRateController.dispose();
    skillController.dispose();
    super.dispose();
  }
}
