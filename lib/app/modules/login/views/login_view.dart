import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:its_tyne_consult/app/core/values/app_spacing.dart';
import 'package:its_tyne_consult/app/shared/widgets/my_text_field.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // add icon
              Image.asset(
                'assets/itstyne-logo.png',
                height: 120,
                fit: BoxFit.contain,
              ),
              AppSpacing.h12,

              // welcome text
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              AppSpacing.h32,

              // email textfield
              MyTextField(
                label: "Email",
                controller: controller.emailController,
              ),
              AppSpacing.h16,

              // password textfield
              MyTextField(
                label: "Password",
                obscureText: true,
                controller: controller.passwordController,
              ),
              AppSpacing.h16,

              // forgot password link
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed('/forget-password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.h24,

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.loginWithEmailAndPassword,
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
                    ),
                  ),
                ),
              ),
              AppSpacing.h16,

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                    child: Text(
                      'Register now',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
