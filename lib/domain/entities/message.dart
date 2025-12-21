import 'package:equatable/equatable.dart';

/// 메시지 타입
enum MessageType {
  sent,
  received,
}

/// 메시지 엔티티
class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final List<Attachment>? attachments;
  final Map<String, dynamic> metadata;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.attachments,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        senderName,
        content,
        type,
        timestamp,
        isRead,
        attachments,
        metadata,
      ];
}

/// 첨부 파일
class Attachment extends Equatable {
  final String id;
  final String type; // image, video, audio, file
  final String url;
  final String? thumbnailUrl;
  final int? size; // bytes
  final String? mimeType;

  const Attachment({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.size,
    this.mimeType,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        url,
        thumbnailUrl,
        size,
        mimeType,
      ];
}

