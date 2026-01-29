import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'dashboard_analytics_screen.dart';
import 'clients_screen.dart';
import 'projects_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _authService.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGIO'),
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
            onPressed: _logout,
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clients'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}