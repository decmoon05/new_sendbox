import 'package:flutter/material.dart';
import 'route_names.dart';
import 'page_route_builder.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/chat/presentation/pages/conversation_create_page.dart';
import '../features/chat/presentation/pages/chat_detail_page.dart';
import '../features/profile/presentation/pages/profile_list_page.dart';
import '../features/profile/presentation/pages/profile_create_page.dart';
import '../features/profile/presentation/pages/profile_detail_page.dart';
import '../features/profile/presentation/pages/profile_edit_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/settings/presentation/pages/platform_settings_page.dart';

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

      case RouteNames.conversationCreate:
        return PageRouteBuilder.slideAndFade(
          const ConversationCreatePage(),
        );

      case RouteNames.chatDetail:
        final id = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ChatDetailPage(conversationId: id),
          settings: settings,
        );

      case RouteNames.profiles:
        return MaterialPageRoute(
          builder: (_) => const ProfileListPage(),
        );

      case RouteNames.profileCreate:
        return PageRouteBuilder.slideAndFade(
          const ProfileCreatePage(),
        );

      case RouteNames.profileDetail:
        final id = settings.arguments as String? ?? '';
        return PageRouteBuilder.slideRightToLeft(
          ProfileDetailPage(profileId: id),
        );

      case RouteNames.profileEdit:
        final id = settings.arguments as String? ?? '';
        return PageRouteBuilder.slideAndFade(
          ProfileEditPage(profileId: id),
        );

          case RouteNames.settings:
            return MaterialPageRoute(
              builder: (_) => const SettingsPage(),
            );

      case RouteNames.platformSettings:
        return PageRouteBuilder.slideRightToLeft(
          const PlatformSettingsPage(),
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

