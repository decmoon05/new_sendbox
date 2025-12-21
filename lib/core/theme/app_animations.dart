import 'package:flutter/material.dart';

/// 앱 애니메이션 상수
class AppAnimations {
  AppAnimations._();

  // Duration
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Duration verySlow = Duration(milliseconds: 500);

  // Curves (Apple 스타일 부드러운 애니메이션)
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.easeOutBack;
  static const Curve springCurve = Curves.easeInOut;

  // Page Transitions
  static const Duration pageTransitionDuration = normal;
  static const Curve pageTransitionCurve = defaultCurve;

  // Hero Animations
  static const Duration heroDuration = Duration(milliseconds: 300);
  static const Curve heroCurve = defaultCurve;

  // Fade Animations
  static const Duration fadeDuration = fast;
  static const Curve fadeCurve = defaultCurve;

  // Scale Animations
  static const Duration scaleDuration = normal;
  static const Curve scaleCurve = bounceCurve;

  // Slide Animations
  static const Duration slideDuration = normal;
  static const Curve slideCurve = defaultCurve;
}

/// 애니메이션 빌더 유틸리티
class AnimationBuilders {
  AnimationBuilders._();

  /// 페이드 인 애니메이션
  static Widget fadeIn({
    required Widget child,
    Duration duration = AppAnimations.fadeDuration,
    Curve curve = AppAnimations.fadeCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// 스케일 애니메이션
  static Widget scale({
    required Widget child,
    double begin = 0.8,
    double end = 1.0,
    Duration duration = AppAnimations.scaleDuration,
    Curve curve = AppAnimations.scaleCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// 슬라이드 애니메이션
  static Widget slide({
    required Widget child,
    Offset offset = const Offset(0, 0.1),
    Duration duration = AppAnimations.slideDuration,
    Curve curve = AppAnimations.slideCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: offset, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value * MediaQuery.of(context).size.height,
          child: child,
        );
      },
      child: child,
    );
  }
}

