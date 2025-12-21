import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/di/providers.dart';
import '../../../../../core/services/settings_service.dart';
import '../../../../routes/route_names.dart';

/// 설정 페이지
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      // Settings는 SettingsService를 통해 직접 접근
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 계정 설정 섹션
          _buildSectionHeader('계정'),
          _buildListTile(
            context: context,
            icon: Icons.person_outline,
            title: '프로필',
            subtitle: '계정 정보 관리',
            onTap: () {
              // TODO: 프로필 설정 페이지로 이동
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.security,
            title: '보안',
            subtitle: '암호화 및 보안 설정',
            onTap: () {
              // TODO: 보안 설정 페이지로 이동
            },
          ),
          const Divider(),

          // 알림 설정 섹션
          _buildSectionHeader('알림'),
          _buildSwitchTile(
            context: context,
            icon: Icons.notifications_outlined,
            title: '푸시 알림',
            subtitle: '새 메시지 알림 받기',
            value: SettingsService.notificationsEnabled,
            onChanged: (value) {
                SettingsService.setNotificationsEnabled(value);
            },
          ),
          _buildSwitchTile(
            context: context,
            icon: Icons.vibration,
            title: '진동',
            subtitle: '알림 시 진동',
            value: SettingsService.vibrationEnabled,
            onChanged: (value) {
                SettingsService.setVibrationEnabled(value);
            },
          ),
          const Divider(),

          // 메시지 설정 섹션
          _buildSectionHeader('메시지'),
          _buildSwitchTile(
            context: context,
            icon: Icons.auto_awesome,
            title: 'AI 추천 활성화',
            subtitle: '메시지 추천 기능 사용',
            value: SettingsService.aiRecommendationsEnabled,
            onChanged: (value) {
                SettingsService.setAiRecommendationsEnabled(value);
            },
          ),
          _buildSwitchTile(
            context: context,
            icon: Icons.sync,
            title: '자동 동기화',
            subtitle: '클라우드와 자동 동기화',
            value: SettingsService.autoSyncEnabled,
            onChanged: (value) {
                SettingsService.setAutoSyncEnabled(value);
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.extension,
            title: '플랫폼 통합',
            subtitle: '연결된 메신저 플랫폼 관리',
            onTap: () {
              Navigator.pushNamed(context, RouteNames.platformSettings);
            },
          ),
          const Divider(),

          // 데이터 관리 섹션
          _buildSectionHeader('데이터'),
          _buildListTile(
            context: context,
            icon: Icons.cloud_upload,
            title: '클라우드 백업',
            subtitle: '데이터 백업 및 복원',
            onTap: () {
              // TODO: 백업 페이지로 이동
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.delete_outline,
            title: '캐시 정리',
            subtitle: '임시 파일 및 캐시 삭제',
            onTap: () {
              _showClearCacheDialog(context);
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.download,
            title: '데이터 내보내기',
            subtitle: '대화 및 프로필 데이터 내보내기',
            onTap: () {
              // TODO: 데이터 내보내기 기능
            },
          ),
          const Divider(),

          // 앱 정보 섹션
          _buildSectionHeader('앱 정보'),
          _buildListTile(
            context: context,
            icon: Icons.info_outline,
            title: '버전',
            subtitle: '1.0.0 (빌드 1)', // TODO: 실제 버전 정보 가져오기
            onTap: () {
              // TODO: 버전 정보 상세 보기
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.description_outlined,
            title: '이용약관',
            onTap: () {
              // TODO: 이용약관 페이지로 이동
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: '개인정보 처리방침',
            onTap: () {
              // TODO: 개인정보 처리방침 페이지로 이동
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.help_outline,
            title: '도움말',
            onTap: () {
              // TODO: 도움말 페이지로 이동
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.feedback_outlined,
            title: '피드백 보내기',
            onTap: () {
              // TODO: 피드백 기능
            },
          ),
          const SizedBox(height: 24),

          // 로그아웃 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text('로그아웃'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('캐시 정리'),
          content: const Text('임시 파일과 캐시를 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearCache(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('캐시가 정리되었습니다')),
                );
              },
              child: const Text('정리', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃하시겠습니까?\n\n모든 로컬 데이터가 유지됩니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _logout(context, ref);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그아웃되었습니다')),
                );
              },
              child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// 캐시 정리
  Future<void> _clearCache(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('캐시 정리'),
        content: const Text('캐시를 정리하시겠습니까?\n\n이 작업은 일시적으로 앱 속도를 느리게 만들 수 있습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('정리'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // SharedPreferences 캐시 정리 (설정 제외)
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final settingsKeys = [
        'user_preferences',
        'language',
        'theme',
        'notifications_enabled',
        'vibration_enabled',
        'ai_recommendation_enabled',
        'offline_mode_enabled',
        'auto_sync_enabled',
      ];

      int clearedCount = 0;
      for (final key in keys) {
        if (!settingsKeys.contains(key)) {
          await prefs.remove(key);
          clearedCount++;
        }
      }

      // 이미지 캐시 정리 (Flutter에서 기본 제공하는 캐시는 자동 관리됨)
      // 필요시 추가 구현

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('캐시가 정리되었습니다. ($clearedCount개 항목)')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('캐시 정리 실패: $e')),
        );
      }
    }
  }

  /// 로그아웃
  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Firebase 로그아웃 (있는 경우)
      final firebaseAuth = ref.read(firebaseAuthProvider);
      if (firebaseAuth != null && firebaseAuth.currentUser != null) {
        await firebaseAuth.signOut();
      }

      // 로컬 토큰 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_id');

      // 설정 초기화 (선택사항)
      // await ref.read(settingsServiceProvider).clearAllSettings();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그아웃되었습니다')),
        );
        
        // 로그인 화면으로 이동 (홈 화면으로 임시 이동)
        // TODO: 로그인 화면이 구현되면 RouteNames.login 사용
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteNames.home,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그아웃 실패: $e')),
        );
      }
    }
  }
}
