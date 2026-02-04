import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_main_screen.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';
import 'theme/app_themes.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with your platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Run the app wrapped with ThemeProvider
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider()..loadTheme(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'MANAGIO',
          debugShowCheckedModeBanner: false,
          // Apply custom light theme
          theme: AppThemes.lightTheme,
          // Apply custom dark theme
          darkTheme: AppThemes.darkTheme,
          // Use theme mode from provider
          themeMode: themeProvider.themeMode,
          // Use StreamBuilder to listen to authentication state changes
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // Show loading screen while checking authentication state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              // If user is authenticated, go to main dashboard
              if (snapshot.hasData) {
                return const DashboardMainScreen();
              }

              // If no user is authenticated, go to login screen
              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}