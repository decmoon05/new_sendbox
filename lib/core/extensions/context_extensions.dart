import 'package:flutter/material.dart';

/// BuildContext 확장 메서드
extension ContextExtensions on BuildContext {
  /// MediaQuery 데이터 가져오기
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// 화면 너비
  double get width => mediaQuery.size.width;

  /// 화면 높이
  double get height => mediaQuery.size.height;

  /// 화면 밀도
  double get pixelRatio => mediaQuery.devicePixelRatio;

  /// 텍스트 스케일 팩터
  double get textScaleFactor => mediaQuery.textScaleFactor;

  /// 안전 영역 (노치, 상태바 등 제외)
  EdgeInsets get padding => mediaQuery.padding;

  /// 안전 영역 상단
  double get topPadding => padding.top;

  /// 안전 영역 하단
  double get bottomPadding => padding.bottom;

  /// 테마 데이터 가져오기
  ThemeData get theme => Theme.of(this);

  /// 텍스트 테마 가져오기
  TextTheme get textTheme => theme.textTheme;

  /// 색상 스키마 가져오기
  ColorScheme get colorScheme => theme.colorScheme;

  /// 네비게이터 가져오기
  NavigatorState get navigator => Navigator.of(this);

  /// 스캐폴드 메신저 가져오기 (스낵바 등)
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// 스캐폴드 가져오기
  ScaffoldState? get scaffold => Scaffold.maybeOf(this);

  /// 포커스 스코프 가져오기
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// 키보드 닫기
  void hideKeyboard() {
    focusScope.unfocus();
  }

  /// 스낵바 표시
  void showSnackBar(String message, {Duration? duration}) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }
}

