import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final FirestoreService firestore = FirestoreService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final doc = await firestore.getUserData(user!.uid);
    if (doc.exists) setState(() => userData = doc.data() as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name: ${userData!['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Email: ${userData!['email']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Age: ${userData!['age']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Blood Group: ${userData!['blood_group']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Medical History:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${userData!['medical_history'] ?? "No records yet"}'),
          ],
        ),
      ),
    );
  }
}
