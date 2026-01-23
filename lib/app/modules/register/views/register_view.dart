import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/my_text_field.dart';
import '../../../core/values/app_spacing.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   'Create Account',
        //   style: Theme.of(context).textTheme.titleMedium,
        // ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Get started with ItsTyne Consult',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              'Create your account to request a consultation.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.h32,

            MyTextField(
              controller: controller.usernameController,
              label: 'Username',
            ),
            AppSpacing.h16,

            MyTextField(controller: controller.emailController, label: 'Email'),
            AppSpacing.h16,

            MyTextField(
              controller: controller.passwordController,
              label: 'Password',
              obscureText: true,
            ),
            AppSpacing.h16,

            MyTextField(
              controller: controller.confirmPasswordController,
              label: 'Confirm Password',
              obscureText: true,
            ),

            AppSpacing.h16,

            Obx(
              () => CheckboxListTile(
                value: controller.isAgreeTerms.value,
                onChanged: controller.toggleAgreeTerms,
                controlAffinity: ListTileControlAffinity.leading,
                title: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = controller.goToTermsAndConditions,
                      ),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: controller.goToPrivacyPolicy,
                child: const Text('View Privacy Policy'),
              ),
            ),

            AppSpacing.h24,

            // MyButton(text: 'Register', onPressed: controller.register),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.register,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Register'),
                  ),
                ),
              ),
            ),

            AppSpacing.h24,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: controller.goToLogin,
                  child: const Text('Login here'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
