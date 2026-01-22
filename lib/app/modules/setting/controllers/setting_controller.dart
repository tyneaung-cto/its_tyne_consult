import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/services/auth_service.dart';

class SettingController extends GetxController {
  static const String _themeKey = 'is_dark_mode';
  static const String _langKey = 'app_language';

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
        Get.changeThemeMode(savedTheme ? ThemeMode.dark : ThemeMode.light);
      });
    }

    final savedLang = _box.read(_langKey);
    if (savedLang != null && savedLang is String) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🌐 Restoring saved language -> $savedLang');

        if (savedLang == 'my') {
          currentLanguage.value = 'Myanmar';
          Get.updateLocale(const Locale('my', 'MM'));
        } else {
          currentLanguage.value = 'English';
          Get.updateLocale(const Locale('en', 'US'));
        }
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
  // void changeLanguage() {
  //   final next = currentLanguage.value == 'English' ? 'Myanmar' : 'English';
  //   debugPrint('🌐 changeLanguage() tapped -> switching to $next');
  //   setLanguage(next);
  // }

  /// Explicitly set language (better for toggles / flags)
  void setLanguage(String language) {
    debugPrint('🌐 setLanguage() called with = $language');

    // accept either display text or short code
    final isMyanmar = language == 'my' || language == 'Myanmar';

    final langCode = isMyanmar ? 'my' : 'en';
    final locale = isMyanmar
        ? const Locale('my', 'MM')
        : const Locale('en', 'US');

    // update display label
    currentLanguage.value = isMyanmar ? 'Myanmar' : 'English';

    // persist only short code
    _box.write(_langKey, langCode);

    debugPrint('💾 Saved to storage: $_langKey = $langCode');
    debugPrint('🚀 Updating GetX locale -> $locale');

    Get.updateLocale(locale);

    debugPrint('✅ Locale updated successfully');
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
    Get.toNamed('/about');
  }

  /// Open Privacy Policy
  void openPrivacyPolicy() {
    // TODO: Open privacy policy URL
    // launchUrl(Uri.parse('https://itstyne.com/privacy-policy'));
    Get.toNamed('/privacy-policy');
  }

  /// Open Terms & Conditions
  void openTerms() {
    // TODO: Open terms URL
    // launchUrl(Uri.parse('https://itstyne.com/terms'));
    Get.toNamed('/terms-and-conditions');
  }
}
