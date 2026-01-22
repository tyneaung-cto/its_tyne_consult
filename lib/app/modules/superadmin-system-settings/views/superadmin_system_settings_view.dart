import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/superadmin_system_settings_controller.dart';

class SuperadminSystemSettingsView
    extends GetView<SuperadminSystemSettingsController> {
  const SuperadminSystemSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== GENERAL SETTINGS =====
            Text(
              'General',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Maintenance Mode'),
                    subtitle: const Text(
                      'Temporarily disable user access to the app',
                    ),
                    value: controller.isMaintenanceMode.value,
                    onChanged: controller.toggleMaintenanceMode,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Allow New Registrations'),
                    subtitle: const Text(
                      'Enable or disable new user sign-ups',
                    ),
                    value: controller.allowRegistrations.value,
                    onChanged: controller.toggleRegistrations,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== CONSULTATION SETTINGS =====
            Text(
              'Consultations',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Default Consultation Duration'),
                    subtitle: Obx(
                      () => Text(
                        '${controller.defaultDuration.value} minutes',
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: controller.changeDefaultDuration,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Max Requests per User / Day'),
                    subtitle: Obx(
                      () => Text(
                        controller.maxRequestsPerDay.value.toString(),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: controller.changeMaxRequests,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== SECURITY SETTINGS =====
            Text(
              'Security',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Require Email Verification'),
                    subtitle: const Text(
                      'Users must verify email before booking',
                    ),
                    value:
                        controller.requireEmailVerification.value,
                    onChanged:
                        controller.toggleEmailVerification,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Enable Login Rate Limiting'),
                    subtitle: const Text(
                      'Protect against brute-force attacks',
                    ),
                    value: controller.enableRateLimit.value,
                    onChanged: controller.toggleRateLimit,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== SYSTEM INFO =====
            Text(
              'System Info',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Card(
              child: Column(
                children: const [
                  ListTile(
                    title: Text('Environment'),
                    subtitle: Text('Production'),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('App Version'),
                    subtitle: Text('v1.0.0'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
