import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// 에러 표시 위젯
/// 사용자 친화적인 에러 메시지를 표시합니다
class ErrorDisplayWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? title;
  final String? description;

  const ErrorDisplayWidget({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.icon,
    this.title,
    this.description,
  });

  /// 간단한 에러 표시 (메시지만)
  const ErrorDisplayWidget.simple({
    super.key,
    required String message,
    VoidCallback? onRetry,
  })  : errorMessage = message,
        onRetry = onRetry,
        icon = null,
        title = null,
        description = null;

  /// 네트워크 에러 표시
  const ErrorDisplayWidget.network({
    super.key,
    VoidCallback? onRetry,
    String? message,
  })  : errorMessage = message ?? '네트워크 연결을 확인해주세요',
        onRetry = onRetry,
        icon = Icons.wifi_off,
        title = '연결 오류',
        description = '인터넷 연결 상태를 확인하고 다시 시도해주세요';

  /// 데이터 로드 에러 표시
  const ErrorDisplayWidget.dataLoad({
    super.key,
    VoidCallback? onRetry,
    String? message,
  })  : errorMessage = message ?? '데이터를 불러올 수 없습니다',
        onRetry = onRetry,
        icon = Icons.error_outline,
        title = '로드 실패',
        description = '데이터를 불러오는 중 문제가 발생했습니다';

  /// 권한 에러 표시
  const ErrorDisplayWidget.permission({
    super.key,
    VoidCallback? onRetry,
    String? message,
  })  : errorMessage = message ?? '권한이 필요합니다',
        onRetry = onRetry,
        icon = Icons.lock_outline,
        title = '권한 필요',
        description = '이 기능을 사용하려면 권한이 필요합니다';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            if (icon != null)
              Icon(
                icon,
                size: 64,
                color: AppColors.error.withOpacity(0.7),
              )
            else
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error.withOpacity(0.7),
              ),
            const SizedBox(height: 24),

            // 제목
            if (title != null)
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),

            // 설명
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],

            // 에러 메시지 (상세)
            if (errorMessage != null && errorMessage!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // 재시도 버튼
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 빈 상태 위젯
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  });

  /// 대화 목록이 비어있을 때
  const EmptyStateWidget.noConversations({
    super.key,
    Widget? action,
  })  : icon = Icons.chat_bubble_outline,
        title = '대화가 없습니다',
        description = '새로운 대화를 시작해보세요',
        action = action;

  /// 프로필 목록이 비어있을 때
  const EmptyStateWidget.noProfiles({
    super.key,
    Widget? action,
  })  : icon = Icons.people_outline,
        title = '프로필이 없습니다',
        description = '새 프로필을 추가해보세요',
        action = action;

  /// 검색 결과가 없을 때
  const EmptyStateWidget.noSearchResults({
    super.key,
    String? query,
  })  : icon = Icons.search_off,
        title = '검색 결과가 없습니다',
        description = query != null
            ? '"$query"에 대한 결과를 찾을 수 없습니다'
            : '검색어를 변경해보세요',
        action = null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

