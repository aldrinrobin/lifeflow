import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineRemindersScreen extends StatelessWidget {
  const MedicineRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Medicine Reminders')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('medicine_reminders')
            .orderBy('start_date')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reminders = snapshot.data!.docs;
          if (reminders.isEmpty) {
            return const Center(child: Text('No reminders yet.'));
          }

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final data = reminders[index].data() as Map<String, dynamic>;
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(data['medicine_name'] ?? '-'),
                  subtitle: Text(
                      'Dose: ${data['dose'] ?? '-'}\nTiming: ${List<String>.from(data['timing'] ?? []).join(', ')}\nStart: ${data['start_date']?.toDate()}\nEnd: ${data['end_date']?.toDate()}\nNotes: ${data['notes'] ?? '-'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
