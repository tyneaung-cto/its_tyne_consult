import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_spacing.dart';
import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
              'Privacy Policy',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.h12,
            Text(
              'Your privacy is important to us. This Privacy Policy explains how ItsTyne Consult collects, uses, and protects your information when you use our application.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),

            AppSpacing.h24,

            _sectionTitle(context, 'Information We Collect'),
            _paragraph(
              context,
              'We may collect personal information such as your name, email address, and appointment details when you register or request a consultation.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'How We Use Your Information'),
            _paragraph(
              context,
              'Your information is used to provide and improve our services, communicate with you about your consultations, and ensure account security.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Data Security'),
            _paragraph(
              context,
              'We take reasonable measures to protect your data using industry-standard security practices. However, no method of transmission over the internet is completely secure.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Third-Party Services'),
            _paragraph(
              context,
              'We may use trusted third-party services such as Firebase to help operate and improve the application. These services comply with their own privacy policies.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Your Rights'),
            _paragraph(
              context,
              'You may request access to, correction of, or deletion of your personal information by contacting us through the app.',
            ),

            AppSpacing.h32,

            Center(
              child: Text(
                'Last updated: January 2026',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _paragraph(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}
