import 'package:flutter/material.dart';

/// 앱 색상 시스템 (iOS 스타일)
class AppColors {
  AppColors._();

  // Primary Colors (iOS Blue)
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryDark = Color(0xFF0051D5);
  static const Color primaryLight = Color(0xFF5AC8FA);

  // Secondary Colors
  static const Color secondary = Color(0xFF5856D6);
  static const Color accent = Color(0xFFFF9500);

  // Neutral Colors (Light Mode)
  static const Color background = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF9F9F9);

  // Neutral Colors (Dark Mode)
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color surfaceSecondaryDark = Color(0xFF2C2C2E);

  // Text Colors (Light Mode)
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFC7C7CC);

  // Text Colors (Dark Mode)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
  static const Color textTertiaryDark = Color(0xFF636366);

  // Status Colors
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF007AFF);

  // Divider
  static const Color divider = Color(0xFFC6C6C8);
  static const Color dividerDark = Color(0xFF38383A);

  // Overlay
  static const Color overlay = Color(0x80000000);
  static const Color overlayDark = Color(0x80FFFFFF);
}

