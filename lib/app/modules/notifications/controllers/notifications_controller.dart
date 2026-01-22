import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:its_tyne_consult/app/data/models/app_notification_model.dart';

import '../../../core/services/firestore_service.dart';

class NotificationsController extends GetxController {
  final notifications = <AppNotification>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _listenNotifications();
  }

  void _listenNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('⚠️ Notifications: no authenticated user');
      isLoading.value = false;
      return;
    }

    debugPrint('🟡 Notifications: listening for userId=${user.uid}');
    isLoading.value = true;

    FirestoreService.instance
        .getUserNotifications(user.uid)
        .listen(
          (data) {
            notifications.assignAll(data);
            isLoading.value = false;

            debugPrint('🔔 Notifications loaded: ${data.length}');
          },
          onError: (error) {
            isLoading.value = false;
            debugPrint('❌ Notifications stream error: $error');
            debugPrint(
              'ℹ️ This usually means a missing Firestore composite index.',
            );
          },
        );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      debugPrint('🟡 Marking notification as read: $notificationId');

      // Update Firestore
      await FirestoreService.instance.markNotificationAsRead(notificationId);

      // Optimistically update local state
      final index =
          notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final old = notifications[index];
        notifications[index] = AppNotification(
          id: old.id,
          userId: old.userId,
          title: old.title,
          message: old.message,
          isRead: true,
          createdAt: old.createdAt,
        );
      }

      debugPrint('✅ Notification marked as read');
    } catch (e, s) {
      debugPrint('❌ Failed to mark notification as read: $e');
      debugPrint('STACKTRACE: $s');
    }
  }

}
