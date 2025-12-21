import 'package:isar/isar.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../utils/json_helper.dart';

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

  /// 기본 생성자 (Isar 필수)
  AIRecommendationModel();

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
  static AIRecommendationModel fromEntity(AIRecommendation recommendation) {
    final model = AIRecommendationModel();
    model.recommendationId = recommendation.id;
    model.conversationId = recommendation.conversationId;
    model.messageContext = recommendation.messageContext;
    model.recommendationsJson = _encodeRecommendationsStatic(recommendation.recommendations);
    model.type = _encodeTypeStatic(recommendation.type);
    model.createdAt = recommendation.createdAt;
    model.isUsed = recommendation.isUsed;
    model.selectedOptionId = recommendation.selectedOptionId;
    return model;
  }

  List<MessageOption> _parseRecommendations(String json) {
    return JsonHelper.decodeMessageOptions(json);
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

  static String _encodeRecommendationsStatic(List<MessageOption> recommendations) {
    return JsonHelper.encodeMessageOptions(recommendations);
  }

  static String _encodeTypeStatic(RecommendationType type) {
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

