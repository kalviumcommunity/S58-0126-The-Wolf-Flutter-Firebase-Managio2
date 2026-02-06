import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// SIGN UP
  Future<User?> signUp(String email, String password) async {
    final UserCredential credential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// SIGN IN
  Future<User?> signIn(String email, String password) async {
    final UserCredential credential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
