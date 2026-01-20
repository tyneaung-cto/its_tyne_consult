import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/auth_service.dart';

class SettingController extends GetxController {
  static const String _themeKey = 'is_dark_mode';

  final GetStorage _box = GetStorage();
  /// Theme state
  final RxBool isDarkMode = false.obs;

  /// Language state (display name)
  final RxString currentLanguage = 'English'.obs;

  /// Services
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();

    final savedTheme = _box.read(_themeKey);
    if (savedTheme != null && savedTheme is bool) {
      isDarkMode.value = savedTheme;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.changeThemeMode(
          savedTheme ? ThemeMode.dark : ThemeMode.light,
        );
      });
    }
  }

  /// Toggle light / dark theme
  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _box.write(_themeKey, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Change application language
  void changeLanguage() {
    // MVP: simple toggle for demo purpose
    if (currentLanguage.value == 'English') {
      currentLanguage.value = 'Myanmar';
      // Example:
      // Get.updateLocale(const Locale('my', 'MM'));
    } else {
      currentLanguage.value = 'English';
      // Get.updateLocale(const Locale('en', 'US'));
    }
  }

  /// Navigate to profile page
  void goToProfile() {
    // TODO: Implement profile navigation
    // Get.toNamed('/profile');
  }

  /// Logout user
  void logout() async {
    await _authService.signOut();
    // AuthGateController will handle navigation
  }

  /// Open About page
  void openAbout() {
    // TODO: Implement about page navigation
    // Get.toNamed('/about');
  }

  /// Open Privacy Policy
  void openPrivacyPolicy() {
    // TODO: Open privacy policy URL
    // launchUrl(Uri.parse('https://itstyne.com/privacy-policy'));
  }

  /// Open Terms & Conditions
  void openTerms() {
    // TODO: Open terms URL
    // launchUrl(Uri.parse('https://itstyne.com/terms'));
  }
}
