import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:its_tyne_consult/app/core/services/fcm_service.dart';
import 'package:its_tyne_consult/app/core/theme/app_theme.dart';
import 'package:its_tyne_consult/app/modules/auth-gate/bindings/auth_gate_binding.dart';
import 'package:its_tyne_consult/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FcmService.init();

  await GetStorage.init();
  final storage = GetStorage();
  final bool isDarkMode = storage.read('is_dark_mode') ?? false;
  final ThemeMode initialThemeMode = isDarkMode
      ? ThemeMode.dark
      : ThemeMode.light;

  runApp(
    GetMaterialApp(
      title: "ItsTyne Consult",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: initialThemeMode,

      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      initialBinding: AuthGateBinding(),
      getPages: AppPages.routes,
    ),
  );
}
