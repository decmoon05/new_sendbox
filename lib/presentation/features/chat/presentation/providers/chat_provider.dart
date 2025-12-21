import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/repositories/conversation_repository.dart';
import '../../../../../domain/usecases/conversation/get_conversations.dart';
import '../../../../../domain/usecases/conversation/save_conversation.dart';
import '../../../../../domain/usecases/conversation/toggle_pin_conversation.dart';
import '../../../../../domain/usecases/conversation/mark_messages_as_read.dart';
import '../../../../../core/di/providers.dart';
import '../../../../../core/utils/data_seeder.dart';

/// 대화 목록 상태
class ChatState {
  final List<Conversation> conversations;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.conversations = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Conversation>? conversations,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 대화 목록 Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repository = ref.watch(conversationRepositoryProvider);
  final getConversations = GetConversations(repository);
  final saveConversation = SaveConversation(repository);
  final togglePinConversation = TogglePinConversation(repository);
  final markMessagesAsRead = MarkMessagesAsRead(repository);

  return ChatNotifier(
    repository: repository,
    getConversations: getConversations,
    saveConversation: saveConversation,
    togglePinConversation: togglePinConversation,
    markMessagesAsRead: markMessagesAsRead,
  );
});

/// 대화 목록 Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final ConversationRepository repository;
  final GetConversations getConversations;
  final SaveConversation saveConversation;
  final TogglePinConversation togglePinConversation;
  final MarkMessagesAsRead markMessagesAsRead;

  ChatNotifier({
    required this.repository,
    required this.getConversations,
    required this.saveConversation,
    required this.togglePinConversation,
    required this.markMessagesAsRead,
  }) : super(const ChatState()) {
    loadConversations();
  }


  /// 대화 목록 로드
  Future<void> loadConversations() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getConversations();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (conversations) => state = state.copyWith(
        isLoading: false,
        conversations: conversations,
      ),
    );
  }

  /// 대화 저장
  Future<void> save(Conversation conversation) async {
    final result = await saveConversation(conversation);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) {
        // 저장 성공 시 목록 새로고침
        loadConversations();
      },
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadConversations();
  }

  /// 대화 고정/고정 해제
  Future<void> togglePin(String conversationId, bool isPinned) async {
    final result = await togglePinConversation(conversationId, isPinned);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadConversations(),
    );
  }

  /// 메시지를 읽음으로 표시
  Future<void> markAsRead(String conversationId) async {
    final result = await markMessagesAsRead(conversationId);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadConversations(),
    );
  }

  /// 대화 삭제
  Future<void> deleteConversation(String conversationId) async {
    final repository = getConversations.repository;
    // TODO: DeleteConversation UseCase 추가 후 사용
    // 현재는 Repository의 deleteConversation을 직접 사용
    final result = await repository.deleteConversation(conversationId);
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (_) => loadConversations(),
    );
  }
}

