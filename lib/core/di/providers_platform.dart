import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/platform/sms/sms_service.dart';
import '../../data/services/platform/sms/sms_platform_adapter.dart';
import '../../data/services/platform/sms/sms_listener_service.dart';
import '../../data/services/platform/kakao/kakao_platform_adapter.dart';
import '../../data/services/platform/kakao/kakao_listener_service.dart';
import '../../core/utils/sms_sync_service.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import 'providers.dart';

// SMS 통합 관련 Provider
final smsServiceProvider = Provider<SmsService>((ref) => SmsService());

final smsPlatformAdapterProvider = Provider<SmsPlatformAdapter>((ref) {
  return SmsPlatformAdapter(smsService: ref.watch(smsServiceProvider));
});

final smsListenerServiceProvider = Provider<SmsListenerService>((ref) {
  final smsService = ref.watch(smsServiceProvider);
  final smsAdapter = ref.watch(smsPlatformAdapterProvider);
  final conversationRepository = ref.watch(conversationRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  return SmsListenerService(
    smsService: smsService,
    smsAdapter: smsAdapter,
    conversationRepository: conversationRepository,
    profileRepository: profileRepository,
  );
});

final smsSyncServiceProvider = Provider<SmsSyncService>((ref) {
  final smsService = ref.watch(smsServiceProvider);
  final smsAdapter = ref.watch(smsPlatformAdapterProvider);
  final conversationRepository = ref.watch(conversationRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  return SmsSyncService(
    smsService: smsService,
    smsAdapter: smsAdapter,
    conversationRepository: conversationRepository,
    profileRepository: profileRepository,
  );
});

// KakaoTalk 통합 관련 Provider
final kakaoPlatformAdapterProvider = Provider<KakaoPlatformAdapter>((ref) {
  return KakaoPlatformAdapter();
});

final kakaoListenerServiceProvider = Provider<KakaoListenerService>((ref) {
  final kakaoAdapter = ref.watch(kakaoPlatformAdapterProvider);
  final conversationRepository = ref.watch(conversationRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);
  return KakaoListenerService(
    adapter: kakaoAdapter,
    conversationRepository: conversationRepository,
    profileRepository: profileRepository,
  );
});

