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
          'request_consultation'.tr,
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
              'consultation_details'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.h8,
            Text(
              'consultation_details_desc'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            AppSpacing.h24,

            TextFormField(
              controller: controller.topicController,
              decoration: InputDecoration(
                labelText: 'consultation_topic'.tr,
                hintText: 'e.g. App Development, Business Strategy',
              ),
            ),

            AppSpacing.h16,

            TextFormField(
              controller: controller.preferredDateController,
              decoration: InputDecoration(
                labelText: 'preferred_date'.tr,
                hintText: 'Select a date',
              ),
              readOnly: true,
              onTap: controller.pickDate,
            ),

            AppSpacing.h16,

            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedTimeSlot.value,
                decoration: InputDecoration(
                  labelText: 'preferred_time_slot'.tr,
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
                decoration: InputDecoration(labelText: 'session_duration'.tr),
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
              decoration: InputDecoration(
                labelText: 'additional_notes_optional'.tr,
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
                      : Text('submit_request'.tr),
                ),
              ),
            ),

            AppSpacing.h16,

            Center(
              child: Text(
                'request_confirmation_note'.tr,
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
