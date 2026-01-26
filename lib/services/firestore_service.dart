import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add blood request (used by hospitals)
  Future<void> addBloodRequest({
    required String bloodGroup,
    required String hospitalName,
    required double lat,
    required double lng,
  }) async {
    await _db.collection('blood_requests').add({
      'blood_group': bloodGroup,
      'hospital_name': hospitalName,
      'location': {'lat': lat, 'lng': lng},
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Stream of blood requests for a specific blood group
  Stream<QuerySnapshot> bloodRequestsFor(String bloodGroup) {
    return _db
        .collection('blood_requests')
        .where('blood_group', isEqualTo: bloodGroup)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Fetch user data
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  // Update user location (optional)
  Future<void> updateUserLocation(String uid, double lat, double lng) async {
    await _db.collection('users').doc(uid).update({
      'location': {'lat': lat, 'lng': lng},
    });
  }
}
