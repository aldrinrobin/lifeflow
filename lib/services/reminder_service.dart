import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';

class ReminderService {
  // Singleton pattern
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification clicked: ${response.payload}');
        // You can navigate to a screen if needed
      },
    );
  }

  /// Add a new medicine reminder for the current user
  Future<void> addReminder({
    required String medicineName,
    required String dosage,
    required String timing, // e.g., Morning / Afternoon / Evening
    required DateTime dateTime, // scheduled date & time
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Save to Firestore
    final reminderRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('medicine_reminders')
        .add({
      'medicine_name': medicineName,
      'dosage': dosage,
      'timing': timing,
      'scheduled_time': dateTime,
      'created_at': FieldValue.serverTimestamp(),
    });

    // Schedule local notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminderRef.hashCode & 0x7FFFFFFF, // unique ID
      'Medicine Reminder',
      '$medicineName - $dosage ($timing)',
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Medicine reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Fetch all reminders for the current user
  Stream<QuerySnapshot> getUserReminders() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('medicine_reminders')
        .orderBy('scheduled_time', descending: false)
        .snapshots();
  }

  /// Cancel a specific reminder by document ID
  Future<void> cancelReminder(String docId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('medicine_reminders')
        .doc(docId)
        .delete();

    // Cancel local notification
    await flutterLocalNotificationsPlugin.cancel(docId.hashCode & 0x7FFFFFFF);
  }

  /// Cancel all reminders for the current user
  Future<void> cancelAllReminders() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshots = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('medicine_reminders')
        .get();

    for (var doc in snapshots.docs) {
      await cancelReminder(doc.id);
    }
  }
}
