import 'package:flutter/material.dart';
import 'route_names.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/profile/presentation/pages/profile_list_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';

/// 앱 라우터
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const ChatPage(), // 임시로 ChatPage를 홈으로
        );

      case RouteNames.chat:
        return MaterialPageRoute(
          builder: (_) => const ChatPage(),
        );

      case RouteNames.chatDetail:
        final id = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => const ChatPage(), // TODO: ChatDetailPage 구현
          settings: settings,
        );

      case RouteNames.profiles:
        return MaterialPageRoute(
          builder: (_) => const ProfileListPage(),
        );

      case RouteNames.profileDetail:
        final id = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => const ProfileListPage(), // TODO: ProfileDetailPage 구현
          settings: settings,
        );

      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('페이지를 찾을 수 없습니다: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

