import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../../core/values/app_spacing.dart';
import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Consultation',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consultation Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.h8,
            Text(
              'Please provide the details below to request your consultation session.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            AppSpacing.h24,

            TextFormField(
              controller: controller.topicController,
              decoration: const InputDecoration(
                labelText: 'Consultation Topic',
                hintText: 'e.g. App Development, Business Strategy',
              ),
            ),

            AppSpacing.h16,

            TextFormField(
              controller: controller.preferredDateController,
              decoration: const InputDecoration(
                labelText: 'Preferred Date',
                hintText: 'Select a date',
              ),
              readOnly: true,
              onTap: controller.pickDate,
            ),

            AppSpacing.h16,

            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedTimeSlot.value,
                decoration: const InputDecoration(
                  labelText: 'Preferred Time Slot',
                ),
                items: controller.timeSlots
                    .map(
                      (slot) =>
                          DropdownMenuItem(value: slot, child: Text(slot)),
                    )
                    .toList(),
                onChanged: controller.onTimeSlotChanged,
              ),
            ),

            AppSpacing.h16,

            Obx(
              () => DropdownButtonFormField<int>(
                value: controller.selectedDuration.value,
                decoration: const InputDecoration(
                  labelText: 'Session Duration',
                ),
                items: controller.durations
                    .map(
                      (duration) => DropdownMenuItem(
                        value: duration,
                        child: Text('$duration minutes'),
                      ),
                    )
                    .toList(),
                onChanged: controller.onDurationChanged,
              ),
            ),

            AppSpacing.h16,

            TextFormField(
              controller: controller.notesController,
              decoration: const InputDecoration(
                labelText: 'Additional Notes (Optional)',
                hintText: 'Any specific questions or context',
              ),
              maxLines: 4,
            ),

            AppSpacing.h32,

            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitBookingRequest,
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Request'),
                ),
              ),
            ),

            AppSpacing.h16,

            Center(
              child: Text(
                'You will receive a confirmation once your request is reviewed.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
