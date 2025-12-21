import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

/// 설정 서비스
/// SharedPreferences를 사용하여 앱 설정을 저장하고 불러옵니다
class SettingsService {
  static SharedPreferences? _prefs;

  /// SharedPreferences 초기화
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// 알림 설정
  static bool get notificationsEnabled {
    return _prefs?.getBool(StorageKeys.notificationsEnabled) ?? true;
  }

  static Future<bool> setNotificationsEnabled(bool value) async {
    return await _prefs?.setBool(StorageKeys.notificationsEnabled, value) ?? false;
  }

  /// 진동 설정
  static bool get vibrationEnabled {
    return _prefs?.getBool('vibration_enabled') ?? true;
  }

  static Future<bool> setVibrationEnabled(bool value) async {
    return await _prefs?.setBool('vibration_enabled', value) ?? false;
  }

  /// AI 추천 활성화
  static bool get aiRecommendationsEnabled {
    return _prefs?.getBool('ai_recommendations_enabled') ?? true;
  }

  static Future<bool> setAiRecommendationsEnabled(bool value) async {
    return await _prefs?.setBool('ai_recommendations_enabled', value) ?? false;
  }

  /// 자동 동기화 설정
  static bool get autoSyncEnabled {
    return _prefs?.getBool(StorageKeys.syncEnabled) ?? true;
  }

  static Future<bool> setAutoSyncEnabled(bool value) async {
    return await _prefs?.setBool(StorageKeys.syncEnabled, value) ?? false;
  }

  /// 테마 설정 (light, dark, system)
  static String get theme {
    return _prefs?.getString(StorageKeys.theme) ?? 'system';
  }

  static Future<bool> setTheme(String value) async {
    return await _prefs?.setString(StorageKeys.theme, value) ?? false;
  }

  /// 언어 설정
  static String get language {
    return _prefs?.getString(StorageKeys.language) ?? 'ko';
  }

  static Future<bool> setLanguage(String value) async {
    return await _prefs?.setString(StorageKeys.language, value) ?? false;
  }

  /// 모든 설정 초기화
  static Future<bool> clearAll() async {
    return await _prefs?.clear() ?? false;
  }
}

