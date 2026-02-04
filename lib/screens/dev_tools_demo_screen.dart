import 'package:flutter/material.dart';

/// Assignment 2.15: Demonstrating Hot Reload, Debug Console, and Flutter DevTools
/// 
/// This screen showcases effective usage of Flutter development tools:
/// 1. Hot Reload - Instant UI updates without losing state
/// 2. Debug Console - Runtime logging and debugging
/// 3. Flutter DevTools - Performance and widget inspection
/// 
/// HOW TO USE THIS DEMO:
/// 
/// 1. HOT RELOAD DEMONSTRATION:
///    - Run the app with `flutter run`
///    - Change any text, color, or widget property below
///    - Press 'r' in terminal or click Hot Reload button
///    - Changes appear instantly without losing app state
/// 
/// 2. DEBUG CONSOLE DEMONSTRATION:
///    - Interact with the counters and buttons
///    - Check the Debug Console for printed logs
///    - Each action logs detailed information
/// 
/// 3. FLUTTER DEVTOOLS DEMONSTRATION:
///    - Open DevTools while app is running
///    - Use Widget Inspector to examine the widget tree
///    - Check Performance tab for frame rendering
///    - Monitor Memory tab for memory usage

class DevToolsDemoScreen extends StatefulWidget {
  const DevToolsDemoScreen({super.key});

  @override
  State<DevToolsDemoScreen> createState() => _DevToolsDemoScreenState();
}

