import 'package:isar/isar.dart';
import '../../domain/entities/message.dart';
import '../utils/json_helper.dart';

part 'message_model.g.dart';

/// Isar 데이터베이스용 Message 모델
@collection
class MessageModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String messageId;

  @Index()
  late String conversationId;

  late String senderId;
  late String? senderName;
  late String content;
  late String type; // "sent", "received"

  @Index()
  late DateTime timestamp;

  late bool isRead;

  // Attachment는 JSON으로 저장 (향후 별도 테이블로 분리 가능)
  late String? attachmentsJson;

  late String? metadataJson;

  /// 기본 생성자 (Isar 필수)
  MessageModel();

  /// Entity로 변환
  Message toEntity() {
    return Message(
      id: messageId,
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: type == 'sent' ? MessageType.sent : MessageType.received,
      timestamp: timestamp,
      isRead: isRead,
      attachments: attachmentsJson != null
          ? _parseAttachments(attachmentsJson!)
          : null,
      metadata: metadataJson != null ? _parseMetadata(metadataJson!) : {},
    );
  }

  /// Entity에서 생성
  static MessageModel fromEntity(Message message) {
    final model = MessageModel();
    model.messageId = message.id;
    model.conversationId = message.conversationId;
    model.senderId = message.senderId;
    model.senderName = message.senderName;
    model.content = message.content;
    model.type = message.type == MessageType.sent ? 'sent' : 'received';
    model.timestamp = message.timestamp;
    model.isRead = message.isRead;
    model.attachmentsJson = message.attachments != null
        ? _encodeAttachmentsStatic(message.attachments!)
        : null;
    model.metadataJson =
        message.metadata.isNotEmpty ? _encodeMetadataStatic(message.metadata) : null;
    return model;
  }

  // JSON 파싱 헬퍼 (인스턴스 메서드)
  List<Attachment> _parseAttachments(String json) {
    return JsonHelper.decodeAttachments(json);
  }

  Map<String, dynamic> _parseMetadata(String json) {
    return JsonHelper.decodeMetadata(json);
  }

  // JSON 인코딩 헬퍼 (정적 메서드)
  static String _encodeAttachmentsStatic(List<Attachment> attachments) {
    return JsonHelper.encodeAttachments(attachments);
  }

  static String _encodeMetadataStatic(Map<String, dynamic> metadata) {
    return JsonHelper.encodeMetadata(metadata);
  }
}

