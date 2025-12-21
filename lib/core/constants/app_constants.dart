/// 앱 전역 상수
class AppConstants {
  AppConstants._();

  // 앱 정보
  static const String appName = 'SendBox';
  static const String appVersion = '1.0.0';
  
  // 데이터베이스
  static const String localDatabaseName = 'sendbox.db';
  static const int databaseVersion = 1;
  
  // 페이지네이션
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 메시지
  static const int maxMessageLength = 10000;
  static const int maxProfileNameLength = 100;
  
  // 동기화
  static const Duration syncInterval = Duration(minutes: 5);
  static const int maxSyncRetries = 3;
  static const Duration syncRetryDelay = Duration(seconds: 5);
  
  // AI
  static const int maxRecommendationCount = 5;
  static const Duration aiRequestTimeout = Duration(seconds: 30);
  
  // 캐시
  static const Duration cacheExpiration = Duration(hours: 24);
  
  // 파일 크기 제한 (bytes)
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
}

