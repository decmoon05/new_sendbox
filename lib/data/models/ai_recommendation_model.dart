import 'package:isar/isar.dart';
import '../../domain/entities/ai_recommendation.dart';

part 'ai_recommendation_model.g.dart';

/// Isar 데이터베이스용 AIRecommendation 모델
@collection
class AIRecommendationModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String recommendationId;

  @Index()
  late String conversationId;

  late String messageContext;

  // 추천 메시지 옵션들은 JSON으로 저장
  late String recommendationsJson;

  late String type; // "message", "item", "travel"

  @Index()
  late DateTime createdAt;

  late bool isUsed;
  late String? selectedOptionId;

  /// Entity로 변환
  AIRecommendation toEntity() {
    return AIRecommendation(
      id: recommendationId,
      conversationId: conversationId,
      messageContext: messageContext,
      recommendations: _parseRecommendations(recommendationsJson),
      type: _parseType(type),
      createdAt: createdAt,
      isUsed: isUsed,
      selectedOptionId: selectedOptionId,
    );
  }

  /// Entity에서 생성
  factory AIRecommendationModel.fromEntity(AIRecommendation recommendation) {
    return AIRecommendationModel()
      ..recommendationId = recommendation.id
      ..conversationId = recommendation.conversationId
      ..messageContext = recommendation.messageContext
      ..recommendationsJson = _encodeRecommendations(recommendation.recommendations)
      ..type = _encodeType(recommendation.type)
      ..createdAt = recommendation.createdAt
      ..isUsed = recommendation.isUsed
      ..selectedOptionId = recommendation.selectedOptionId;
  }

  List<MessageOption> _parseRecommendations(String json) {
    // TODO: 실제 JSON 파싱 구현
    return [];
  }

  RecommendationType _parseType(String type) {
    switch (type) {
      case 'item':
        return RecommendationType.item;
      case 'travel':
        return RecommendationType.travel;
      default:
        return RecommendationType.message;
    }
  }

  String _encodeRecommendations(List<MessageOption> recommendations) {
    // TODO: 실제 JSON 인코딩 구현
    return '';
  }

  String _encodeType(RecommendationType type) {
    switch (type) {
      case RecommendationType.item:
        return 'item';
      case RecommendationType.travel:
        return 'travel';
      default:
        return 'message';
    }
  }
}

