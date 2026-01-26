import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailC = TextEditingController();
  final AuthService auth = AuthService();
  bool sending = false;

  void resetPassword() async {
    setState(() => sending = true);
    try {
      await auth.resetPassword(emailC.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email sent!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailC, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 20),
            sending ? CircularProgressIndicator() : ElevatedButton(onPressed: resetPassword, child: Text('Send Reset Email')),
          ],
        ),
      ),
    );
  }
}
