import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/ai_recommendation.dart';
import '../../entities/conversation.dart';
import '../../entities/contact_profile.dart';
import '../../repositories/ai_repository.dart';

/// 메시지 추천 가져오기 UseCase
class GetMessageRecommendation {
  final AIRepository repository;

  GetMessageRecommendation(this.repository);

  Future<Either<Failure, AIRecommendation>> call({
    required Conversation conversation,
    required ContactProfile profile,
    required String messageContext,
  }) async {
    return await repository.getMessageRecommendation(
      conversation: conversation,
      profile: profile,
      messageContext: messageContext,
    );
  }
}

