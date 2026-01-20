import 'package:flutter/material.dart';

/// Centralized color definitions for the app
/// Used by light_theme.dart and dark_theme.dart
class AppColors {
  AppColors._();

  // Brand colors
  static const Color primaryColor = Color(0xFF121B27);
  static const Color secondaryColor = Color(0xFF6C63FF);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF7F7FA);
  static const Color cardLight = Colors.white;

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0F1115);
  static const Color cardDark = Color(0xFF1A1C22);
}
