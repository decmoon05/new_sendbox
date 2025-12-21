import 'dart:async';
import 'package:flutter/services.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/repositories/conversation_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import 'sms_platform_adapter.dart';
import 'sms_service.dart';

/// SMS 수신 리스너 서비스
/// Android에서 수신된 SMS를 처리하고 Conversation으로 저장
class SmsListenerService {
  final SmsService smsService;
  final SmsPlatformAdapter smsAdapter;
  final ConversationRepository conversationRepository;
  final ProfileRepository profileRepository;
  
  static const MethodChannel _channel = MethodChannel('com.sendbox.app/sms');
  StreamSubscription<dynamic>? _smsSubscription;

  SmsListenerService({
    required this.smsService,
    required this.smsAdapter,
    required this.conversationRepository,
    required this.profileRepository,
  });

  /// SMS 수신 대기 시작
  Future<void> startListening() async {
    try {
      // Android에서 SMS 수신 대기 시작
      await smsService.startListening();
      
      // MethodChannel을 통해 SMS 수신 이벤트 구독
      _smsSubscription = _channel.receiveBroadcastStream().listen(
        _handleSmsReceived,
        onError: (error) {
          // 에러 처리
        },
      );
    } catch (e) {
      throw Exception('SMS 수신 대기 시작 실패: $e');
    }
  }

  /// SMS 수신 대기 중지
  Future<void> stopListening() async {
    try {
      await _smsSubscription?.cancel();
      await smsService.stopListening();
    } catch (e) {
      throw Exception('SMS 수신 대기 중지 실패: $e');
    }
  }

  /// SMS 수신 처리
  void _handleSmsReceived(dynamic data) {
    if (data is Map) {
      final phoneNumber = data['phoneNumber'] as String? ?? '';
      final message = data['message'] as String? ?? '';
      final timestamp = data['timestamp'] as int?;
      
      if (phoneNumber.isNotEmpty && message.isNotEmpty) {
        _processReceivedSms(
          phoneNumber: phoneNumber,
          message: message,
          timestamp: timestamp != null 
              ? DateTime.fromMillisecondsSinceEpoch(timestamp)
              : DateTime.now(),
        );
      }
    }
  }

  /// 수신된 SMS 처리 및 저장
  Future<void> _processReceivedSms({
    required String phoneNumber,
    required String message,
    required DateTime timestamp,
  }) async {
    try {
      // 프로필에서 연락처 이름 찾기 (없으면 전화번호 사용)
      final profilesResult = await profileRepository.getProfiles();
      String contactName = phoneNumber;
      
      profilesResult.fold(
        (_) {},
        (profiles) {
          final profile = profiles.firstWhere(
            (p) => p.phoneNumber == phoneNumber,
            orElse: () => profiles.firstWhere(
              (p) => p.platforms.any((platform) => 
                platform.platform == 'sms' && platform.identifier == phoneNumber),
              orElse: () => profiles.first, // 첫 번째 프로필 (임시)
            ),
          );
          contactName = profile.name;
        },
      );

      // 기존 대화 가져오기
      final conversationResult = await conversationRepository.getConversation(phoneNumber);
      
      Conversation existingConversation;
      conversationResult.fold(
        (_) {
          // 대화가 없으면 새로 생성
          existingConversation = Conversation(
            id: phoneNumber,
            contactId: contactName,
            platform: 'sms',
            messages: [],
            lastMessageAt: timestamp,
            unreadCount: 0,
            isPinned: false,
            metadata: {
              'platform': 'sms',
              'phoneNumber': phoneNumber,
            },
          );
        },
        (conversation) {
          existingConversation = conversation;
        },
      );

      // 새 메시지 생성
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: phoneNumber,
        senderId: phoneNumber,
        senderName: contactName,
        content: message,
        type: MessageType.received,
        timestamp: timestamp,
        isRead: false,
        metadata: {
          'platform': 'sms',
        },
      );

      // 기존 메시지에 새 메시지 추가
      final updatedMessages = [...existingConversation.messages, newMessage];
      final unreadCount = updatedMessages
          .where((m) => !m.isRead && m.type == MessageType.received)
          .length;

      // 대화 업데이트
      final updatedConversation = Conversation(
        id: existingConversation.id,
        contactId: existingConversation.contactId,
        platform: existingConversation.platform,
        messages: updatedMessages,
        lastMessageAt: timestamp,
        unreadCount: unreadCount,
        isPinned: existingConversation.isPinned,
        metadata: existingConversation.metadata,
      );

      // 저장
      await conversationRepository.saveConversation(updatedConversation);
    } catch (e) {
      // 에러 처리 (로깅 등)
    }
  }
}

