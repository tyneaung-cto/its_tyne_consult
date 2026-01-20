import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/my_button.dart';
import '../../../shared/widgets/my_text_field.dart';
import '../../../core/values/app_spacing.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Reset Password',
        //   style: Theme.of(context).textTheme.titleMedium,
        // ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.h16,

            Text(
              'Forgot your password?',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              'Enter your email address and we will send you instructions to reset your password.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.h32,

            MyTextField(controller: controller.emailController, label: 'Email'),

            AppSpacing.h24,

            MyButton(
              text: 'Send Reset Email',
              onPressed: controller.sendPasswordResetEmail,
            ),

            AppSpacing.h24,

            TextButton(
              onPressed: controller.goBackToLogin,
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
