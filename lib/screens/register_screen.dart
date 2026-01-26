import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final bloodGroupController = TextEditingController();

  bool loading = false;

  void registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      // 1️⃣ Create user in Firebase Auth
      UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = cred.user;

      // 2️⃣ Send email verification
      await user!.sendEmailVerification();

      // 3️⃣ Write user info to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'age': ageController.text.trim(),
        'blood_group': bloodGroupController.text.trim(),
        'medical_history': '',
      });

      setState(() => loading = false);

      // 4️⃣ Go to email verification screen
      Navigator.pushReplacementNamed(context, '/email_verification');
    } on FirebaseAuthException catch (e) {
      setState(() => loading = false);
      String message = e.message ?? 'An error occurred';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (v) => v!.isEmpty ? 'Enter your email' : null,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (v) => v!.length < 6 ? 'Password too short' : null,
                    ),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                      validator: (v) => v!.isEmpty ? 'Enter your age' : null,
                    ),
                    TextFormField(
                      controller: bloodGroupController,
                      decoration: InputDecoration(labelText: 'Blood Group'),
                      validator: (v) => v!.isEmpty ? 'Enter your blood group' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: registerUser,
                      child: Text('Register'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: Text('Already have an account? Login'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
