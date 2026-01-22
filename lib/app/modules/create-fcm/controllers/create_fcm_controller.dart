import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/firestore_service.dart';

class CreateFcmController extends GetxController {
  // ===== STATE =====
  final RxString targetAudience = 'all'.obs;
  final RxBool isSending = false.obs;

  // ===== FORM CONTROLLERS =====
  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // ===== SERVICES =====
  final FirestoreService _firestore = FirestoreService.instance;

  // ===== LIFECYCLE =====
  @override
  void onClose() {
    titleController.dispose();
    messageController.dispose();
    super.onClose();
  }

  // ===== ACTIONS =====
  void setTargetAudience(String value) {
    targetAudience.value = value;
  }

  Future<void> sendNotification() async {
    final title = titleController.text.trim();
    final message = messageController.text.trim();

    if (title.isEmpty || message.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Title and message are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSending.value = true;

      debugPrint('🟡 Create FCM start');
      debugPrint('Target: ${targetAudience.value}');
      debugPrint('Title: $title');

      // 1️⃣ Save notification records in Firestore (for in-app list)
      // 2️⃣ Then trigger FCM push (Cloud Function or topic send)
      // Save notification record (SuperAdmin broadcast)
      await _firestore.createGlobalNotificationByTarget(
        target: targetAudience.value,
        title: title,
        message: message,
        isRead: false,
        createdAt: DateTime.now(),
      );

      // 🔔 Send real FCM push (topic-based)
      // Each user device should subscribe to a topic based on role:
      // all, clients, consultants, admins, superadmins
      await _firestore.sendFcmPushToTopic(
        topic: targetAudience.value,
        title: title,
        message: message,
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Notification sent successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      titleController.clear();
      messageController.clear();
      targetAudience.value = 'all';
    } catch (e, s) {
      debugPrint('❌ Send FCM error: $e');
      debugPrint('STACKTRACE: $s');

      Get.snackbar(
        'Error',
        'Failed to send notification',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }
}
