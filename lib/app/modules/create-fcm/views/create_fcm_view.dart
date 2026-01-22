import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_fcm_controller.dart';

class CreateFcmView extends GetView<CreateFcmController> {
  const CreateFcmView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Notification'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TARGET AUDIENCE =====
            Text(
              'Send To',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Obx(
              () => Wrap(
                spacing: 8,
                children: [
                  _AudienceChip(
                    label: 'All Users',
                    value: 'all',
                    selected:
                        controller.targetAudience.value == 'all',
                    onSelected: controller.setTargetAudience,
                  ),
                  _AudienceChip(
                    label: 'Clients',
                    value: 'client',
                    selected:
                        controller.targetAudience.value == 'client',
                    onSelected: controller.setTargetAudience,
                  ),
                  _AudienceChip(
                    label: 'Consultants',
                    value: 'consultant',
                    selected:
                        controller.targetAudience.value ==
                            'consultant',
                    onSelected: controller.setTargetAudience,
                  ),
                  _AudienceChip(
                    label: 'Admins',
                    value: 'admin',
                    selected:
                        controller.targetAudience.value == 'admin',
                    onSelected: controller.setTargetAudience,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ===== TITLE =====
            Text(
              'Title',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                hintText: 'Notification title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // ===== MESSAGE =====
            Text(
              'Message',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Write your message here',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 32),

            // ===== SEND BUTTON =====
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: controller.isSending.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    controller.isSending.value
                        ? 'Sending...'
                        : 'Send Notification',
                  ),
                  onPressed: controller.isSending.value
                      ? null
                      : controller.sendNotification,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudienceChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final Function(String) onSelected;

  const _AudienceChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(value),
    );
  }
}
