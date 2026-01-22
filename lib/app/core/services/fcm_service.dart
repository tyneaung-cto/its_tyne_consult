import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> init() async {
    // request permission (iOS + Android 13+)
    await _messaging.requestPermission();

    // get token (for debugging)
    final token = await _messaging.getToken();
    debugPrint('🟢 FCM TOKEN: $token');

    // foreground messages (show snackbar when app is open)
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? 'Notification';
      final body = message.notification?.body ?? '';

      debugPrint('📩 Foreground message: $title');

      // UI feedback while app is in foreground
      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    });

    // background tap
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('📩 Opened from notification');
    });
  }

  // subscribe to topic
  static Future<void> subscribeTopics(String role) async {
    await _messaging.subscribeToTopic('all');
    await _messaging.subscribeToTopic(role); // client/admin/etc

    debugPrint('✅ Subscribed to topics: all + $role');
  }

  static Future<String> getUserRole(String uid) async {
    try {
      debugPrint('🟡 Firestore: getUserRole start -> $uid');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        debugPrint('❌ getUserRole: user doc not found');
        return 'client'; // safe fallback
      }

      final data = doc.data();

      final role = data?['role'] as String? ?? 'client';

      debugPrint('✅ Firestore: role = $role');

      return role;
    } catch (e, s) {
      debugPrint('❌ getUserRole error: $e');
      debugPrint('STACKTRACE: $s');

      // fallback so app never crashes
      return 'client';
    }
  }

  static Future<void> showLocalWelcomeNotification({
    required String title,
    required String body,
  }) async {
    debugPrint('🟡 Local welcome notification: $title | $body');

    try {
      // 1️⃣ Save notification into Firestore DB (so it appears in Notifications list)
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        debugPrint('❌ No current user, skip saving welcome notification');
      } else {
        await FirebaseFirestore.instance.collection('notifications').add({
          'userId': uid, // MUST match NotificationsController filter
          'title': title,
          'message': body,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': 'system',
        });

        debugPrint('✅ Welcome notification saved to Firestore for uid=$uid');
      }

      // 2️⃣ Show instant local snackbar (foreground UX)
      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(12),
      );
    } catch (e, s) {
      debugPrint('❌ showLocalWelcomeNotification error: $e');
      debugPrint('STACKTRACE: $s');
    }
  }
}
