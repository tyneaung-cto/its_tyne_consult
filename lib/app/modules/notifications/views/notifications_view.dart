import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_spacing.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Consultation Confirmed',
        'message':
            'Your consultation session has been confirmed. Please check the schedule.',
        'time': 'Just now',
        'icon': Icons.check_circle,
      },
      {
        'title': 'Upcoming Session Reminder',
        'message': 'You have a consultation session tomorrow at 10:00 AM.',
        'time': '2 hours ago',
        'icon': Icons.schedule,
      },
      {
        'title': 'New Message',
        'message': 'You received a message from ItsTyne Consult support.',
        'time': 'Yesterday',
        'icon': Icons.message,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => AppSpacing.h12,
        itemBuilder: (context, index) {
          final item = notifications[index];

          return Card(
            child: ListTile(
              // leading: Icon(
              //   item['icon'] as IconData,
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  item['icon'] as IconData,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.h4,
                  Text(
                    item['message'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.h8,
                  Text(
                    item['time'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
