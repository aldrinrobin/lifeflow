import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class BloodAlertsScreen extends StatefulWidget {
  const BloodAlertsScreen({super.key});

  @override
  State<BloodAlertsScreen> createState() => _BloodAlertsScreenState();
}

class _BloodAlertsScreenState extends State<BloodAlertsScreen> {
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
    if (userData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Blood Alerts')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.bloodRequestsFor(userData!['blood_group']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: Text('No alerts yet.'));
          final requests = snapshot.data!.docs;
          if (requests.isEmpty) return Center(child: Text('No alerts yet.'));

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final r = requests[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  leading: Icon(Icons.bloodtype, color: Colors.red),
                  title: Text('Blood needed at ${r['hospital_name']}'),
                  subtitle: Text('Blood Group: ${r['blood_group']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
