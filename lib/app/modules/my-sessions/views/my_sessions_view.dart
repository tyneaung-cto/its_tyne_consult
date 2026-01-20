import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_spacing.dart';
import '../controllers/my_sessions_controller.dart';

class MySessionsView extends GetView<MySessionsController> {
  const MySessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      {
        'title': 'Free Consultation',
        'date': 'Jan 25, 2026',
        'time': '10:00 AM - 10:30 AM',
        'status': 'Confirmed',
        'icon': Icons.check_circle,
      },
      {
        'title': 'Follow-up Session',
        'date': 'Jan 18, 2026',
        'time': '02:00 PM - 02:40 PM',
        'status': 'Completed',
        'icon': Icons.done_all,
      },
      {
        'title': 'Strategy Discussion',
        'date': 'Jan 10, 2026',
        'time': '09:00 AM - 09:30 AM',
        'status': 'Cancelled',
        'icon': Icons.cancel,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Sessions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        separatorBuilder: (_, __) => AppSpacing.h12,
        itemBuilder: (context, index) {
          final session = sessions[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  session['icon'] as IconData,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                session['title'] as String,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.h4,
                  Text(
                    '${session['date']} • ${session['time']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.h8,
                  Text(
                    'Status: ${session['status']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _statusColor(context, session['status'] as String),
                      fontWeight: FontWeight.w600,
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

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'Confirmed':
        return Theme.of(context).colorScheme.primary;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}
