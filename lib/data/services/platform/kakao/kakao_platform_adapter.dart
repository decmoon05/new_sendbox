import '../../../../domain/entities/message.dart';
import '../../../../domain/entities/conversation.dart';

/// 카카오톡 플랫폼 어댑터
/// 카카오톡 알림에서 받은 메시지를 앱의 메시지 모델로 변환
class KakaoPlatformAdapter {
  /// 카카오톡 알림 데이터를 Message 엔티티로 변환
  Message? parseNotificationData(Map<String, dynamic> notificationData) {
    try {
      // 카카오톡 알림에서 메시지 정보 추출
      final title = notificationData['title'] as String? ?? '';
      final body = notificationData['body'] as String? ?? '';
      final packageName = notificationData['packageName'] as String? ?? '';
      
      // 카카오톡 패키지명 확인
      if (packageName != 'com.kakao.talk' && packageName != 'com.kakao.talk.plus') {
        return null;
      }

      // 제목에서 발신자 추출 (예: "홍길동: 메시지 내용")
      String senderName = '';
      String content = body;
      
      if (title.isNotEmpty && title.contains(':')) {
        final parts = title.split(':');
        if (parts.length >= 2) {
          senderName = parts[0].trim();
          content = parts.sublist(1).join(':').trim();
        } else {
          senderName = title;
        }
      } else if (title.isNotEmpty) {
        senderName = title;
      }

      // body에서 메시지 내용 추출 (제목에 내용이 없을 경우)
      if (content.isEmpty && body.isNotEmpty) {
        content = body;
      }

      if (content.isEmpty) {
        return null;
      }

      // 대화 ID 생성 (발신자 이름 기반, 나중에 프로필과 매칭)
      final conversationId = senderName.isNotEmpty ? senderName : 'unknown';

      // Message 엔티티 생성
      return Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: conversationId,
        senderId: conversationId,
        senderName: senderName,
        content: content,
        type: MessageType.received,
        timestamp: DateTime.now(),
        isRead: false,
        metadata: {
          'platform': 'kakao',
          'packageName': packageName,
          'originalTitle': title,
        },
      );
    } catch (e) {
      return null;
    }
  }

  /// 카카오톡 메시지에서 대화 정보 추출
  Conversation? parseConversationFromMessage(Message message) {
    try {
      return Conversation(
        id: message.conversationId,
        contactId: message.senderName ?? message.senderId,
        platform: 'kakao',
        messages: [message],
        lastMessageAt: message.timestamp,
        unreadCount: message.isRead ? 0 : 1,
        isPinned: false,
        metadata: {
          'platform': 'kakao',
        },
      );
    } catch (e) {
      return null;
    }
  }

  /// 카카오톡 전송 (향후 구현 - 카카오톡 API 또는 인텐트 사용)
  Future<bool> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    // TODO: 카카오톡 메시지 전송 구현
    // 방법 1: 카카오톡 공식 API 사용 (제한적)
    // 방법 2: 인텐트를 통해 카카오톡 앱 열기 (선호)
    return false;
  }
}

