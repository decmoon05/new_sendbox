import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';

/// 정렬 기준
enum ConversationSortBy {
  recent, // 최신순 (기본값)
  name, // 이름순
  unread, // 읽지 않은 메시지 우선
}

/// 대화 정렬 상태
class ChatSortState {
  final ConversationSortBy sortBy;

  const ChatSortState({
    this.sortBy = ConversationSortBy.recent,
  });

  ChatSortState copyWith({
    ConversationSortBy? sortBy,
  }) {
    return ChatSortState(
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// 대화 정렬 Provider
final chatSortProvider = StateNotifierProvider<ChatSortNotifier, ChatSortState>((ref) {
  return ChatSortNotifier();
});

/// 대화 정렬 Notifier
class ChatSortNotifier extends StateNotifier<ChatSortState> {
  ChatSortNotifier() : super(const ChatSortState());

  /// 정렬 기준 변경
  void setSortBy(ConversationSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }
}

/// 정렬된 대화 목록을 반환하는 Provider
final sortedConversationsProvider = Provider.family<List<Conversation>, List<Conversation>>((ref, conversations) {
  final sortState = ref.watch(chatSortProvider);
  
  // 고정된 대화를 먼저 분리
  final pinnedConversations = conversations.where((c) => c.isPinned).toList();
  final unpinnedConversations = conversations.where((c) => !c.isPinned).toList();
  
  // 정렬 함수
  int compareConversations(Conversation a, Conversation b) {
    switch (sortState.sortBy) {
      case ConversationSortBy.recent:
        // 최신순: 마지막 메시지 시간 기준 내림차순
        return b.lastMessageAt.compareTo(a.lastMessageAt);
      
      case ConversationSortBy.name:
        // 이름순: 연락처 이름 기준 오름차순
        return a.contactId.compareTo(b.contactId);
      
      case ConversationSortBy.unread:
        // 읽지 않은 메시지 우선: 읽지 않은 개수 기준 내림차순
        if (a.unreadCount != b.unreadCount) {
          return b.unreadCount.compareTo(a.unreadCount);
        }
        // 읽지 않은 개수가 같으면 최신순
        return b.lastMessageAt.compareTo(a.lastMessageAt);
    }
  }
  
  // 각 그룹을 정렬
  pinnedConversations.sort(compareConversations);
  unpinnedConversations.sort(compareConversations);
  
  // 고정된 대화를 앞에, 나머지를 뒤에 배치
  return [...pinnedConversations, ...unpinnedConversations];
});

