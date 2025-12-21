import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../data/services/storage/isar_storage.dart';

/// 앱 초기화 클래스
class AppInit {
  /// 앱 초기화
  static Future<void> initialize() async {
    try {
      // Firebase 초기화
      await _initFirebase();

      // 로컬 데이터베이스 초기화
      await _initDatabase();
    } catch (e) {
      debugPrint('앱 초기화 중 오류 발생: $e');
      rethrow;
    }
  }

  /// Firebase 초기화
  static Future<void> _initFirebase() async {
    try {
      // Firebase가 이미 초기화되어 있는지 확인
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
        debugPrint('Firebase 초기화 완료');
      }
    } catch (e) {
      debugPrint('Firebase 초기화 실패: $e');
      // Firebase 초기화 실패해도 앱은 계속 실행 (오프라인 모드)
    }
  }

  /// 데이터베이스 초기화
  static Future<void> _initDatabase() async {
    try {
      await IsarStorage.getInstance();
      debugPrint('데이터베이스 초기화 완료');
    } catch (e) {
      debugPrint('데이터베이스 초기화 실패: $e');
      rethrow;
    }
  }

  /// 앱 종료 시 정리
  static Future<void> dispose() async {
    try {
      await IsarStorage.close();
      debugPrint('앱 정리 완료');
    } catch (e) {
      debugPrint('앱 정리 중 오류: $e');
    }
  }
}

