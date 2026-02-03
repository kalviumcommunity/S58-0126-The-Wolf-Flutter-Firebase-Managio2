import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'dashboard_analytics_screen.dart';
import 'clients_screen.dart';
import 'projects_screen.dart';
import 'profile_screen.dart';
import 'scrollable_views_screen.dart';
import 'stateless_stateful_demo.dart';

class DashboardMainScreen extends StatefulWidget {
  const DashboardMainScreen({super.key});

  @override
  State<DashboardMainScreen> createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const DashboardAnalyticsScreen(),
    const ProjectsScreen(),
    const ClientsScreen(),
    const ProfileScreen(),
  ];

  final List<String> _screenTitles = ['Dashboard', 'Projects', 'Clients', 'Profile'];

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () async {
              // Close the dialog first
              Navigator.pop(context);
              
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
              
              try {
                // Sign out - this will trigger authStateChanges() in main.dart
                // which will automatically redirect to LoginScreen
                await _authService.signOut();
                
                // Close loading dialog
                if (mounted) {
                  Navigator.pop(context);
                  
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                // Close loading dialog
                if (mounted) {
                  Navigator.pop(context);
                  
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error logging out: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
              
              // No manual navigation needed!
              // authStateChanges() will automatically redirect to LoginScreen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get current user email for display
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('MANAGIO'),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 4,
        actions: [
          // Demo button for Assignment 2.19 - Scrollable Views
          IconButton(
            icon: const Icon(Icons.view_list),
            tooltip: 'Scrollable Views Demo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScrollableViewsScreen(),
                ),
              );
            },
          ),
          // Demo button for Assignment 2.14 - Stateless/Stateful Widgets
          IconButton(
            icon: const Icon(Icons.widgets),
            tooltip: 'Widget Types Demo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatelessStatefulDemoScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), 
            label: 'Dashboard'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work), 
            label: 'Projects'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people), 
            label: 'Clients'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Profile'
          ),
        ],
      ),
    );
  }
}