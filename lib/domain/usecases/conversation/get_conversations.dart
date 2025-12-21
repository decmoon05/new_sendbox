import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/conversation.dart';
import '../../repositories/conversation_repository.dart';

/// 모든 대화 가져오기 UseCase
class GetConversations {
  final ConversationRepository repository;

  GetConversations(this.repository);

  Future<Either<Failure, List<Conversation>>> call() async {
    return await repository.getConversations();
  }
}

