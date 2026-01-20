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
    isLoading.value = true;
    email.value = emailController.text;
    password.value = passwordController.text;
    final user =
        await _authService.signInWithEmailAndPassword(email.value.trim(), password.value.trim());

    if (user == null) {
      Get.snackbar(
        'Login Failed',
        'Invalid email or password',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    // Success case is handled automatically by AuthGateController
  }
}
