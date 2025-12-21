import 'package:flutter/material.dart';
import '../../../core/theme/app_animations.dart';

/// 커스텀 페이지 전환 애니메이션
class PageRouteBuilder {
  /// 슬라이드 애니메이션 (오른쪽에서 왼쪽으로)
  static PageRoute<T> slideRightToLeft<T extends Object?>(
    Widget page,
  ) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: AppAnimations.pageTransitionDuration,
      reverseTransitionDuration: AppAnimations.pageTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// 페이드 애니메이션
  static PageRoute<T> fade<T extends Object?>(
    Widget page,
  ) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: AppAnimations.pageTransitionDuration,
      reverseTransitionDuration: AppAnimations.pageTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  /// 스케일 애니메이션
  static PageRoute<T> scale<T extends Object?>(
    Widget page,
  ) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: AppAnimations.pageTransitionDuration,
      reverseTransitionDuration: AppAnimations.pageTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }

  /// 슬라이드 + 페이드 조합 애니메이션
  static PageRoute<T> slideAndFade<T extends Object?>(
    Widget page,
  ) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: AppAnimations.pageTransitionDuration,
      reverseTransitionDuration: AppAnimations.pageTransitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(slideTween),
            child: child,
          ),
        );
      },
    );
  }
}

