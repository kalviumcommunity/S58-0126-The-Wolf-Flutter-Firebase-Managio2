import 'package:flutter/material.dart';

/// STATELESS WIDGET DEMO
/// This widget displays a static header that doesn't change unless the parent
/// rebuilds it with different parameters.
class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print('[STATELESS] AppHeader built with title: $title');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

/// STATELESS WIDGET - Information Card
/// Displays static information about the current feature
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue.shade600),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// STATEFUL WIDGET DEMO
/// This widget manages interactive state and demonstrates how setState() works
class InteractiveCounter extends StatefulWidget {
  const InteractiveCounter({super.key});

  @override
  State<InteractiveCounter> createState() => _InteractiveCounterState();
}

class _InteractiveCounterState extends State<InteractiveCounter> {
  int count = 0;
  bool isDarkMode = false;
  List<String> history = [];
  bool showHistory = false;

  void _increment() {
    setState(() {
      count++;
      history.add('Incremented to $count');
      print('[STATEFUL] Counter incremented: $count');
    });
  }

  void _decrement() {
    setState(() {
      if (count > 0) {
        count--;
        history.add('Decremented to $count');
        print('[STATEFUL] Counter decremented: $count');
      }
    });
  }

  void _reset() {
    setState(() {
      count = 0;
      history.add('Reset counter to 0');
      history.clear();
      print('[STATEFUL] Counter reset');
    });
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
      history.add(isDarkMode ? 'Switched to Dark Mode' : 'Switched to Light Mode');
      print('[STATEFUL] Dark mode toggled: $isDarkMode');
    });
  }

  void _toggleHistory() {
    setState(() {
      showHistory = !showHistory;
      print('[STATEFUL] History visibility toggled: $showHistory');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('[STATEFUL] _InteractiveCounterState.build() called - count: $count');

    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      color: isDarkMode ? Colors.grey.shade900 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Counter Display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade800 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade300,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Current Count',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  icon: Icons.remove,
                  label: 'Decrease',
                  onPressed: _decrement,
                  color: Colors.red,
                ),
                _buildButton(
                  icon: Icons.refresh,
                  label: 'Reset',
                  onPressed: _reset,
                  color: Colors.orange,
                ),
                _buildButton(
                  icon: Icons.add,
                  label: 'Increase',
                  onPressed: _increment,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mode Toggle
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleDarkMode,
                    icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    label: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.blue.shade100,
                      foregroundColor: isDarkMode ? Colors.white : Colors.blue.shade900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleHistory,
                    icon: Icon(showHistory ? Icons.visibility_off : Icons.visibility),
                    label: Text(showHistory ? 'Hide History' : 'Show History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.purple.shade100,
                      foregroundColor: isDarkMode ? Colors.white : Colors.purple.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // History Section (Conditional Rendering)
            if (showHistory && history.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade800 : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Action History',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.amber.shade300 : Colors.amber.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...history.asMap().entries.map((e) {
                      final index = e.key;
                      final action = e.value;
                      return Text(
                        '${index + 1}. $action',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                        ),
                      );
                    }),
                  ],
                ),
              ),

            if (showHistory && history.isEmpty)
              Text(
                'No actions yet',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          mini: true,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

/// MAIN DEMO SCREEN
/// Combines StatelessWidget and StatefulWidget to show both patterns
class StatelessStatefulDemoScreen extends StatelessWidget {
  const StatelessStatefulDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless & Stateful Widgets'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static Header (Stateless Widget)
            const AppHeader(
              title: 'Flutter Widget Demo',
              subtitle: 'Understanding Stateless & Stateful Widgets',
            ),
            const SizedBox(height: 24),

            // Feature Description (Stateless Widgets)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'What You\'ll Learn',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const FeatureCard(
              icon: Icons.panorama_photosphere_select,
              title: 'Stateless Widgets',
              description: 'Static UI that doesn\'t change unless parent rebuilds. Perfect for static content.',
            ),
            const FeatureCard(
              icon: Icons.stacked_line_chart,
              title: 'Stateful Widgets',
              description: 'Dynamic UI that responds to user interactions. Uses setState() to update.',
            ),
            const FeatureCard(
              icon: Icons.update,
              title: 'State Management',
              description: 'Learn how Flutter efficiently rebuilds only the widgets that changed.',
            ),
            const SizedBox(height: 24),

            // Interactive Counter (Stateful Widget)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Interactive Example',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const InteractiveCounter(),
            const SizedBox(height: 24),

            // Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Key Concepts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint('StatelessWidget: Immutable, no internal state, fast to render'),
                  _buildBulletPoint('StatefulWidget: Mutable, manages state with setState(), reactive'),
                  _buildBulletPoint('setState(): Triggers rebuild of widget and its children'),
                  _buildBulletPoint('Element Tree: Reuses components efficiently between rebuilds'),
                  _buildBulletPoint('Reactive Model: UI automatically reflects current state'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
