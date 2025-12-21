import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';

/// Secure Storage 서비스
/// 민감한 데이터(토큰 등)를 안전하게 저장하고 관리합니다
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Auth Token 저장
  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: StorageKeys.authToken, value: token);
  }

  /// Auth Token 조회
  static Future<String?> getAuthToken() async {
    return await _storage.read(key: StorageKeys.authToken);
  }

  /// Auth Token 삭제
  static Future<void> deleteAuthToken() async {
    await _storage.delete(key: StorageKeys.authToken);
  }

  /// Refresh Token 저장
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  /// Refresh Token 조회
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  /// Refresh Token 삭제
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  /// User ID 저장
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: StorageKeys.userId, value: userId);
  }

  /// User ID 조회
  static Future<String?> getUserId() async {
    return await _storage.read(key: StorageKeys.userId);
  }

  /// User ID 삭제
  static Future<void> deleteUserId() async {
    await _storage.delete(key: StorageKeys.userId);
  }

  /// 모든 인증 관련 데이터 삭제 (로그아웃 시 사용)
  static Future<void> clearAuthData() async {
    await deleteAuthToken();
    await deleteRefreshToken();
    await deleteUserId();
  }

  /// 모든 데이터 삭제
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// 특정 키로 데이터 저장
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// 특정 키로 데이터 조회
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// 특정 키 데이터 삭제
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}

