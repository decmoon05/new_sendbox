import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/entities/message.dart';
import '../../../../../domain/repositories/conversation_repository.dart';
import '../../../../../core/di/providers.dart';
import '../../../../../core/errors/failures.dart';

/// 대화 상세 상태
class ChatDetailState {
  final Conversation? conversation;
  final bool isLoading;
  final String? error;

  const ChatDetailState({
    this.conversation,
    this.isLoading = false,
    this.error,
  });

  ChatDetailState copyWith({
    Conversation? conversation,
    bool? isLoading,
    String? error,
  }) {
    return ChatDetailState(
      conversation: conversation ?? this.conversation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 대화 상세 Provider
final chatDetailProvider = StateNotifierProvider.family<
    ChatDetailNotifier,
    ChatDetailState,
    String>((ref, conversationId) {
  final repository = ref.watch(conversationRepositoryProvider);

  return ChatDetailNotifier(
    repository: repository,
    conversationId: conversationId,
  );
});

/// 대화 상세 Notifier
class ChatDetailNotifier extends StateNotifier<ChatDetailState> {
  final ConversationRepository repository;
  final String conversationId;

  ChatDetailNotifier({
    required this.repository,
    required this.conversationId,
  }) : super(const ChatDetailState()) {
    loadConversation();
  }

  /// 대화 로드
  Future<void> loadConversation() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getConversation(conversationId);

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (conversation) => state = state.copyWith(
        isLoading: false,
        conversation: conversation,
      ),
    );
  }

  /// 메시지 전송
  Future<void> sendMessage(String content) async {
    final currentConversation = state.conversation;
    if (currentConversation == null) return;

    // 새 메시지 생성
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: 'current_user', // TODO: 실제 사용자 ID로 교체
      content: content,
      type: MessageType.sent,
      timestamp: DateTime.now(),
      isRead: true,
    );

    // 대화에 메시지 추가
    final updatedConversation = Conversation(
      id: currentConversation.id,
      contactId: currentConversation.contactId,
      platform: currentConversation.platform,
      messages: [...currentConversation.messages, newMessage],
      lastMessageAt: DateTime.now(),
      unreadCount: currentConversation.unreadCount,
      isPinned: currentConversation.isPinned,
      metadata: currentConversation.metadata,
    );

    // 저장
    final result = await repository.saveConversation(updatedConversation);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {
        // 저장 성공 시 상태 업데이트
        state = state.copyWith(conversation: updatedConversation);
      },
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadConversation();
  }
}

