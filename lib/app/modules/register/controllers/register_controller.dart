import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();

  // Text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Terms & conditions checkbox
  final RxBool isAgreeTerms = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Toggle terms agreement
  void toggleAgreeTerms(bool? value) {
    isAgreeTerms.value = value ?? false;
  }

  /// Register action (business logic will be added later)
  Future<void> register() async {
    if (!isAgreeTerms.value) {
      Get.snackbar(
        'Agreement Required',
        'Please agree to the Terms & Conditions to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final userName = usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final user = await _authService.registerWithEmailAndPassword(
        email,
        password,
        userName,
      );

      if (user != null) {
        Get.snackbar(
          'Account Created',
          'Your account has been created successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );

        // AuthGate will handle navigation
      } else {
        Get.snackbar(
          'Registration Failed',
          'Unable to create account. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        // 'Something went wrong. Please try again later.',
        '${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Navigate to login page
  void goToLogin() {
    Get.offNamed('/login');
  }

  /// Navigate to privacy policy page
  void goToPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  /// Navigate to Terms & Conditions page
  void goToTermsAndConditions() {
    Get.toNamed('/terms-and-conditions');
  }
}
