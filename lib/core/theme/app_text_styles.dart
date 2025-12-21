import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 앱 텍스트 스타일 시스템 (Pretendard 폰트)
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Pretendard';

  // Headline Styles
  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.normal,
    height: 1.4,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );

  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.4,
    color: Colors.white,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.2,
    color: Colors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0,
    color: Colors.white,
  );

  // Dark Mode Variants
  static TextStyle headline1Dark = headline1.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headline2Dark = headline2.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle headline3Dark = headline3.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle bodyLargeDark = bodyLarge.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle bodyMediumDark = bodyMedium.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle bodySmallDark = bodySmall.copyWith(
    color: AppColors.textPrimaryDark,
  );

  static TextStyle captionDark = caption.copyWith(
    color: AppColors.textSecondaryDark,
  );
}

