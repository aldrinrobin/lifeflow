import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dashboard_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key}); // const constructor
  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}


class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  Timer? timer;
  bool isVerified = false;
  bool sending = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future<void> checkEmailVerified() async {
    await user?.reload();
    setState(() => isVerified = user?.emailVerified ?? false);

    if (isVerified) {
      timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    }
  }

  Future<void> resendVerificationEmail() async {
    setState(() => sending = true);
    try {
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification email sent!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => sending = false);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email Verification')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A verification email has been sent to ${user?.email}.', textAlign: TextAlign.center),
            SizedBox(height: 20),
            sending ? CircularProgressIndicator() : ElevatedButton(onPressed: resendVerificationEmail, child: Text('Resend Email')),
            SizedBox(height: 20),
            Text('Waiting for verification...')
          ],
        ),
      ),
    );
  }
}