class _DevToolsDemoScreenState extends State<DevToolsDemoScreen> {
  int _counter = 0;
  int _hotReloadCounter = 0;
  MaterialColor _currentColor = Colors.blue;  // ✅ FIXED: Changed from Color to MaterialColor
  String _currentText = 'Original Text';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _logToConsole('🎬 DevToolsDemoScreen initialized');
    debugPrint('═══════════════════════════════════════════════════');
    debugPrint('📱 Dev Tools Demo Screen Loaded');
    debugPrint('💡 TIP: Open Flutter DevTools to inspect this screen');
    debugPrint('═══════════════════════════════════════════════════');
  }

  @override
  void dispose() {
    _logToConsole('🛑 DevToolsDemoScreen disposed');
    super.dispose();
  }

  void _logToConsole(String message) {
    final timestamp = DateTime.now().toString().split('.')[0];
    final logMessage = '[$timestamp] $message';
    debugPrint(logMessage);
    
    setState(() {
      _logs.insert(0, logMessage);
      if (_logs.length > 10) _logs.removeLast();
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _logToConsole('➕ Counter incremented to $_counter');
    debugPrint('   State updated successfully');
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
    _logToConsole('➖ Counter decremented to $_counter');
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _logToConsole('🔄 Counter reset to 0');
  }

  void _changeColor() {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];
    
    setState(() {
      final currentIndex = colors.indexOf(_currentColor);
      _currentColor = colors[(currentIndex + 1) % colors.length];
    });
    
    _logToConsole('🎨 Color changed to ${_currentColor.toString()}');
  }

  void _changeText() {
    final texts = [
      'Original Text',
      'Hot Reload Works!',
      'Changed Text',
      'Flutter is Amazing!',
      'DevTools Demo',
    ];
    
    setState(() {
      final currentIndex = texts.indexOf(_currentText);
      _currentText = texts[(currentIndex + 1) % texts.length];
    });
    
    _logToConsole('📝 Text changed to "$_currentText"');
  }

  void _simulateHotReload() {
    setState(() {
      _hotReloadCounter++;
    });
    _logToConsole('🔥 Hot Reload simulation #$_hotReloadCounter');
    debugPrint('   💡 TIP: Try changing widget properties and press Hot Reload!');
  }

  void _triggerPerformanceTest() {
    _logToConsole('⚡ Performance test started');
    
    // Simulate some work
    List<int> largeList = [];
    for (int i = 0; i < 10000; i++) {
      largeList.add(i);
    }
    
    final sum = largeList.reduce((a, b) => a + b);
    
    _logToConsole('✅ Performance test completed. Sum: $sum');
    debugPrint('   💡 Check DevTools Performance tab for frame rendering');
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
    _logToConsole('🗑️ Logs cleared');
  }

  @override
  Widget build(BuildContext context) {
    // Log every rebuild (helps demonstrate Hot Reload)
    debugPrint('🔄 DevToolsDemoScreen rebuilding... Counter: $_counter');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Tools Demo'),
        centerTitle: true,
        backgroundColor: _currentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Demo Instructions',
            onPressed: () {
              _logToConsole('ℹ️ Info button pressed');
              _showInstructions();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HOT RELOAD DEMO SECTION
            _buildSectionHeader(
              '🔥 Hot Reload Demo',
              'Change colors, text, or widgets and press Hot Reload (r)',
            ),
            const SizedBox(height: 12),
            
            // Animated Container (changes with Hot Reload)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _currentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _currentColor, width: 2),
              ),
              child: Column(
                children: [
                  Icon(_currentColor == Colors.blue ? Icons.favorite : Icons.star,
                      size: 48, color: _currentColor),
                  const SizedBox(height: 12),
                  Text(
                    _currentText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _currentColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _changeColor,
                        icon: const Icon(Icons.palette, size: 18),
                        label: const Text('Change Color'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _changeText,
                        icon: const Icon(Icons.text_fields, size: 18),
                        label: const Text('Change Text'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _simulateHotReload,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text('Simulate Reload (#$_hotReloadCounter)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // DEBUG CONSOLE DEMO SECTION
            _buildSectionHeader(
              '🖥️ Debug Console Demo',
              'Every action logs to the console. Check your terminal!',
            ),
            const SizedBox(height: 12),
            
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Counter Display
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Counter Value',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_counter',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Counter Controls
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _decrementCounter,
                          icon: const Icon(Icons.remove),
                          label: const Text('Decrement'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _incrementCounter,
                          icon: const Icon(Icons.add),
                          label: const Text('Increment'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _resetCounter,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // FLUTTER DEVTOOLS DEMO SECTION
            _buildSectionHeader(
              '🛠️ Flutter DevTools Demo',
              'Open DevTools to inspect widgets and monitor performance',
            ),
            const SizedBox(height: 12),
            
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DevTools Features to Try:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildDevToolsFeature(
                      Icons.widgets,
                      'Widget Inspector',
                      'Examine the widget tree structure',
                      Colors.blue,
                    ),
                    _buildDevToolsFeature(
                      Icons.speed,
                      'Performance',
                      'Monitor frame rendering and FPS',
                      Colors.orange,
                    ),
                    _buildDevToolsFeature(
                      Icons.memory,
                      'Memory',
                      'Track memory usage and detect leaks',
                      Colors.purple,
                    ),
                    _buildDevToolsFeature(
                      Icons.timeline,
                      'Timeline',
                      'View app event timeline',
                      Colors.green,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ElevatedButton.icon(
                      onPressed: _triggerPerformanceTest,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run Performance Test'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // CONSOLE LOGS DISPLAY
            _buildSectionHeader(
              '📋 Recent Console Logs',
              'Last 10 debug messages',
            ),
            const SizedBox(height: 12),
            
            Card(
              elevation: 2,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Debug Console Output',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: _clearLogs,
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: _logs.isEmpty
                          ? Center(
                              child: Text(
                                'No logs yet. Start interacting!',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: _logs.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    _logs[index],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // INSTRUCTIONS CARD
            Card(
              color: Colors.amber.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          'Quick Tips',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip('Press "r" in terminal for Hot Reload'),
                    _buildTip('Press "R" for Hot Restart'),
                    _buildTip('Check terminal for debug logs'),
                    _buildTip('Open DevTools while app is running'),
                    _buildTip('Modify widget properties to test Hot Reload'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDevToolsFeature(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
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
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: Colors.amber.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 8),
            Text('How to Use This Demo'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1️⃣ HOT RELOAD:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '• Modify any widget property in the code\n'
                '• Press "r" in terminal or click Hot Reload\n'
                '• See changes instantly without losing state',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text(
                '2️⃣ DEBUG CONSOLE:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '• Watch terminal for debug logs\n'
                '• Every button press logs to console\n'
                '• Use debugPrint() in your code',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text(
                '3️⃣ FLUTTER DEVTOOLS:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '• Run: flutter pub global activate devtools\n'
                '• Then: flutter pub global run devtools\n'
                '• Or click "Open DevTools" in VS Code\n'
                '• Inspect widgets, performance, memory',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logToConsole('ℹ️ Instructions dialog closed');
            },
            child: const Text('Got It!'),
          ),
        ],
      ),
    );
  }
}