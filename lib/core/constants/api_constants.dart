/// API 엔드포인트 및 설정 상수
class ApiConstants {
  ApiConstants._();

  // Firebase
  static const String firebaseCollectionUsers = 'users';
  static const String firebaseCollectionConversations = 'conversations';
  static const String firebaseCollectionProfiles = 'profiles';
  static const String firebaseCollectionCallRecords = 'callRecords';
  
  // Google Gemini API
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String geminiModel = 'gemini-pro';
  
  // 자체 백엔드 API (향후 확장용)
  static const String apiBaseUrlDev = 'https://api-dev.sendbox.app/v1';
  static const String apiBaseUrlProd = 'https://api.sendbox.app/v1';
  
  // API 엔드포인트
  static const String endpointAuth = '/auth';
  static const String endpointSync = '/sync';
  static const String endpointConversations = '/conversations';
  static const String endpointProfiles = '/profiles';
  
  // Request timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Headers
  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerContentTypeJson = 'application/json';
  static const String headerBearerPrefix = 'Bearer ';
}

