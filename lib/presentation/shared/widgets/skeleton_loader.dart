import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// 스켈레톤 로더 위젯
/// 로딩 중일 때 표시되는 플레이스홀더 UI
class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  /// 대화 목록 아이템 스켈레톤
  const SkeletonLoader.conversationItem({
    super.key,
    this.baseColor,
    this.highlightColor,
  }) : width = null,
        height = null,
        borderRadius = const BorderRadius.all(Radius.circular(12));

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceSecondaryDark
            : AppColors.surfaceSecondary);

    final highlightColor = widget.highlightColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surface);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            color: Color.lerp(baseColor, highlightColor, _animation.value),
          ),
        );
      },
    );
  }
}

/// 대화 목록 스켈레톤
class ConversationListSkeleton extends StatelessWidget {
  final int itemCount;

  const ConversationListSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // 아바타
              const SkeletonLoader(
                width: 56,
                height: 56,
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              const SizedBox(width: 16),
              // 내용
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(height: 16, width: 120),
                    const SizedBox(height: 8),
                    const SkeletonLoader(height: 14, width: 200),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 시간
              const SkeletonLoader(height: 12, width: 40),
            ],
          ),
        );
      },
    );
  }
}

/// 프로필 목록 스켈레톤
class ProfileListSkeleton extends StatelessWidget {
  final int itemCount;

  const ProfileListSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              // 아바타
              const SkeletonLoader(
                width: 56,
                height: 56,
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              const SizedBox(width: 16),
              // 이름
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(height: 18, width: 100),
                    const SizedBox(height: 4),
                    const SkeletonLoader(height: 14, width: 150),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

