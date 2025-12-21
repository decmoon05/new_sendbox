import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/conversation.dart';
import '../../repositories/conversation_repository.dart';

/// 대화 고정 토글 UseCase
class TogglePinConversation {
  final ConversationRepository repository;

  TogglePinConversation(this.repository);

  Future<Either<Failure, void>> call(String conversationId, bool isPinned) async {
    final result = await repository.getConversation(conversationId);
    
    return result.fold(
      (failure) => Left(failure),
      (conversation) async {
        // 고정 상태 변경된 대화 생성
        final updatedConversation = Conversation(
          id: conversation.id,
          contactId: conversation.contactId,
          platform: conversation.platform,
          messages: conversation.messages,
          lastMessageAt: conversation.lastMessageAt,
          unreadCount: conversation.unreadCount,
          isPinned: isPinned,
          metadata: conversation.metadata,
        );
        
        return await repository.saveConversation(updatedConversation);
      },
    );
  }
}

