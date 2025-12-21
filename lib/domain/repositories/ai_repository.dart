import 'package:dartz/dartz.dart';
import '../entities/ai_recommendation.dart';
import '../entities/conversation.dart';
import '../entities/contact_profile.dart';
import '../../core/errors/failures.dart';

/// AI 리포지토리 인터페이스
abstract class AIRepository {
  /// 메시지 추천 가져오기
  Future<Either<Failure, AIRecommendation>> getMessageRecommendation({
    required Conversation conversation,
    required ContactProfile profile,
    required String messageContext,
  });

  /// 프로필 분석
  Future<Either<Failure, void>> analyzeProfile(ContactProfile profile);

  /// 아이템 추천 (대화 컨텍스트 기반)
  Future<Either<Failure, AIRecommendation>> getItemRecommendation({
    required Conversation conversation,
    required ContactProfile profile,
  });
}

