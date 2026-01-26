import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'email_verification_screen.dart';
import 'forgot_password_screen.dart';
import 'dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final AuthService auth = AuthService();
  bool loading = false;

  void login() async {
    setState(() => loading = true);
    try {
      final user = await auth.loginWithEmail(emailC.text.trim(), passC.text.trim());
      if (user != null) {
        if (user.emailVerified) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EmailVerificationScreen()));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailC, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passC, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            loading ? CircularProgressIndicator() : ElevatedButton(onPressed: login, child: Text('Login')),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen())),
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
