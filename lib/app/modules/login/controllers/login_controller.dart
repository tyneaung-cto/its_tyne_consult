import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:its_tyne_consult/app/core/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();
  final RxBool isLoading = false.obs;
  final RxString email = ''.obs;
  final RxString password = ''.obs;
  final RxString errorMessage = ''.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loginWithEmailAndPassword() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      email.value = emailController.text.trim();
      password.value = passwordController.text.trim();

      if (email.value.isEmpty || password.value.isEmpty) {
        Get.snackbar(
          'Missing Info',
          'Please enter email and password',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final user = await _authService.signInWithEmailAndPassword(
        email.value,
        password.value,
      );

      if (user == null) {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      // Success handled by AuthGateController
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
