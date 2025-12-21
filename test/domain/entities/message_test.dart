import 'package:flutter_test/flutter_test.dart';
import 'package:sendbox/domain/entities/message.dart';

void main() {
  group('Message', () {
    test('should create a message with all required fields', () {
      final message = Message(
        id: 'msg_1',
        conversationId: 'conv_1',
        senderId: 'sender_1',
        content: 'Hello',
        type: MessageType.sent,
        timestamp: DateTime(2024, 1, 15, 12, 0),
      );

      expect(message.id, 'msg_1');
      expect(message.conversationId, 'conv_1');
      expect(message.senderId, 'sender_1');
      expect(message.content, 'Hello');
      expect(message.type, MessageType.sent);
      expect(message.isRead, false); // 기본값
    });

    test('should support equality comparison', () {
      final message1 = Message(
        id: 'msg_1',
        conversationId: 'conv_1',
        senderId: 'sender_1',
        content: 'Hello',
        type: MessageType.sent,
        timestamp: DateTime(2024, 1, 15, 12, 0),
      );

      final message2 = Message(
        id: 'msg_1',
        conversationId: 'conv_1',
        senderId: 'sender_1',
        content: 'Hello',
        type: MessageType.sent,
        timestamp: DateTime(2024, 1, 15, 12, 0),
      );

      expect(message1, equals(message2));
    });

    test('should distinguish between sent and received messages', () {
      final sentMessage = Message(
        id: 'msg_1',
        conversationId: 'conv_1',
        senderId: 'me',
        content: 'Hello',
        type: MessageType.sent,
        timestamp: DateTime.now(),
      );

      final receivedMessage = Message(
        id: 'msg_2',
        conversationId: 'conv_1',
        senderId: 'other',
        content: 'Hi',
        type: MessageType.received,
        timestamp: DateTime.now(),
      );

      expect(sentMessage.type, MessageType.sent);
      expect(receivedMessage.type, MessageType.received);
      expect(sentMessage, isNot(equals(receivedMessage)));
    });
  });

  group('Attachment', () {
    test('should create an attachment with all required fields', () {
      final attachment = Attachment(
        id: 'att_1',
        type: 'image',
        url: 'https://example.com/image.jpg',
      );

      expect(attachment.id, 'att_1');
      expect(attachment.type, 'image');
      expect(attachment.url, 'https://example.com/image.jpg');
    });

    test('should support optional fields', () {
      final attachment = Attachment(
        id: 'att_1',
        type: 'image',
        url: 'https://example.com/image.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        size: 1024,
        mimeType: 'image/jpeg',
      );

      expect(attachment.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(attachment.size, 1024);
      expect(attachment.mimeType, 'image/jpeg');
    });
  });
}

