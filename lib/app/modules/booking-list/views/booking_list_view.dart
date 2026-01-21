import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/booking_list_controller.dart';

class BookingListView extends GetView<BookingListController> {
  const BookingListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookingListView'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.consultations.isEmpty) {
          return const Center(
            child: Text('No bookings found'),
          );
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
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer,
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
                    _StatusChip(status: consultation.status),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
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

  void _showBookingDetailDialog(
    BuildContext context,
    consultation,
  ) {
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
            Text(consultation.notes.isEmpty
                ? 'No notes provided'
                : consultation.notes),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
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
    Color color;
    switch (status) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'pending':
      default:
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
