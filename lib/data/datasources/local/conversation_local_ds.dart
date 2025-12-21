import 'package:isar/isar.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import '../../../domain/entities/conversation.dart';
import '../../../core/errors/exceptions.dart';

/// 로컬 대화 데이터소스
abstract class ConversationLocalDataSource {
  Future<List<Conversation>> getConversations();
  Future<Conversation?> getConversation(String id);
  Future<void> saveConversation(Conversation conversation);
  Future<void> deleteConversation(String id);
}

/// Isar를 사용한 대화 로컬 데이터소스 구현
class ConversationLocalDataSourceImpl implements ConversationLocalDataSource {
  final Isar isar;

  ConversationLocalDataSourceImpl(this.isar);

  @override
  Future<List<Conversation>> getConversations() async {
    try {
      final conversationModels = await isar.conversationModels
          .where()
          .sortByLastMessageAtDesc()
          .findAll();

      final conversations = <Conversation>[];

      for (final convModel in conversationModels) {
        final messages = await isar.messageModels
            .filter()
            .conversationIdEqualTo(convModel.conversationId)
            .sortByTimestamp()
            .findAll();

        conversations.add(convModel.toEntity(messages));
      }

      return conversations;
    } catch (e) {
      throw CacheException(
        message: '대화 목록을 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<Conversation?> getConversation(String id) async {
    try {
      final conversationModel = await isar.conversationModels
          .filter()
          .conversationIdEqualTo(id)
          .findFirst();

      if (conversationModel == null) return null;

      final messages = await isar.messageModels
          .filter()
          .conversationIdEqualTo(id)
          .sortByTimestamp()
          .findAll();

      return conversationModel.toEntity(messages);
    } catch (e) {
      throw CacheException(
        message: '대화를 가져오는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveConversation(Conversation conversation) async {
    try {
      await isar.writeTxn(() async {
        // 기존 대화가 있는지 확인
        final existing = await isar.conversationModels
            .filter()
            .conversationIdEqualTo(conversation.id)
            .findFirst();

        final conversationModel = ConversationModel.fromEntity(conversation);
        if (existing != null) {
          conversationModel.id = existing.id;
          conversationModel.createdAt = existing.createdAt;
        }

        await isar.conversationModels.put(conversationModel);

        // 메시지들도 저장
        for (final message in conversation.messages) {
          final messageModel = MessageModel.fromEntity(message);
          final existingMessage = await isar.messageModels
              .filter()
              .messageIdEqualTo(message.id)
              .findFirst();

          if (existingMessage != null) {
            messageModel.id = existingMessage.id;
          }

          await isar.messageModels.put(messageModel);
        }
      });
    } catch (e) {
      throw CacheException(
        message: '대화를 저장하는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteConversation(String id) async {
    try {
      await isar.writeTxn(() async {
        // 대화 삭제
        await isar.conversationModels
            .filter()
            .conversationIdEqualTo(id)
            .deleteFirst();

        // 관련 메시지 삭제
        await isar.messageModels
            .filter()
            .conversationIdEqualTo(id)
            .deleteAll();
      });
    } catch (e) {
      throw CacheException(
        message: '대화를 삭제하는데 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

