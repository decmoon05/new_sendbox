import 'package:dartz/dartz.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/contact_profile.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/error_handler.dart';
import '../services/ai/gemini_service.dart';

/// AI 리포지토리 구현
class AIRepositoryImpl implements AIRepository {
  final GeminiService geminiService;

  AIRepositoryImpl({
    required this.geminiService,
  });

  @override
  Future<Either<Failure, AIRecommendation>> getMessageRecommendation({
    required Conversation conversation,
    required ContactProfile profile,
    required String messageContext,
  }) async {
    try {
      final recommendation = await geminiService.getMessageRecommendation(
        conversation: conversation,
        profile: profile,
        messageContext: messageContext,
      );

      return Right(recommendation);
    } on ServerException catch (e) {
      return Left(ErrorHandler.handleException(e));
    } catch (e) {
      return Left(ServerFailure('메시지 추천을 가져오는데 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> analyzeProfile(ContactProfile profile) async {
    try {
      // TODO: 프로필 분석 로직 구현
      // 현재는 Gemini API를 통해 프로필 분석 기능 구현 예정
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('프로필 분석에 실패했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AIRecommendation>> getItemRecommendation({
    required Conversation conversation,
    required ContactProfile profile,
  }) async {
    try {
      // TODO: 아이템 추천 로직 구현
      // 현재는 기본 구조만 제공
      return Left(ServerFailure('아이템 추천 기능은 아직 구현되지 않았습니다.'));
    } catch (e) {
      return Left(ServerFailure('아이템 추천에 실패했습니다: ${e.toString()}'));
    }
  }
}

