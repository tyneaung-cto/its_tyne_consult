import 'package:flutter/material.dart';

import 'light_theme.dart';
import 'dark_theme.dart';

/// Central theme access point for the app
/// Use this class in main.dart
class AppTheme {
  AppTheme._();

  /// Light theme (delegated)
  static ThemeData get light => AppLightTheme.lightTheme;

  /// Dark theme (delegated)
  static ThemeData get dark => AppDarkTheme.darkTheme;
}
