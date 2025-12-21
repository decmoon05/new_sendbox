/// 라우트 이름 상수
class RouteNames {
  RouteNames._();

  // 인증
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/signup';

  // 메인
  static const String home = '/home';
  static const String chat = '/chat';
  static const String conversationCreate = '/chat/create';
  static const String chatDetail = '/chat/:id';

  // 프로필
  static const String profiles = '/profiles';
  static const String profileCreate = '/profiles/create';
  static const String profileDetail = '/profiles/:id';
  static const String profileEdit = '/profiles/:id/edit';

  // 설정
  static const String settings = '/settings';
}

