import '../../../domain/entities/ai_recommendation.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/contact_profile.dart';

/// AI 서비스 어댑터 인터페이스 (확장성을 위한 어댑터 패턴)
abstract class AIServiceAdapter {
  Future<AIRecommendation> getMessageRecommendation({
    required Conversation conversation,
    required ContactProfile profile,
    required String messageContext,
  });

  Future<void> analyzeProfile(ContactProfile profile);
}

