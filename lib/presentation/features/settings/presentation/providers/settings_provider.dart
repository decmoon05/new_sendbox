import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/settings_service.dart';

/// 설정 상태
class SettingsState {
  final bool notificationsEnabled;
  final bool vibrationEnabled;
  final bool aiRecommendationsEnabled;
  final bool autoSyncEnabled;
  final String theme;
  final String language;

  const SettingsState({
    this.notificationsEnabled = true,
    this.vibrationEnabled = true,
    this.aiRecommendationsEnabled = true,
    this.autoSyncEnabled = true,
    this.theme = 'system',
    this.language = 'ko',
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? vibrationEnabled,
    bool? aiRecommendationsEnabled,
    bool? autoSyncEnabled,
    String? theme,
    String? language,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      aiRecommendationsEnabled: aiRecommendationsEnabled ?? this.aiRecommendationsEnabled,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }
}

/// 설정 Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/// 설정 Notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    loadSettings();
  }

  /// 설정 불러오기
  Future<void> loadSettings() async {
    await SettingsService.init();
    
    state = SettingsState(
      notificationsEnabled: SettingsService.notificationsEnabled,
      vibrationEnabled: SettingsService.vibrationEnabled,
      aiRecommendationsEnabled: SettingsService.aiRecommendationsEnabled,
      autoSyncEnabled: SettingsService.autoSyncEnabled,
      theme: SettingsService.theme,
      language: SettingsService.language,
    );
  }

  /// 알림 설정 변경
  Future<void> setNotificationsEnabled(bool value) async {
    await SettingsService.setNotificationsEnabled(value);
    state = state.copyWith(notificationsEnabled: value);
  }

  /// 진동 설정 변경
  Future<void> setVibrationEnabled(bool value) async {
    await SettingsService.setVibrationEnabled(value);
    state = state.copyWith(vibrationEnabled: value);
  }

  /// AI 추천 설정 변경
  Future<void> setAiRecommendationsEnabled(bool value) async {
    await SettingsService.setAiRecommendationsEnabled(value);
    state = state.copyWith(aiRecommendationsEnabled: value);
  }

  /// 자동 동기화 설정 변경
  Future<void> setAutoSyncEnabled(bool value) async {
    await SettingsService.setAutoSyncEnabled(value);
    state = state.copyWith(autoSyncEnabled: value);
  }

  /// 테마 설정 변경
  Future<void> setTheme(String value) async {
    await SettingsService.setTheme(value);
    state = state.copyWith(theme: value);
  }

  /// 언어 설정 변경
  Future<void> setLanguage(String value) async {
    await SettingsService.setLanguage(value);
    state = state.copyWith(language: value);
  }
}

