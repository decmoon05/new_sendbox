import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';

/// 플랫폼 통합 설정 페이지
class PlatformSettingsPage extends ConsumerWidget {
  const PlatformSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('플랫폼 통합'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('메시징 플랫폼'),
          
          // SMS
          _buildPlatformTile(
            context: context,
            icon: Icons.sms,
            title: 'SMS',
            subtitle: '기본 문자 메시지',
            isConnected: true, // SMS는 항상 활성화 가능
            onTap: () {
              // SMS는 항상 활성화되어 있음
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('SMS는 항상 활성화되어 있습니다')),
              );
            },
          ),
          
          // 카카오톡
          _buildPlatformTile(
            context: context,
            icon: Icons.chat,
            title: '카카오톡',
            subtitle: 'Notification Listener 사용',
            isConnected: false, // TODO: 실제 연결 상태 확인
            onTap: () {
              _showKakaoTalkSetupDialog(context);
            },
          ),
          
          const Divider(),
          
          _buildSectionHeader('소셜 미디어'),
          
          // Instagram
          _buildPlatformTile(
            context: context,
            icon: Icons.camera_alt,
            title: 'Instagram',
            subtitle: '곧 지원 예정',
            isConnected: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Instagram 지원은 곧 추가될 예정입니다')),
              );
            },
          ),
          
          // Facebook Messenger
          _buildPlatformTile(
            context: context,
            icon: Icons.facebook,
            title: 'Facebook Messenger',
            subtitle: '곧 지원 예정',
            isConnected: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Facebook Messenger 지원은 곧 추가될 예정입니다')),
              );
            },
          ),
          
          const Divider(),
          
          _buildSectionHeader('기업용 메신저'),
          
          // Discord
          _buildPlatformTile(
            context: context,
            icon: Icons.forum,
            title: 'Discord',
            subtitle: 'Bot API 사용 가능',
            isConnected: false,
            onTap: () {
              _showDiscordSetupDialog(context);
            },
          ),
          
          // Telegram
          _buildPlatformTile(
            context: context,
            icon: Icons.send,
            title: 'Telegram',
            subtitle: 'Bot API 사용 가능',
            isConnected: false,
            onTap: () {
              _showTelegramSetupDialog(context);
            },
          ),
          
          // Slack
          _buildPlatformTile(
            context: context,
            icon: Icons.work,
            title: 'Slack',
            subtitle: '공식 API 사용',
            isConnected: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Slack 통합은 곧 추가될 예정입니다')),
              );
            },
          ),
          
          // Microsoft Teams
          _buildPlatformTile(
            context: context,
            icon: Icons.business,
            title: 'Microsoft Teams',
            subtitle: '공식 API 사용',
            isConnected: false,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Microsoft Teams 통합은 곧 추가될 예정입니다')),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // 안내 메시지
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: AppColors.surfaceSecondary,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          '플랫폼 통합 안내',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Notification Listener: 대부분의 메시징 앱에서 알림을 통해 메시지를 받아옵니다.\n'
                      '• Bot API: Discord, Telegram 등에서 봇을 통해 메시지를 주고받습니다.\n'
                      '• 공식 API: Slack, Teams 등에서 제공하는 공식 API를 사용합니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  Widget _buildPlatformTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isConnected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isConnected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.2),
        child: Icon(
          icon,
          color: isConnected ? Colors.white : AppColors.textSecondary,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '연결됨',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showKakaoTalkSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('카카오톡 통합 설정'),
          content: const Text(
            '카카오톡 통합을 사용하려면 Notification Listener 권한이 필요합니다.\n\n'
            '설정 화면에서 SendBox를 활성화해주세요.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Notification Listener 권한 요청 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('권한 설정 화면으로 이동합니다')),
                );
              },
              child: const Text('설정으로 이동'),
            ),
          ],
        );
      },
    );
  }

  void _showDiscordSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discord 통합 설정'),
          content: const Text(
            'Discord 통합을 사용하려면 Discord Bot Token이 필요합니다.\n\n'
            'Discord 개발자 포털에서 봇을 생성하고 Token을 발급받아주세요.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Discord Bot Token 입력 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Discord Bot 설정은 곧 추가될 예정입니다')),
                );
              },
              child: const Text('설정하기'),
            ),
          ],
        );
      },
    );
  }

  void _showTelegramSetupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Telegram 통합 설정'),
          content: const Text(
            'Telegram 통합을 사용하려면 Telegram Bot Token이 필요합니다.\n\n'
            '@BotFather를 통해 봇을 생성하고 Token을 발급받아주세요.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Telegram Bot Token 입력 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Telegram Bot 설정은 곧 추가될 예정입니다')),
                );
              },
              child: const Text('설정하기'),
            ),
          ],
        );
      },
    );
  }
}

