import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordController extends GetxController {
  /// Text controller for email input
  final TextEditingController emailController = TextEditingController();

  /// Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Loading state
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Email Required',
        'Please enter your email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      await _auth.sendPasswordResetEmail(email: email);

      Get.snackbar(
        'Reset Email Sent',
        'We have sent a password reset email. Please check your inbox and follow the instructions.',
        snackPosition: SnackPosition.BOTTOM,
      );

      emailController.clear();
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Reset Failed',
        e.message ?? 'Unable to send reset email.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (_) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate back to login page
  void goBackToLogin() {
    Get.back();
  }
}
