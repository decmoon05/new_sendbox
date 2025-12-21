import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/conversation.dart';
import '../../repositories/conversation_repository.dart';

/// 대화 저장 UseCase
class SaveConversation {
  final ConversationRepository repository;

  SaveConversation(this.repository);

  Future<Either<Failure, void>> call(Conversation conversation) async {
    return await repository.saveConversation(conversation);
  }
}

