import 'package:equatable/equatable.dart';
import 'message.dart';

/// 대화 엔티티
class Conversation extends Equatable {
  final String id;
  final String contactId;
  final String platform; // sms, kakao, discord, etc.
  final List<Message> messages;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isPinned;
  final Map<String, dynamic> metadata;

  const Conversation({
    required this.id,
    required this.contactId,
    required this.platform,
    required this.messages,
    required this.lastMessageAt,
    this.unreadCount = 0,
    this.isPinned = false,
    this.metadata = const {},
  });

  /// 마지막 메시지 가져오기
  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// Conversation 객체를 복사하고 특정 필드를 변경하는 헬퍼 메서드
  Conversation copyWith({
    String? id,
    String? contactId,
    String? platform,
    List<Message>? messages,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isPinned,
    Map<String, dynamic>? metadata,
  }) {
    return Conversation(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      platform: platform ?? this.platform,
      messages: messages ?? this.messages,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        contactId,
        platform,
        messages,
        lastMessageAt,
        unreadCount,
        isPinned,
        metadata,
      ];
}

