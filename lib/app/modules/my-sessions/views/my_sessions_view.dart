import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/values/app_spacing.dart';
import '../controllers/my_sessions_controller.dart';

class MySessionsView extends GetView<MySessionsController> {
  const MySessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Sessions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: controller.mySessionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load sessions: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data!;

          if (sessions.isEmpty) {
            return const Center(child: Text('No sessions yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => AppSpacing.h12,
            itemBuilder: (context, index) {
              final s = sessions[index];

              final start = s.scheduledAt;
              final end = start.add(Duration(minutes: s.duration));

              final dateText = '${start.month}/${start.day}/${start.year}';
              final timeText = '${_formatTime(start)} - ${_formatTime(end)}';

              final status =
                  '${s.status[0].toUpperCase()}${s.status.substring(1)}';

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      _statusIcon(s.status),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('consultations')
                        .doc(s.consultationId)
                        .get(),
                    builder: (context, snap) {
                      String title = 'Session';

                      if (snap.hasData && snap.data!.exists) {
                        final data = snap.data!.data() as Map<String, dynamic>;
                        title =
                            data['topic'] ??
                            data['title'] ??
                            data['subject'] ??
                            'Consultation';
                      }

                      return Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.h4,
                      Text(
                        '$dateText • $timeText',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      AppSpacing.h8,
                      Text(
                        'Status: $status',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _statusColor(context, status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  // trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    // fetch consultation details
                    final doc = await FirebaseFirestore.instance
                        .collection('consultations')
                        .doc(s.consultationId)
                        .get();

                    final consultation = doc.exists
                        ? (doc.data() as Map<String, dynamic>)
                        : {};

                    Get.bottomSheet(
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                consultation['topic'] ??
                                    consultation['title'] ??
                                    consultation['subject'] ??
                                    'Consultation Details',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              AppSpacing.h16,
                              Text('Date: $dateText'),
                              Text('Time: $timeText'),
                              Text('Duration: ${s.duration} mins'),
                              Text('Status: $status'),
                              AppSpacing.h12,
                              // 🔗 Meeting link section
                              if ((s.meetingLink ?? '').isNotEmpty)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        s.meetingLink,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy),
                                      tooltip: 'Copy link',
                                      onPressed: () async {
                                        await Clipboard.setData(
                                          ClipboardData(text: s.meetingLink),
                                        );
                                        Get.snackbar(
                                          'Copied',
                                          'Meeting link copied to clipboard',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      },
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  'Meeting link is not available yet. Please check later. Admin team will add the meeting link soon, thanks.',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              AppSpacing.h16,
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Close'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      isScrollControlled: true,
                    );
                  },
                ),
              );
            },
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

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      case 'confirmed':
        return Icons.check_circle;
      default:
        return Icons.access_time;
    }
  }
}
