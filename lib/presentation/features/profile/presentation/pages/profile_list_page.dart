import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';

/// 프로필 목록 페이지
class ProfileListPage extends ConsumerWidget {
  const ProfileListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('연락처'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: 검색 기능 구현
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileListProvider.notifier).refresh(),
        child: _buildBody(context, profileState),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 새 프로필 추가
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProfileListState state) {
    if (state.isLoading && state.profiles.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: 재시도 로직
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (state.profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              '연락처가 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '새로운 연락처를 추가해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    // 중요도 순으로 정렬
    final sortedProfiles = List<ContactProfile>.from(state.profiles)
      ..sort((a, b) => b.priority.compareTo(a.priority));

    return ListView.builder(
      itemCount: sortedProfiles.length,
      itemBuilder: (context, index) {
        final profile = sortedProfiles[index];
        return _ProfileListItem(profile: profile);
      },
    );
  }
}

/// 프로필 목록 아이템
class _ProfileListItem extends StatelessWidget {
  final ContactProfile profile;

  const _ProfileListItem({required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        backgroundImage: profile.photoUrl != null
            ? NetworkImage(profile.photoUrl!)
            : null,
        child: profile.photoUrl == null
            ? Text(
                profile.name.isNotEmpty
                    ? profile.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              profile.name,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (profile.priority >= 4)
            const Icon(
              Icons.star,
              size: 16,
              color: AppColors.warning,
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile.phoneNumber != null)
            Text(
              profile.phoneNumber!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if (profile.tags.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: profile.tags.take(3).map((tag) {
                return Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 10),
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${profile.platforms.length}개 플랫폼',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      onTap: () {
        // TODO: 프로필 상세 페이지로 이동
      },
    );
  }
}


