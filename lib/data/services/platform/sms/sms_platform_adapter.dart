import '../../../../domain/entities/message.dart';
import '../../../../domain/entities/conversation.dart';
import 'sms_service.dart';

/// SMS 플랫폼 어댑터
/// SMS 메시지를 앱의 표준 메시지 형식으로 변환
class SmsPlatformAdapter {
  final SmsService smsService;

  SmsPlatformAdapter({
    required this.smsService,
  });

  /// SMS 메시지를 Conversation 엔티티로 변환
  Future<Conversation?> convertSmsToConversation({
    required String phoneNumber,
    required String contactName,
    required List<Map<String, dynamic>> messages,
  }) async {
    try {
      if (messages.isEmpty) return null;

      final convertedMessages = messages.map((smsData) {
        return Message(
          id: smsData['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
          conversationId: phoneNumber,
          senderId: smsData['sender'] as String? ?? phoneNumber,
          senderName: smsData['sender'] == phoneNumber ? contactName : smsData['sender'],
          content: smsData['content'] as String? ?? '',
          type: smsData['type'] == 'sent' ? MessageType.sent : MessageType.received,
          timestamp: smsData['timestamp'] as DateTime? ?? DateTime.now(),
          isRead: smsData['isRead'] as bool? ?? false,
          metadata: {
            'platform': 'sms',
            'threadId': smsData['threadId'],
          },
        );
      }).toList();

      // 최신 메시지 시간으로 정렬
      convertedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      final lastMessage = convertedMessages.last;
      final unreadCount = convertedMessages.where((m) => !m.isRead && m.type == MessageType.received).length;

      return Conversation(
        id: phoneNumber,
        contactId: contactName,
        platform: 'sms',
        messages: convertedMessages,
        lastMessageAt: lastMessage.timestamp,
        unreadCount: unreadCount,
        isPinned: false,
        metadata: {
          'platform': 'sms',
          'phoneNumber': phoneNumber,
        },
      );
    } catch (e) {
      return null;
    }
  }

  /// 앱의 메시지를 SMS로 전송
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      return await smsService.sendSms(
        phoneNumber: phoneNumber,
        message: message,
      );
    } catch (e) {
      return false;
    }
  }
}

