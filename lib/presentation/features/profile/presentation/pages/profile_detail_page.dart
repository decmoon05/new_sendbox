import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/extensions/datetime_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../routes/route_names.dart';
import '../providers/profile_provider.dart';

/// 프로필 상세 페이지
class ProfileDetailPage extends ConsumerWidget {
  final String profileId;

  const ProfileDetailPage({
    super.key,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 프로필 편집 기능
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('프로필을 찾을 수 없습니다'));
          }
          return _buildProfileContent(context, profile);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('오류: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(profileProvider(profileId)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ContactProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 헤더
          _buildProfileHeader(context, profile),
          const SizedBox(height: 24),
          
          // 기본 정보
          _buildSectionTitle('기본 정보'),
          _buildBasicInfo(context, profile),
          const SizedBox(height: 24),
          
          // 플랫폼 정보
          if (profile.platforms.isNotEmpty) ...[
            _buildSectionTitle('연동된 플랫폼'),
            _buildPlatforms(context, profile.platforms),
            const SizedBox(height: 24),
          ],
          
          // AI 분석 결과
          if (profile.aiAnalysis != null) ...[
            _buildSectionTitle('AI 분석'),
            _buildAIAnalysis(context, profile.aiAnalysis!),
            const SizedBox(height: 24),
          ],
          
          // 태그
          if (profile.tags.isNotEmpty) ...[
            _buildSectionTitle('태그'),
            _buildTags(context, profile.tags),
            const SizedBox(height: 24),
          ],
          
          // 메모
          if (profile.notes != null && profile.notes!.isNotEmpty) ...[
            _buildSectionTitle('메모'),
            _buildNotes(context, profile.notes!),
            const SizedBox(height: 24),
          ],
          
          // 통계
          _buildSectionTitle('통계'),
          _buildStatistics(context, profile),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ContactProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              backgroundImage: profile.photoUrl != null
                  ? NetworkImage(profile.photoUrl!)
                  : null,
              child: profile.photoUrl == null
                  ? Text(
                      profile.name.isNotEmpty
                          ? profile.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (profile.priority >= 4) ...[
              const SizedBox(height: 8),
              const Icon(Icons.star, color: AppColors.warning),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context, ContactProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (profile.phoneNumber != null)
              _buildInfoRow(
                context,
                Icons.phone,
                '전화번호',
                profile.phoneNumber!,
              ),
            if (profile.email != null) ...[
              if (profile.phoneNumber != null) const Divider(),
              _buildInfoRow(
                context,
                Icons.email,
                '이메일',
                profile.email!,
              ),
            ],
            const Divider(),
            _buildInfoRow(
              context,
              Icons.priority_high,
              '중요도',
              '${profile.priority} / 5',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatforms(BuildContext context, List<PlatformIdentifier> platforms) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: platforms.map((platform) {
            return ListTile(
              leading: Icon(_getPlatformIcon(platform.platform)),
              title: Text(_getPlatformName(platform.platform)),
              subtitle: Text(platform.identifier),
              trailing: Text(
                platform.messageCount.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAIAnalysis(BuildContext context, ProfileAnalysis analysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalysisItem('관계', analysis.relationship),
            const Divider(),
            _buildAnalysisItem('톤', analysis.tone),
            const Divider(),
            _buildAnalysisItem('감정', analysis.sentiment),
            if (analysis.interests.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '관심사',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: analysis.interests.map((interest) {
                        return Chip(label: Text(interest));
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
            if (analysis.topics.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '주요 주제',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: analysis.topics.map((topic) {
                        return Chip(
                          label: Text(topic),
                          backgroundColor: AppColors.surfaceSecondary,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '분석 일시: ${analysis.analyzedAt.formattedDateTime}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context, List<String> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Chip(
          label: Text(tag),
          backgroundColor: AppColors.primary.withOpacity(0.1),
        );
      }).toList(),
    );
  }

  Widget _buildNotes(BuildContext context, String notes) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          notes,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, ContactProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              context,
              Icons.access_time,
              '생성일',
              profile.createdAt.formattedDateTime,
            ),
            const Divider(),
            _buildInfoRow(
              context,
              Icons.update,
              '수정일',
              profile.updatedAt.formattedDateTime,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'sms':
        return Icons.sms;
      case 'kakao':
      case 'kakaotalk':
        return Icons.chat;
      case 'discord':
        return Icons.forum;
      case 'instagram':
        return Icons.camera_alt;
      case 'telegram':
        return Icons.send;
      default:
        return Icons.devices;
    }
  }

  String _getPlatformName(String platform) {
    switch (platform.toLowerCase()) {
      case 'sms':
        return 'SMS';
      case 'kakao':
      case 'kakaotalk':
        return '카카오톡';
      case 'discord':
        return '디스코드';
      case 'instagram':
        return '인스타그램';
      case 'telegram':
        return '텔레그램';
      default:
        return platform;
    }
  }
}

