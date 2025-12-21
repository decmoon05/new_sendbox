import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../../../domain/repositories/conversation_repository.dart';
import '../../../../domain/repositories/profile_repository.dart';
import '../../../../domain/entities/message.dart';
import '../../../../domain/entities/conversation.dart';
import '../../../../domain/entities/contact_profile.dart';
import 'kakao_platform_adapter.dart';

/// 카카오톡 리스너 서비스
/// Notification Listener를 통해 카카오톡 알림을 감지하고 메시지를 저장
class KakaoListenerService {
  final ConversationRepository conversationRepository;
  final ProfileRepository profileRepository;
  final KakaoPlatformAdapter adapter;
  
  static const MethodChannel _channel = MethodChannel('com.sendbox.app/kakao_listener');
  static const EventChannel _eventChannel = EventChannel('com.sendbox.app/kakao_notifications');

  StreamSubscription? _subscription;

  KakaoListenerService({
    required this.conversationRepository,
    required this.profileRepository,
    required this.adapter,
  });

  /// 카카오톡 알림 리스닝 시작
  Future<void> startListening() async {
    try {
      // Notification Listener 권한 확인
      final hasPermission = await _channel.invokeMethod<bool>('hasNotificationListenerPermission');
      if (hasPermission != true) {
        debugPrint('카카오톡 알림 리스너 권한이 없습니다.');
        // TODO: 권한 요청 UI 표시
        return;
      }

      // 알림 스트림 구독
      _subscription = _eventChannel.receiveBroadcastStream().listen(
        _handleNotification,
        onError: (error) {
          debugPrint('카카오톡 알림 수신 오류: $error');
        },
      );

      debugPrint('카카오톡 리스너 시작 완료');
    } catch (e) {
      debugPrint('카카오톡 리스너 시작 실패: $e');
    }
  }

  /// 카카오톡 알림 리스닝 중지
  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    debugPrint('카카오톡 리스너 중지 완료');
  }

  /// 알림 처리
  void _handleNotification(dynamic data) {
    try {
      if (data is Map) {
        final notificationData = Map<String, dynamic>.from(data);
        
        // 카카오톡 알림인지 확인
        final packageName = notificationData['packageName'] as String?;
        if (packageName != 'com.kakao.talk' && packageName != 'com.kakao.talk.plus') {
          return;
        }

        // 메시지 파싱
        final message = adapter.parseNotificationData(notificationData);
        if (message == null) {
          return;
        }

        // 메시지 저장 (비동기로 처리)
        _saveMessage(message);
      }
    } catch (e) {
      debugPrint('카카오톡 알림 처리 오류: $e');
    }
  }

  /// 메시지 저장
  Future<void> _saveMessage(Message message) async {
    try {
      // 기존 대화 확인
      final conversationResult = await conversationRepository.getConversation(message.conversationId);
      
      Conversation conversation;
      
      conversationResult.fold(
        (_) {
          // 대화가 없으면 새로 생성
          conversation = Conversation(
            id: message.conversationId,
            contactId: message.senderName ?? message.senderId,
            platform: 'kakao',
            messages: [message],
            lastMessageAt: message.timestamp,
            unreadCount: 1,
            isPinned: false,
            metadata: {
              'platform': 'kakao',
            },
          );
        },
        (existingConversation) {
          // 기존 대화에 메시지 추가
          final updatedMessages = [...existingConversation.messages, message];
          conversation = existingConversation.copyWith(
            messages: updatedMessages,
            lastMessageAt: message.timestamp,
            unreadCount: existingConversation.unreadCount + (message.isRead ? 0 : 1),
          );
        },
      );

      // 대화 저장
      final saveResult = await conversationRepository.saveConversation(conversation);
      saveResult.fold(
        (failure) => debugPrint('카카오톡 메시지 저장 실패: ${failure.message}'),
        (_) => debugPrint('카카오톡 메시지 저장 성공: ${message.content}'),
      );

      // 프로필 업데이트 (연락처 이름 매칭)
      _updateProfileIfNeeded(conversation);
    } catch (e) {
      debugPrint('카카오톡 메시지 저장 중 오류: $e');
    }
  }

  /// 프로필 업데이트 (필요시)
  Future<void> _updateProfileIfNeeded(Conversation conversation) async {
    try {
      // 프로필에서 해당 연락처 찾기
      final profilesResult = await profileRepository.getProfiles();
      
      profilesResult.fold(
        (_) {},
        (profiles) {
          // 카카오톡 플랫폼 식별자로 매칭
          final matchingProfile = profiles.firstWhere(
            (profile) => profile.platforms.any(
              (platform) => platform.platform == 'kakao' && 
                           (platform.identifier == conversation.contactId || 
                            platform.displayName == conversation.contactId),
            ),
            orElse: () => profiles.firstWhere(
              (profile) => profile.name == conversation.contactId,
              orElse: () => throw StateError('No matching profile'),
            ),
          );
          
          // TODO: 프로필에 카카오톡 플랫폼 정보 추가 (없는 경우)
        },
      );
    } catch (e) {
      // 프로필이 없으면 무시 (자동 생성하지 않음)
      debugPrint('카카오톡 프로필 매칭 실패 (무시됨): $e');
    }
  }
}

