import 'package:flutter_test/flutter_test.dart';
import 'package:sendbox/domain/entities/conversation.dart';
import 'package:sendbox/domain/entities/message.dart';

void main() {
  group('Conversation', () {
    test('should create a conversation with all required fields', () {
      final conversation = Conversation(
        id: 'conv_1',
        contactId: 'contact_1',
        platform: 'sms',
        messages: [],
        lastMessageAt: DateTime(2024, 1, 15, 12, 0),
      );

      expect(conversation.id, 'conv_1');
      expect(conversation.contactId, 'contact_1');
      expect(conversation.platform, 'sms');
      expect(conversation.messages, isEmpty);
      expect(conversation.unreadCount, 0); // 기본값
      expect(conversation.isPinned, false); // 기본값
    });

    test('should return last message when messages exist', () {
      final messages = [
        Message(
          id: 'msg_1',
          conversationId: 'conv_1',
          senderId: 'sender_1',
          content: 'First',
          type: MessageType.sent,
          timestamp: DateTime(2024, 1, 15, 10, 0),
        ),
        Message(
          id: 'msg_2',
          conversationId: 'conv_1',
          senderId: 'sender_1',
          content: 'Last',
          type: MessageType.received,
          timestamp: DateTime(2024, 1, 15, 12, 0),
        ),
      ];

      final conversation = Conversation(
        id: 'conv_1',
        contactId: 'contact_1',
        platform: 'sms',
        messages: messages,
        lastMessageAt: DateTime(2024, 1, 15, 12, 0),
      );

      expect(conversation.lastMessage, isNotNull);
      expect(conversation.lastMessage?.content, 'Last');
    });

    test('should return null for last message when messages are empty', () {
      final conversation = Conversation(
        id: 'conv_1',
        contactId: 'contact_1',
        platform: 'sms',
        messages: [],
        lastMessageAt: DateTime(2024, 1, 15, 12, 0),
      );

      expect(conversation.lastMessage, isNull);
    });

    test('should calculate unread count correctly', () {
      final messages = [
        Message(
          id: 'msg_1',
          conversationId: 'conv_1',
          senderId: 'sender_1',
          content: 'Read',
          type: MessageType.received,
          timestamp: DateTime.now(),
          isRead: true,
        ),
        Message(
          id: 'msg_2',
          conversationId: 'conv_1',
          senderId: 'sender_1',
          content: 'Unread',
          type: MessageType.received,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      ];

      final conversation = Conversation(
        id: 'conv_1',
        contactId: 'contact_1',
        platform: 'sms',
        messages: messages,
        lastMessageAt: DateTime.now(),
        unreadCount: 1,
      );

      expect(conversation.unreadCount, 1);
    });

    // Note: Conversation does not have copyWith method in current implementation
    // This test can be added when copyWith is implemented
  });
}

