import 'package:isar/isar.dart';
import '../../domain/entities/message.dart';

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
  factory MessageModel.fromEntity(Message message) {
    return MessageModel()
      ..messageId = message.id
      ..conversationId = message.conversationId
      ..senderId = message.senderId
      ..senderName = message.senderName
      ..content = message.content
      ..type = message.type == MessageType.sent ? 'sent' : 'received'
      ..timestamp = message.timestamp
      ..isRead = message.isRead
      ..attachmentsJson = message.attachments != null
          ? _encodeAttachments(message.attachments!)
          : null
      ..metadataJson =
          message.metadata.isNotEmpty ? _encodeMetadata(message.metadata) : null;
  }

  // JSON 파싱 헬퍼 (향후 실제 JSON 직렬화 라이브러리 사용 가능)
  List<Attachment> _parseAttachments(String json) {
    // TODO: 실제 JSON 파싱 구현
    return [];
  }

  Map<String, dynamic> _parseMetadata(String json) {
    // TODO: 실제 JSON 파싱 구현
    return {};
  }

  String _encodeAttachments(List<Attachment> attachments) {
    // TODO: 실제 JSON 인코딩 구현
    return '';
  }

  String _encodeMetadata(Map<String, dynamic> metadata) {
    // TODO: 실제 JSON 인코딩 구현
    return '';
  }
}

