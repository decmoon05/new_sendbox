/// 로컬 저장소 키 상수
class StorageKeys {
  StorageKeys._();

  // 인증
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  
  // 사용자 설정
  static const String userPreferences = 'user_preferences';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String notificationsEnabled = 'notifications_enabled';
  
  // 동기화
  static const String lastSyncTime = 'last_sync_time';
  static const String syncEnabled = 'sync_enabled';
  
  // AI 설정
  static const String aiProvider = 'ai_provider';
  static const String aiOfflineMode = 'ai_offline_mode';
  
  // 암호화
  static const String encryptionKeyAlias = 'sendbox_encryption_key';
  
  // 플랫폼 설정
  static const String enabledPlatforms = 'enabled_platforms';
  static const String platformSettings = 'platform_settings';
}

