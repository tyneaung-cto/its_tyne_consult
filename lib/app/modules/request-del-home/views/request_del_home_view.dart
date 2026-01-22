import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/request_del_home_controller.dart';

class RequestDelHomeView extends GetView<RequestDelHomeController> {
  const RequestDelHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Deletion Requested'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Icon / Illustration
              Icon(
                Icons.hourglass_top_rounded,
                size: 90,
                color: theme.colorScheme.error,
              ),

              const SizedBox(height: 24),

              Text(
                'Deletion Request in Progress',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Your account has been scheduled for deletion. During this period your account may be limited while we process your request.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 20),

              // Warning card
              Card(
                color: theme.colorScheme.errorContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Important Notice',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '• This action cannot be undone\n'
                        '• All your data will be permanently deleted\n'
                        '• Deletion will be completed within 7 working days\n'
                        '• Contact support if this was requested by mistake',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Current user info
              Obx(() {
                if (controller.email.value == null &&
                    controller.username.value == null)
                  return const SizedBox();

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    title: Text(controller.username.value),
                    subtitle: Text(controller.email.value),
                  ),
                );
              }),

              const Spacer(),

              // Sign out button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.signOut,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
