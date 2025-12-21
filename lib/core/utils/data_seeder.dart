import 'package:flutter/foundation.dart';
import '../../../domain/repositories/conversation_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import 'sample_data_generator.dart';

/// 데이터 시딩 유틸리티
class DataSeeder {
  /// 샘플 데이터가 없으면 생성
  static Future<void> seedIfEmpty({
    required ConversationRepository conversationRepository,
    required ProfileRepository profileRepository,
  }) async {
    try {
      // 대화 목록 확인
      final conversationsResult = await conversationRepository.getConversations();
      
      bool shouldSeed = false;
      
      conversationsResult.fold(
        (failure) {
          // 에러가 있으면 시딩 시도
          shouldSeed = true;
          debugPrint('대화 목록 조회 실패, 샘플 데이터 생성: ${failure.message}');
        },
        (conversations) {
          // 대화가 없으면 시딩
          if (conversations.isEmpty) {
            shouldSeed = true;
            debugPrint('대화 목록이 비어있음, 샘플 데이터 생성');
          }
        },
      );

      if (!shouldSeed) {
        debugPrint('샘플 데이터가 이미 존재함, 시딩 건너뜀');
        return;
      }

      // 샘플 대화 데이터 생성 및 저장
      final sampleConversations = SampleDataGenerator.generateSampleConversations();
      for (final conversation in sampleConversations) {
        final result = await conversationRepository.saveConversation(conversation);
        result.fold(
          (failure) => debugPrint('대화 저장 실패: ${failure.message}'),
          (_) => debugPrint('샘플 대화 저장 성공: ${conversation.id}'),
        );
      }

      // 샘플 프로필 데이터 생성 및 저장
      final sampleProfiles = SampleDataGenerator.generateSampleProfiles();
      for (final profile in sampleProfiles) {
        final result = await profileRepository.saveProfile(profile);
        result.fold(
          (failure) => debugPrint('프로필 저장 실패: ${failure.message}'),
          (_) => debugPrint('샘플 프로필 저장 성공: ${profile.id}'),
        );
      }

      debugPrint('샘플 데이터 시딩 완료');
    } catch (e) {
      debugPrint('샘플 데이터 시딩 중 오류: $e');
      // 시딩 실패해도 앱은 계속 실행
    }
  }
}

