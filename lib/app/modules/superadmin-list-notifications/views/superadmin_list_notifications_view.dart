import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/superadmin_list_notifications_controller.dart';
import '../../../routes/app_pages.dart';

class SuperadminListNotificationsView
    extends GetView<SuperadminListNotificationsController> {
  const SuperadminListNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sent Notifications'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh',
        child: const Icon(Icons.send),
        onPressed: () {
          Get.toNamed(Routes.CREATE_FCM);
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications sent yet'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final noti = controller.notifications[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active),
                title: Text(noti.title, style: theme.textTheme.titleMedium),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // message
                    Text(
                      noti.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 8),

                    // extra admin info
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Text(
                          'To: ${noti.userId}',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          'Read: ${noti.isRead ? "Yes" : "No"}',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          'Sent: ${controller.formatDate(noti.createdAt)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          'By: ${noti.createdBy ?? "System"}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(
                  noti.isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                  size: 18,
                ),
                onTap: () {
                  controller.showNotificationDetails(noti);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
