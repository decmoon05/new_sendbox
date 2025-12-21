import 'package:flutter/foundation.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/entities/contact_profile.dart';
import '../../../domain/repositories/conversation_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../../data/services/platform/sms/sms_service.dart';
import '../../../data/services/platform/sms/sms_platform_adapter.dart';

/// SMS 동기화 서비스
/// 기존 SMS 메시지를 앱의 Conversation으로 가져옴
class SmsSyncService {
  final SmsService smsService;
  final SmsPlatformAdapter smsAdapter;
  final ConversationRepository conversationRepository;
  final ProfileRepository profileRepository;

  SmsSyncService({
    required this.smsService,
    required this.smsAdapter,
    required this.conversationRepository,
    required this.profileRepository,
  });

  /// 기존 SMS 메시지 동기화 (최초 1회 또는 수동 동기화 시)
  Future<void> syncExistingSms({int limitPerContact = 50}) async {
    try {
      // 모든 SMS 메시지 가져오기 (최신 순으로)
      final allSms = await smsService.getSmsMessages(limit: 1000);
      
      if (allSms.isEmpty) {
        debugPrint('동기화할 SMS 메시지가 없습니다.');
        return;
      }

      // 전화번호별로 그룹화
      final messagesByPhone = <String, List<Map<String, dynamic>>>{};
      
      for (final sms in allSms) {
        final phoneNumber = sms['phoneNumber'] as String? ?? '';
        if (phoneNumber.isNotEmpty) {
          messagesByPhone.putIfAbsent(phoneNumber, () => []).add(sms);
        }
      }

      // 각 전화번호별로 Conversation 생성/업데이트
      for (final entry in messagesByPhone.entries) {
        final phoneNumber = entry.key;
        final messages = entry.value;
        
        // 최신 순으로 정렬 및 제한
        messages.sort((a, b) {
          final timeA = a['timestamp'] as int? ?? 0;
          final timeB = b['timestamp'] as int? ?? 0;
          return timeB.compareTo(timeA); // 내림차순
        });
        
        final limitedMessages = messages.take(limitPerContact).toList();
        
        // 프로필에서 연락처 이름 찾기
        final profilesResult = await profileRepository.getProfiles();
        String contactName = phoneNumber;
        
        profilesResult.fold(
          (_) {},
          (profiles) {
            final matchingProfile = profiles.firstWhere(
              (p) => p.phoneNumber == phoneNumber,
              orElse: () => profiles.firstWhere(
                (p) => p.platforms.any((platform) => 
                  platform.platform == 'sms' && platform.identifier == phoneNumber),
                orElse: () => profiles.isNotEmpty ? profiles.first : ContactProfile(
                  id: phoneNumber,
                  name: phoneNumber,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              ),
            );
            contactName = matchingProfile.name;
          },
        );

        // SMS 메시지를 Conversation 메시지로 변환
        final conversationMessages = limitedMessages.map((smsData) {
          final timestamp = DateTime.fromMillisecondsSinceEpoch(
            smsData['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
          );
          
          return Message(
            id: smsData['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
            conversationId: phoneNumber,
            senderId: phoneNumber,
            senderName: contactName,
            content: smsData['message'] as String? ?? '',
            type: smsData['type'] == 'sent' ? MessageType.sent : MessageType.received,
            timestamp: timestamp,
            isRead: smsData['isRead'] as bool? ?? true,
            metadata: {
              'platform': 'sms',
            },
          );
        }).toList();

        // 시간순으로 정렬 (오래된 것부터)
        conversationMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Conversation 생성
        final lastMessage = conversationMessages.isNotEmpty 
            ? conversationMessages.last 
            : null;
        
        final conversation = Conversation(
          id: phoneNumber,
          contactId: contactName,
          platform: 'sms',
          messages: conversationMessages,
          lastMessageAt: lastMessage?.timestamp ?? DateTime.now(),
          unreadCount: conversationMessages
              .where((m) => !m.isRead && m.type == MessageType.received)
              .length,
          isPinned: false,
          metadata: {
            'platform': 'sms',
            'phoneNumber': phoneNumber,
          },
        );

        // 저장 (기존 대화가 있으면 업데이트, 없으면 생성)
        await conversationRepository.saveConversation(conversation);
      }

      debugPrint('SMS 동기화 완료: ${messagesByPhone.length}개의 대화');
    } catch (e) {
      debugPrint('SMS 동기화 실패: $e');
      rethrow;
    }
  }
}

