import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/values/app_spacing.dart';
import '../controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsView extends GetView<TermsAndConditionsController> {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
              'Terms & Conditions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.h12,
            Text(
              'These Terms & Conditions govern your use of the ItsTyne Consult application. By accessing or using our services, you agree to be bound by these terms.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),

            AppSpacing.h24,

            _sectionTitle(context, 'Use of the App'),
            _paragraph(
              context,
              'You agree to use the application only for lawful purposes and in a way that does not infringe the rights of others or restrict their use and enjoyment of the app.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Consultation Services'),
            _paragraph(
              context,
              'Consultation sessions provided through ItsTyne Consult are for informational purposes only and do not constitute professional, legal, or financial advice.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Account Responsibilities'),
            _paragraph(
              context,
              'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Termination'),
            _paragraph(
              context,
              'We reserve the right to suspend or terminate your access to the app at any time if you violate these terms or misuse the service.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Limitation of Liability'),
            _paragraph(
              context,
              'ItsTyne Consult shall not be liable for any indirect, incidental, or consequential damages arising from your use of the application.',
            ),

            AppSpacing.h16,

            _sectionTitle(context, 'Changes to These Terms'),
            _paragraph(
              context,
              'We may update these Terms & Conditions from time to time. Continued use of the app after changes means you accept the updated terms.',
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
