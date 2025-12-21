import 'package:flutter/material.dart';
import '../../../../../domain/entities/ai_recommendation.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/extensions/datetime_extensions.dart';

/// AI 추천 메시지 카드
class AIRecommendationCard extends StatelessWidget {
  final MessageOption option;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;

  const AIRecommendationCard({
    super.key,
    required this.option,
    this.onTap,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      option.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (onCopy != null)
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: onCopy,
                      tooltip: '복사',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildChip(
                    context,
                    option.tone,
                    _getToneColor(option.tone),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      option.reason,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (option.confidence > 0) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: option.confidence / 100,
                  backgroundColor: AppColors.surfaceSecondary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getToneColor(option.tone),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Color _getToneColor(String tone) {
    switch (tone.toLowerCase()) {
      case 'formal':
        return AppColors.info;
      case 'casual':
        return AppColors.primary;
      case 'friendly':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }
}

