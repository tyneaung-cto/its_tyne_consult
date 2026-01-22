import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:its_tyne_consult/app/data/models/app_notification_model.dart';

import '../../../core/services/firestore_service.dart';

class SuperadminListNotificationsController extends GetxController {
  final isLoading = true.obs;
  final notifications = <AppNotification>[].obs;

  StreamSubscription<List<AppNotification>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _listenNotifications();
  }

  void _listenNotifications() {
    debugPrint('🟡 SuperAdmin Notifications: start listening');

    isLoading.value = true;

    _subscription = FirestoreService.instance
        // only load latest 100 notifications to avoid huge memory / UI lag
        .streamAllNotifications(limit: 100)
        .listen(
      (data) {
        notifications.assignAll(data);
        isLoading.value = false;
        debugPrint(
          '✅ Notifications loaded (max 100): ${data.length}',
        );
      },
      onError: (error) {
        isLoading.value = false;
        debugPrint('❌ Notifications stream error: $error');
        Get.snackbar(
          'Error',
          'Unable to load notifications',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Show full notification details
  void showNotificationDetails(AppNotification notification) {
    Get.defaultDialog(
      title: notification.title,
      content: SingleChildScrollView(
        child: Text(notification.message),
      ),
      textConfirm: 'Close',
      onConfirm: Get.back,
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
