import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register
  Future<User?> registerWithEmail(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await result.user?.sendEmailVerification();
    return result.user;
  }

  // Login
  Future<User?> loginWithEmail(String email, String password) async {
    final result =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  // Forgot Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
