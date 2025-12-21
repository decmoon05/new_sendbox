import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';

/// 대화 필터 상태
class ChatFilterState {
  final String? platform; // null이면 모든 플랫폼
  final bool? unreadOnly; // null이면 모두, true면 읽지 않은 것만
  final bool pinnedOnly;

  const ChatFilterState({
    this.platform,
    this.unreadOnly,
    this.pinnedOnly = false,
  });

  ChatFilterState copyWith({
    String? platform,
    bool? unreadOnly,
    bool? pinnedOnly,
  }) {
    return ChatFilterState(
      platform: platform ?? this.platform,
      unreadOnly: unreadOnly ?? this.unreadOnly,
      pinnedOnly: pinnedOnly ?? this.pinnedOnly,
    );
  }

  /// 필터가 적용되어 있는지 확인
  bool get hasActiveFilters {
    return platform != null || unreadOnly == true || pinnedOnly;
  }

  /// 필터 초기화
  ChatFilterState clear() {
    return const ChatFilterState();
  }
}

/// 대화 필터 Provider
final chatFilterProvider = StateNotifierProvider<ChatFilterNotifier, ChatFilterState>((ref) {
  return ChatFilterNotifier();
});

/// 대화 필터 Notifier
class ChatFilterNotifier extends StateNotifier<ChatFilterState> {
  ChatFilterNotifier() : super(const ChatFilterState());

  /// 플랫폼 필터 설정
  void setPlatform(String? platform) {
    state = state.copyWith(platform: platform);
  }

  /// 읽지 않은 메시지 필터 설정
  void setUnreadOnly(bool? unreadOnly) {
    state = state.copyWith(unreadOnly: unreadOnly);
  }

  /// 고정된 대화 필터 설정
  void setPinnedOnly(bool pinnedOnly) {
    state = state.copyWith(pinnedOnly: pinnedOnly);
  }

  /// 필터 초기화
  void clearFilters() {
    state = state.clear();
  }
}

/// 필터링된 대화 목록을 반환하는 Provider
final filteredConversationsProvider = Provider.family<List<Conversation>, List<Conversation>>((ref, conversations) {
  final filterState = ref.watch(chatFilterProvider);

  return conversations.where((conversation) {
    // 플랫폼 필터
    if (filterState.platform != null && conversation.platform != filterState.platform) {
      return false;
    }

    // 읽지 않은 메시지 필터
    if (filterState.unreadOnly == true && conversation.unreadCount == 0) {
      return false;
    }

    // 고정된 대화 필터
    if (filterState.pinnedOnly && !conversation.isPinned) {
      return false;
    }

    return true;
  }).toList();
});

