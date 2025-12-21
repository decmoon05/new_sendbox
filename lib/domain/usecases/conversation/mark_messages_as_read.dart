import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/conversation.dart';
import '../../entities/message.dart';
import '../../repositories/conversation_repository.dart';

/// 메시지를 읽음으로 표시하는 UseCase
class MarkMessagesAsRead {
  final ConversationRepository repository;

  MarkMessagesAsRead(this.repository);

  Future<Either<Failure, void>> call(String conversationId) async {
    final result = await repository.getConversation(conversationId);
    
    return result.fold(
      (failure) => Left(failure),
      (conversation) async {
        // 모든 읽지 않은 메시지를 읽음으로 표시
        final updatedMessages = conversation.messages.map((message) {
          if (message.type == MessageType.received && !message.isRead) {
            return Message(
              id: message.id,
              conversationId: message.conversationId,
              senderId: message.senderId,
              senderName: message.senderName,
              content: message.content,
              type: message.type,
              timestamp: message.timestamp,
              isRead: true, // 읽음으로 표시
              attachments: message.attachments,
              metadata: message.metadata,
            );
          }
          return message;
        }).toList();
        
        // 읽지 않은 메시지 개수 계산 (0이 됨)
        final unreadCount = updatedMessages
            .where((m) => !m.isRead && m.type == MessageType.received)
            .length;
        
        // 업데이트된 대화 생성
        final updatedConversation = Conversation(
          id: conversation.id,
          contactId: conversation.contactId,
          platform: conversation.platform,
          messages: updatedMessages,
          lastMessageAt: conversation.lastMessageAt,
          unreadCount: unreadCount,
          isPinned: conversation.isPinned,
          metadata: conversation.metadata,
        );
        
        return await repository.saveConversation(updatedConversation);
      },
    );
  }
}

