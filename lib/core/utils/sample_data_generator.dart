import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/contact_profile.dart';

/// 샘플 데이터 생성 유틸리티
class SampleDataGenerator {
  /// 샘플 대화 목록 생성
  static List<Conversation> generateSampleConversations() {
    final now = DateTime.now();
    
    return [
      Conversation(
        id: 'conv_1',
        contactId: '홍길동',
        platform: 'kakao',
        lastMessageAt: now.subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        isPinned: true,
        messages: [
          Message(
            id: 'msg_1_1',
            conversationId: 'conv_1',
            senderId: '홍길동',
            senderName: '홍길동',
            content: '오늘 저녁 시간 되나요?',
            type: MessageType.received,
            timestamp: now.subtract(const Duration(hours: 2)),
            isRead: true,
          ),
          Message(
            id: 'msg_1_2',
            conversationId: 'conv_1',
            senderId: 'me',
            senderName: '나',
            content: '네, 괜찮아요! 몇 시쯤이 좋을까요?',
            type: MessageType.sent,
            timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
            isRead: true,
          ),
          Message(
            id: 'msg_1_3',
            conversationId: 'conv_1',
            senderId: '홍길동',
            senderName: '홍길동',
            content: '7시는 어떠세요?',
            type: MessageType.received,
            timestamp: now.subtract(const Duration(minutes: 30)),
            isRead: true,
          ),
          Message(
            id: 'msg_1_4',
            conversationId: 'conv_1',
            senderId: '홍길동',
            senderName: '홍길동',
            content: '그리고 내일 회의 자료 좀 보내주실 수 있나요?',
            type: MessageType.received,
            timestamp: now.subtract(const Duration(minutes: 5)),
            isRead: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv_2',
        contactId: '김영희',
        platform: 'sms',
        lastMessageAt: now.subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isPinned: false,
        messages: [
          Message(
            id: 'msg_2_1',
            conversationId: 'conv_2',
            senderId: 'me',
            senderName: '나',
            content: '프로젝트 진행 상황 공유해주세요',
            type: MessageType.sent,
            timestamp: now.subtract(const Duration(hours: 3)),
            isRead: true,
          ),
          Message(
            id: 'msg_2_2',
            conversationId: 'conv_2',
            senderId: '김영희',
            senderName: '김영희',
            content: '네, 오늘 중으로 완료 예정입니다!',
            type: MessageType.received,
            timestamp: now.subtract(const Duration(hours: 1)),
            isRead: true,
          ),
        ],
      ),
      Conversation(
        id: 'conv_3',
        contactId: '박민수',
        platform: 'discord',
        lastMessageAt: now.subtract(const Duration(days: 1)),
        unreadCount: 5,
        isPinned: false,
        messages: [
          Message(
            id: 'msg_3_1',
            conversationId: 'conv_3',
            senderId: '박민수',
            senderName: '박민수',
            content: '주말에 같이 게임 할래요?',
            type: MessageType.received,
            timestamp: now.subtract(const Duration(days: 1)),
            isRead: false,
          ),
        ],
      ),
      Conversation(
        id: 'conv_4',
        contactId: '이지은',
        platform: 'instagram',
        lastMessageAt: now.subtract(const Duration(days: 2)),
        unreadCount: 0,
        isPinned: false,
        messages: [
          Message(
            id: 'msg_4_1',
            conversationId: 'conv_4',
            senderId: '이지은',
            senderName: '이지은',
            content: '사진 잘 나왔어요!',
            type: MessageType.received,
            timestamp: now.subtract(const Duration(days: 2)),
            isRead: true,
          ),
          Message(
            id: 'msg_4_2',
            conversationId: 'conv_4',
            senderId: 'me',
            senderName: '나',
            content: '감사합니다!',
            type: MessageType.sent,
            timestamp: now.subtract(const Duration(days: 2, hours: -1)),
            isRead: true,
          ),
        ],
      ),
      Conversation(
        id: 'conv_5',
        contactId: '최준호',
        platform: 'telegram',
        lastMessageAt: now.subtract(const Duration(days: 3)),
        unreadCount: 0,
        isPinned: false,
        messages: [
          Message(
            id: 'msg_5_1',
            conversationId: 'conv_5',
            senderId: '최준호',
            senderName: '최준호',
            content: '회의 시간 변경되었어요',
            type: MessageType.received,
            timestamp: now.subtract(const Duration(days: 3)),
            isRead: true,
          ),
        ],
      ),
    ];
  }

  /// 샘플 프로필 목록 생성
  static List<ContactProfile> generateSampleProfiles() {
    final now = DateTime.now();
    
    return [
      ContactProfile(
        id: 'profile_1',
        name: '홍길동',
        phoneNumber: '010-1234-5678',
        email: 'hong@example.com',
        platforms: [
          PlatformIdentifier(
            platform: 'kakao',
            identifier: 'hong123',
          ),
        ],
        priority: 3, // high
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      ContactProfile(
        id: 'profile_2',
        name: '김영희',
        phoneNumber: '010-2345-6789',
        email: null,
        platforms: [
          PlatformIdentifier(
            platform: 'sms',
            identifier: '01023456789',
          ),
        ],
        priority: 2, // medium
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(hours: 3)),
      ),
      ContactProfile(
        id: 'profile_3',
        name: '박민수',
        phoneNumber: null,
        email: null,
        platforms: [
          PlatformIdentifier(
            platform: 'discord',
            identifier: '박민수#1234',
          ),
        ],
        priority: 1, // low
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      ContactProfile(
        id: 'profile_4',
        name: '이지은',
        phoneNumber: '010-3456-7890',
        email: 'lee@example.com',
        platforms: [
          PlatformIdentifier(
            platform: 'instagram',
            identifier: 'jilee',
          ),
        ],
        priority: 2, // medium
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      ContactProfile(
        id: 'profile_5',
        name: '최준호',
        phoneNumber: '010-4567-8901',
        email: null,
        platforms: [
          PlatformIdentifier(
            platform: 'telegram',
            identifier: '@choi123',
          ),
        ],
        priority: 1, // low
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}

