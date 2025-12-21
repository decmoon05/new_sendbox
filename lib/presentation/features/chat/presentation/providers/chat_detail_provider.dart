import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/entities/message.dart';
import '../../../../../domain/repositories/conversation_repository.dart';
import '../../../../../domain/usecases/conversation/mark_messages_as_read.dart';
import '../../../../../core/di/providers.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../data/services/platform/sms/sms_service.dart';
import 'chat_provider.dart';

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
  final chatNotifier = ref.watch(chatProvider.notifier);
  final smsService = ref.watch(smsServiceProvider);

  return ChatDetailNotifier(
    repository: repository,
    conversationId: conversationId,
    chatNotifier: chatNotifier,
    smsService: smsService,
  );
});

/// 대화 상세 Notifier
class ChatDetailNotifier extends StateNotifier<ChatDetailState> {
  final ConversationRepository repository;
  final String conversationId;
  final ChatNotifier? chatNotifier;
  final SmsService? smsService;

  ChatDetailNotifier({
    required this.repository,
    required this.conversationId,
    this.chatNotifier,
    this.smsService,
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

    // SMS 플랫폼인 경우 실제 SMS 전송
    if (currentConversation.platform == 'sms' && smsService != null) {
      // 전화번호 추출 (metadata 또는 contactId에서)
      final phoneNumber = currentConversation.metadata['phoneNumber'] as String? ?? 
                         currentConversation.contactId;
      
      try {
        final success = await smsService!.sendSms(
          phoneNumber: phoneNumber,
          message: content,
        );
        
        if (!success) {
          state = state.copyWith(error: 'SMS 전송에 실패했습니다.');
          return;
        }
      } catch (e) {
        state = state.copyWith(error: 'SMS 전송 중 오류가 발생했습니다: $e');
        return;
      }
    }

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
        
        // 대화 목록도 새로고침 (목록의 lastMessageAt 업데이트를 위해)
        chatNotifier?.refresh();
      },
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadConversation();
  }
}

