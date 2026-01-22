import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SuperadminSystemSettingsController extends GetxController {
  // ===== GENERAL =====
  final isMaintenanceMode = false.obs;
  final allowRegistrations = true.obs;

  // ===== CONSULTATION =====
  final defaultDuration = 30.obs; // minutes
  final maxRequestsPerDay = 3.obs;

  // ===== SECURITY =====
  final requireEmailVerification = false.obs;
  final enableRateLimit = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialSettings();
  }

  // =========================
  // INITIAL LOAD (Mock / Local)
  // =========================
  void _loadInitialSettings() {
    debugPrint('🟡 SystemSettings: loading initial values');

    // TODO: Replace with Firestore load later
    isMaintenanceMode.value = false;
    allowRegistrations.value = true;
    defaultDuration.value = 30;
    maxRequestsPerDay.value = 3;
    requireEmailVerification.value = false;
    enableRateLimit.value = true;
  }

  // =========================
  // TOGGLES
  // =========================
  void toggleMaintenanceMode(bool value) {
    isMaintenanceMode.value = value;
    debugPrint('⚙️ Maintenance Mode: $value');

    // TODO: Save to Firestore
  }

  void toggleRegistrations(bool value) {
    allowRegistrations.value = value;
    debugPrint('⚙️ Allow Registrations: $value');

    // TODO: Save to Firestore
  }

  void toggleEmailVerification(bool value) {
    requireEmailVerification.value = value;
    debugPrint('⚙️ Require Email Verification: $value');

    // TODO: Save to Firestore
  }

  void toggleRateLimit(bool value) {
    enableRateLimit.value = value;
    debugPrint('⚙️ Rate Limiting: $value');

    // TODO: Save to Firestore
  }

  // =========================
  // CONSULTATION SETTINGS
  // =========================
  void changeDefaultDuration() {
    Get.defaultDialog(
      title: 'Default Consultation Duration',
      content: Column(
        children: [30, 40, 60]
            .map(
              (min) => RadioListTile<int>(
                title: Text('$min minutes'),
                value: min,
                groupValue: defaultDuration.value,
                onChanged: (value) {
                  if (value != null) {
                    defaultDuration.value = value;
                    Get.back();
                    debugPrint('⚙️ Default consultation duration: $value');
                  }
                },
              ),
            )
            .toList(),
      ),
    );

    // TODO: Save to Firestore
  }

  void changeMaxRequests() {
    Get.defaultDialog(
      title: 'Max Requests per User / Day',
      content: Column(
        children: [1, 2, 3, 5]
            .map(
              (count) => RadioListTile<int>(
                title: Text('$count requests'),
                value: count,
                groupValue: maxRequestsPerDay.value,
                onChanged: (value) {
                  if (value != null) {
                    maxRequestsPerDay.value = value;
                    Get.back();
                    debugPrint('⚙️ Max requests per day: $value');
                  }
                },
              ),
            )
            .toList(),
      ),
    );

    // TODO: Save to Firestore
  }
}
