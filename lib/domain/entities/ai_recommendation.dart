import 'package:equatable/equatable.dart';

/// AI 추천 타입
enum RecommendationType {
  message, // 메시지 추천
  item, // 물건 추천
  travel, // 여행지 추천
}

/// AI 추천 엔티티
class AIRecommendation extends Equatable {
  final String id;
  final String conversationId;
  final String messageContext;
  final List<MessageOption> recommendations;
  final RecommendationType type;
  final DateTime createdAt;
  final bool isUsed;
  final String? selectedOptionId;

  const AIRecommendation({
    required this.id,
    required this.conversationId,
    required this.messageContext,
    required this.recommendations,
    required this.type,
    required this.createdAt,
    this.isUsed = false,
    this.selectedOptionId,
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        messageContext,
        recommendations,
        type,
        createdAt,
        isUsed,
        selectedOptionId,
      ];
}

/// 메시지 옵션
class MessageOption extends Equatable {
  final String id;
  final String message;
  final String tone; // formal, casual, friendly
  final String reason;
  final int confidence; // 0-100

  const MessageOption({
    required this.id,
    required this.message,
    required this.tone,
    required this.reason,
    this.confidence = 0,
  });

  @override
  List<Object?> get props => [
        id,
        message,
        tone,
        reason,
        confidence,
      ];
}

