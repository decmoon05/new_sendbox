import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/usecases/conversation/get_conversations.dart';
import '../../../../../domain/usecases/conversation/save_conversation.dart';
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

  return ChatNotifier(
    getConversations: getConversations,
    saveConversation: saveConversation,
  );
});

/// 대화 목록 Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final GetConversations getConversations;
  final SaveConversation saveConversation;

  ChatNotifier({
    required this.getConversations,
    required this.saveConversation,
  }) : super(const ChatState()) {
    _initialize();
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
}

