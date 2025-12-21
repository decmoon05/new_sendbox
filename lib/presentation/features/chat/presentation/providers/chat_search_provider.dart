import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/repositories/conversation_repository.dart';
import '../../../../../core/di/providers.dart';

/// 대화 검색 상태
class ChatSearchState {
  final List<Conversation> results;
  final bool isSearching;
  final String? error;
  final String query;

  const ChatSearchState({
    this.results = const [],
    this.isSearching = false,
    this.error,
    this.query = '',
  });

  ChatSearchState copyWith({
    List<Conversation>? results,
    bool? isSearching,
    String? error,
    String? query,
  }) {
    return ChatSearchState(
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      error: error,
      query: query ?? this.query,
    );
  }
}

/// 대화 검색 Provider
final chatSearchProvider = StateNotifierProvider<ChatSearchNotifier, ChatSearchState>((ref) {
  final repository = ref.watch(conversationRepositoryProvider);
  return ChatSearchNotifier(repository: repository);
});

/// 대화 검색 Notifier
class ChatSearchNotifier extends StateNotifier<ChatSearchState> {
  final ConversationRepository repository;

  ChatSearchNotifier({
    required this.repository,
  }) : super(const ChatSearchState());

  /// 검색 실행
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        results: [],
        query: '',
        isSearching: false,
      );
      return;
    }

    state = state.copyWith(
      isSearching: true,
      query: query.trim(),
      error: null,
    );

    final result = await repository.searchConversations(query.trim());

    result.fold(
      (failure) => state = state.copyWith(
        isSearching: false,
        error: failure.message,
        results: [],
      ),
      (conversations) => state = state.copyWith(
        isSearching: false,
        results: conversations,
        error: null,
      ),
    );
  }

  /// 검색 초기화
  void clear() {
    state = const ChatSearchState();
  }
}

