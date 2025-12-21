import 'package:isar/isar.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import 'message_model.dart';

part 'conversation_model.g.dart';

/// Isar 데이터베이스용 Conversation 모델
@collection
class ConversationModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String conversationId;

  @Index()
  late String contactId;

  late String platform;
  late DateTime lastMessageAt;
  late int unreadCount;
  late bool isPinned;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;

  // Messages는 별도 컬렉션으로 관리 (IsarLinks 대신 수동 참조)
  // 실제로는 messageId 리스트를 저장하고 쿼리로 가져옴

  /// Entity로 변환
  Conversation toEntity(List<MessageModel> messageModels) {
    return Conversation(
      id: conversationId,
      contactId: contactId,
      platform: platform,
      messages: messageModels
          .map((m) => m.toEntity())
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)),
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      isPinned: isPinned,
      metadata: {},
    );
  }

  /// Entity에서 생성
  factory ConversationModel.fromEntity(Conversation conversation) {
    return ConversationModel()
      ..conversationId = conversation.id
      ..contactId = conversation.contactId
      ..platform = conversation.platform
      ..lastMessageAt = conversation.lastMessageAt
      ..unreadCount = conversation.unreadCount
      ..isPinned = conversation.isPinned
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
  }
}

