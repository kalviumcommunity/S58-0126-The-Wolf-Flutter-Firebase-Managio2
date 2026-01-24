import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_form_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  Future<void> handleAuth() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        // LOGIN
        await _authService.signIn(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        // SIGN UP
        await _authService.signUp(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      }

      // ✅ NAVIGATE TO PROFILE FORM AFTER SUCCESS
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ProfileFormScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MANAGIO Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// EMAIL
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),

            /// PASSWORD
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            const SizedBox(height: 24),

            /// LOGIN / SIGNUP BUTTON
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleAuth,
                    child: Text(isLogin ? 'Login' : 'Sign Up'),
                  ),

            /// TOGGLE LOGIN / SIGNUP
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? "Don't have an account? Sign up"
                    : "Already have an account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
