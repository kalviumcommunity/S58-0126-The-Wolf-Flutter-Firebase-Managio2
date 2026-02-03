import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class DashboardAnalyticsScreen extends StatefulWidget {
  const DashboardAnalyticsScreen({super.key});

  @override
  State<DashboardAnalyticsScreen> createState() =>
      _DashboardAnalyticsScreenState();
}

class _DashboardAnalyticsScreenState
    extends State<DashboardAnalyticsScreen> {
  final FirestoreService _firestore = FirestoreService();
  
  // Key to force Future rebuild on retry
  int _futureKey = 0;

  Future<Map<String, dynamic>> _loadAnalytics() async {
    try {
      final analytics = await _firestore.getAnalytics();
      
      // Log for debugging
      debugPrint('Analytics loaded: $analytics');
      
      return analytics;
    } catch (e) {
      // Log error for debugging
      debugPrint('Error loading analytics: $e');
      rethrow; // Re-throw to be handled by FutureBuilder
    }
  }

  void _retryLoadingAnalytics() {
    setState(() {
      _futureKey++; // Change key to rebuild FutureBuilder
    });
  }

  String _getFriendlyErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorString.contains('permission')) {
      return 'Permission denied. Please contact support.';
    } else if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else {
      return 'Unable to load dashboard data. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _retryLoadingAnalytics,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        key: ValueKey(_futureKey), // Forces rebuild when key changes
        future: _loadAnalytics(),
        builder: (context, snapshot) {
          // LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading dashboard...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          // ERROR STATE
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to Load Dashboard',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getFriendlyErrorMessage(snapshot.error),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retryLoadingAnalytics,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // EMPTY/NULL DATA STATE (edge case)
          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Data Available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start adding projects and clients\nto see your analytics',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retryLoadingAnalytics,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            );
          }

          // SUCCESS STATE - Display analytics
          final analytics = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              _retryLoadingAnalytics();
              // Wait for rebuild
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here\'s your business overview',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Analytics Cards using GridView.builder
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final cards = [
                        {
                          'title': 'Total Earned',
                          'value':
                              '\$${analytics['totalEarned'].toStringAsFixed(2)}',
                          'icon': Icons.attach_money,
                          'color': Colors.green,
                        },
                        {
                          'title': 'Pending Amount',
                          'value':
                              '\$${analytics['pendingAmount'].toStringAsFixed(2)}',
                          'icon': Icons.hourglass_empty,
                          'color': Colors.orange,
                        },
                        {
                          'title': 'Active Projects',
                          'value': '${analytics['totalProjects']}',
                          'icon': Icons.work,
                          'color': Colors.blue,
                        },
                        {
                          'title': 'Overdue Tasks',
                          'value': '${analytics['overdueTasks']}',
                          'icon': Icons.warning,
                          'color': Colors.red,
                        },
                      ];

                      final card = cards[index];
                      return _buildAnalyticsCard(
                        title: card['title'] as String,
                        value: card['value'] as String,
                        icon: card['icon'] as IconData,
                        color: card['color'] as Color,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Quick Stats Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Stats',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                              'Total Tasks', '${analytics['totalTasks']}'),
                          const Divider(height: 24),
                          _buildStatRow(
                            'Completed Tasks',
                            '${analytics['totalTasks'] - analytics['overdueTasks']}',
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            'Completion Rate',
                            analytics['totalTasks'] > 0
                                ? '${((analytics['totalTasks'] - analytics['overdueTasks']) / analytics['totalTasks'] * 100).toStringAsFixed(1)}%'
                                : '0%',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Quick Actions Section
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Horizontal scrollable list of action buttons
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final actions = [
                          {
                            'label': 'New Project',
                            'icon': Icons.add,
                            'color': Colors.blue,
                          },
                          {
                            'label': 'Add Client',
                            'icon': Icons.person_add,
                            'color': Colors.green,
                          },
                          {
                            'label': 'Log Payment',
                            'icon': Icons.payment,
                            'color': Colors.orange,
                          },
                          {
                            'label': 'View Reports',
                            'icon': Icons.analytics,
                            'color': Colors.purple,
                          },
                        ];

                        final action = actions[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < actions.length - 1 ? 16 : 0,
                          ),
                          child: _buildActionButton(
                            action['label'] as String,
                            action['icon'] as IconData,
                            action['color'] as Color,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label tapped'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}