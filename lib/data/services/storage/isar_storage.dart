import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import '../../models/contact_profile_model.dart';
import '../../models/ai_recommendation_model.dart';
import '../../models/sync_status_model.dart';

/// Isar 데이터베이스 저장소 관리
class IsarStorage {
  static Isar? _isar;

  /// Isar 인스턴스 가져오기
  static Future<Isar> getInstance() async {
    if (_isar != null) {
      return _isar!;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          ConversationModelSchema,
          MessageModelSchema,
          ContactProfileModelSchema,
          AIRecommendationModelSchema,
          SyncStatusModelSchema,
        ],
        directory: dir.path,
        name: AppConstants.localDatabaseName.replaceAll('.db', ''),
      );
      
      debugPrint('Isar 데이터베이스 초기화 완료');

      return _isar!;
    } catch (e) {
      throw CacheException(
        message: '데이터베이스 초기화에 실패했습니다: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Isar 인스턴스 닫기
  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}

