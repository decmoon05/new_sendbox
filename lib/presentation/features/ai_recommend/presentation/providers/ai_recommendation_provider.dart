import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/ai_recommendation.dart';
import '../../../../../domain/entities/conversation.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../../../../../domain/usecases/ai/get_message_recommendation.dart';
import '../../../../../core/di/providers.dart';

/// AI 추천 상태
class AIRecommendationState {
  final AIRecommendation? recommendation;
  final bool isLoading;
  final String? error;

  const AIRecommendationState({
    this.recommendation,
    this.isLoading = false,
    this.error,
  });

  AIRecommendationState copyWith({
    AIRecommendation? recommendation,
    bool? isLoading,
    String? error,
  }) {
    return AIRecommendationState(
      recommendation: recommendation ?? this.recommendation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// AI 추천 Provider
final aiRecommendationProvider = StateNotifierProvider.family<
    AIRecommendationNotifier,
    AIRecommendationState,
    AIRecommendationParams>((ref, params) {
  final repository = ref.watch(aiRepositoryProvider);
  final getMessageRecommendation = GetMessageRecommendation(repository);

  return AIRecommendationNotifier(
    getMessageRecommendation: getMessageRecommendation,
    params: params,
  );
});

/// AI 추천 파라미터
class AIRecommendationParams {
  final Conversation conversation;
  final ContactProfile profile;
  final String messageContext;

  const AIRecommendationParams({
    required this.conversation,
    required this.profile,
    required this.messageContext,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIRecommendationParams &&
          runtimeType == other.runtimeType &&
          conversation.id == other.conversation.id &&
          profile.id == other.profile.id &&
          messageContext == other.messageContext;

  @override
  int get hashCode =>
      conversation.id.hashCode ^
      profile.id.hashCode ^
      messageContext.hashCode;
}

/// AI 추천 Notifier
class AIRecommendationNotifier extends StateNotifier<AIRecommendationState> {
  final GetMessageRecommendation getMessageRecommendation;
  final AIRecommendationParams params;

  AIRecommendationNotifier({
    required this.getMessageRecommendation,
    required this.params,
  }) : super(const AIRecommendationState()) {
    loadRecommendation();
  }

  /// 추천 로드
  Future<void> loadRecommendation() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getMessageRecommendation(
      conversation: params.conversation,
      profile: params.profile,
      messageContext: params.messageContext,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (recommendation) => state = state.copyWith(
        isLoading: false,
        recommendation: recommendation,
      ),
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadRecommendation();
  }
}

