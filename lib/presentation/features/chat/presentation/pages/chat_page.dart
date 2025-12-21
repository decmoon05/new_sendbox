import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_search_provider.dart';
import '../providers/chat_filter_provider.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/extensions/datetime_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../routes/route_names.dart';

/// 채팅 목록 페이지
class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final searchState = ref.watch(chatSearchProvider);
    final filterState = ref.watch(chatFilterProvider);
    
    // 필터링된 대화 목록
    final filteredConversations = ref.watch(filteredConversationsProvider(chatState.conversations));

    return Scaffold(
      appBar: AppBar(
        title: searchState.query.isEmpty
            ? const Text('SendBox')
            : TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: '검색...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(chatSearchProvider.notifier).search(value);
                },
              ),
        actions: [
          if (searchState.query.isEmpty) ...[
            if (filterState.hasActiveFilters)
              IconButton(
                icon: const Icon(Icons.filter_alt),
                color: AppColors.primary,
                onPressed: () => _showFilterBottomSheet(context, ref),
              ),
            IconButton(
              icon: Icon(filterState.hasActiveFilters ? Icons.filter_alt : Icons.filter_list),
              onPressed: () => _showFilterBottomSheet(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ref.read(chatSearchProvider.notifier).search('');
              },
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                ref.read(chatSearchProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(chatProvider.notifier).refresh(),
        child: searchState.query.isNotEmpty
            ? _buildSearchResults(context, searchState)
            : _buildBody(context, chatState.copyWith(conversations: filteredConversations)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 새 대화 시작
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    if (state.isLoading && state.conversations.isEmpty) {
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

    if (state.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              '대화가 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '새로운 대화를 시작해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.conversations.length,
      itemBuilder: (context, index) {
        final conversation = state.conversations[index];
        return _ConversationListItem(conversation: conversation);
      },
    );
  }
}

/// 대화 목록 아이템
class _ConversationListItem extends StatelessWidget {
  final Conversation conversation;

  const _ConversationListItem({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.lastMessage;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Text(
          conversation.contactId[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation.contactId,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (conversation.isPinned)
            const Icon(
              Icons.push_pin,
              size: 16,
              color: AppColors.primary,
            ),
        ],
      ),
      subtitle: Text(
        lastMessage?.content ?? '메시지 없음',
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            conversation.lastMessageAt.formattedTime,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (conversation.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                conversation.unreadCount > 99
                    ? '99+'
                    : conversation.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteNames.chatDetail,
          arguments: conversation.id,
        );
      },
    );
  }

  Widget _buildSearchResults(BuildContext context, ChatSearchState searchState) {
    if (searchState.isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (searchState.error != null) {
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
              searchState.error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (searchState.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '"${searchState.query}"에 대한 결과를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: searchState.results.length,
      itemBuilder: (context, index) {
        final conversation = searchState.results[index];
        return _ConversationListItem(conversation: conversation);
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    final filterState = ref.read(chatFilterProvider);
    final filterNotifier = ref.read(chatFilterProvider.notifier);

    // 사용 가능한 플랫폼 목록 가져오기
    final conversations = ref.read(chatProvider).conversations;
    final platforms = conversations.map((c) => c.platform).toSet().toList()..sort();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String? selectedPlatform = filterState.platform;
            bool? unreadOnly = filterState.unreadOnly;
            bool pinnedOnly = filterState.pinnedOnly;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '필터',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          filterNotifier.clearFilters();
                          Navigator.pop(context);
                        },
                        child: const Text('초기화'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 플랫폼 필터
                  const Text(
                    '플랫폼',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('전체'),
                        selected: selectedPlatform == null,
                        onSelected: (selected) {
                          setState(() {
                            selectedPlatform = selected ? null : selectedPlatform;
                          });
                        },
                      ),
                      ...platforms.map((platform) {
                        return ChoiceChip(
                          label: Text(_getPlatformName(platform)),
                          selected: selectedPlatform == platform,
                          onSelected: (selected) {
                            setState(() {
                              selectedPlatform = selected ? platform : null;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 읽지 않은 메시지 필터
                  const Text(
                    '읽음 상태',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('전체'),
                        selected: unreadOnly == null,
                        onSelected: (selected) {
                          setState(() {
                            unreadOnly = selected ? null : unreadOnly;
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('읽지 않음'),
                        selected: unreadOnly == true,
                        onSelected: (selected) {
                          setState(() {
                            unreadOnly = selected ? true : null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // 고정된 대화 필터
                  CheckboxListTile(
                    title: const Text('고정된 대화만'),
                    value: pinnedOnly,
                    onChanged: (value) {
                      setState(() {
                        pinnedOnly = value ?? false;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // 적용 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        filterNotifier.setPlatform(selectedPlatform);
                        filterNotifier.setUnreadOnly(unreadOnly);
                        filterNotifier.setPinnedOnly(pinnedOnly);
                        Navigator.pop(context);
                      },
                      child: const Text('적용'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
