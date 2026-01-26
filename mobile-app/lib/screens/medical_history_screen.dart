import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  List consultations = [];

  @override
  void initState() {
    super.initState();
    fetchConsultations();
  }

  void fetchConsultations() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('consultations')
            .orderBy('date', descending: true)
            .get();

        setState(() {
          consultations = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      } catch (e) {
        print("Error fetching consultations: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (consultations.isEmpty) {
      return const Center(
        child: Text("No medical history yet."),
      );
    }

    return ListView.builder(
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        var consultation = consultations[index] as Map<String, dynamic>;

        // Safely get date
        final rawDate = consultation['date'];

DateTime date;

if (rawDate is Timestamp) {
  date = rawDate.toDate().toLocal();   // 👈 convert to local
} else if (rawDate is String) {
  date = DateTime.parse(rawDate).toLocal(); // 👈 convert to local
} else {
  date = DateTime.now();
}

String formattedDate =
    DateFormat('dd MMM yyyy, hh:mm a').format(date);



        // Safely get lists
        List medicines = consultation['medicines'] ?? [];
        List procedures = consultation['procedures'] ?? [];
        List tests = consultation['tests'] ?? [];

        return Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: $formattedDate', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Doctor: ${consultation['doctorName'] ?? 'Unknown'}'),
                Text('Hospital: ${consultation['hospitalName'] ?? 'Unknown'}'),
                Text('BP: ${consultation['bp'] ?? 'N/A'}'),
                Text('Sugar Level: ${consultation['sugarLevel'] ?? 'N/A'}'),
                if (medicines.isNotEmpty) Text('Medicines: ${medicines.join(', ')}'),
                if (procedures.isNotEmpty) Text('Procedures: ${procedures.join(', ')}'),
                if (tests.isNotEmpty) Text('Tests: ${tests.join(', ')}'),
                if (consultation['notes'] != null && consultation['notes'].toString().isNotEmpty)
                  Text('Notes: ${consultation['notes']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
