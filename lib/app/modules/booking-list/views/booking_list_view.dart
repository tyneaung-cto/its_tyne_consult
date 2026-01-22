import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/booking_list_controller.dart';

class BookingListView extends GetView<BookingListController> {
  const BookingListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings'), centerTitle: false),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.consultations.isEmpty) {
          return const Center(child: Text('No bookings found'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.consultations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final consultation = controller.consultations[index];

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  consultation.topic,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${_formatDate(consultation.preferredDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Time: ${consultation.timeSlot}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Duration: ${consultation.duration} minutes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    // Show status chip only when NOT pending (pending handled by action row below)
                    if (consultation.status.toLowerCase() != 'pending')
                      _StatusChip(status: consultation.status),
                    if (consultation.status.toLowerCase() == 'pending') ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Pending badge (same style feel as chip, not pill button)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              'PENDING',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Cancel button – same rectangular style (not pill)
                          OutlinedButton.icon(
                            onPressed: () =>
                                controller.cancelConsultation(consultation.id),
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                // trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showBookingDetailDialog(context, consultation);
                },
              ),
            );
          },
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showBookingDetailDialog(BuildContext context, consultation) {
    Get.dialog(
      AlertDialog(
        title: Text(
          consultation.topic,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${consultation.status}'),
            const SizedBox(height: 8),
            Text('Preferred Date: ${_formatDate(consultation.preferredDate)}'),
            Text('Time Slot: ${consultation.timeSlot}'),
            Text('Duration: ${consultation.duration} minutes'),
            const SizedBox(height: 8),
            Text('Notes:'),
            Text(
              consultation.notes.isEmpty
                  ? 'No notes provided'
                  : consultation.notes,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'approved':
        bgColor = scheme.primary.withOpacity(0.15);
        textColor = scheme.primary;
        break;

      case 'rejected':
      case 'cancelled':
        bgColor = scheme.error.withOpacity(0.15);
        textColor = scheme.error;
        break;

      case 'pending':
      default:
        bgColor = Colors.orange.withOpacity(0.18);
        textColor = Colors.orange.shade800;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      backgroundColor: bgColor,
      side: BorderSide(color: textColor.withOpacity(0.3)),
    );
  }
}
