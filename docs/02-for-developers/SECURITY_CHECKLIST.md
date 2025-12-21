# 보안 체크리스트

> SendBox 프로젝트 보안 검토 및 구현 체크리스트

## 📋 현재 상태

### ✅ 완료된 보안 기능
- [x] `.gitignore`에 민감한 파일 제외 설정
- [x] 기본 암호화 유틸리티 클래스 구조
- [x] SettingsService를 통한 설정 관리
- [x] Firebase Auth 통합 준비

### ⚠️ 부분 구현
- [ ] AES-256-GCM 암호화 (구조만 존재, 실제 구현 필요)
- [ ] Android Keystore 통합 (미구현)
- [ ] Secure Storage 사용 (SharedPreferences만 사용 중)
- [ ] JWT 토큰 관리 (구조만 존재)

### ❌ 미구현
- [ ] 생체 인증 (지문/Face ID)
- [ ] 앱 잠금 기능
- [ ] Root 탐지
- [ ] 디버깅 방지
- [ ] 코드 난독화
- [ ] 인증서 고정 (Certificate Pinning)

---

## 🔒 우선순위별 구현 계획

### 우선순위 1: 즉시 필요 (MVP)

#### 1. Secure Storage로 토큰 저장
**현재 상태:** SharedPreferences 사용 중
**목표:** `flutter_secure_storage`로 민감한 데이터 이동

```dart
// lib/core/services/secure_storage_service.dart 생성 필요
class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.authToken, value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.authToken);
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.authToken);
  }
}
```

**작업 항목:**
- [ ] `SecureStorageService` 클래스 생성
- [ ] 인증 토큰을 SharedPreferences에서 Secure Storage로 이동
- [ ] Refresh Token도 Secure Storage로 이동
- [ ] 기존 SharedPreferences 토큰 마이그레이션 로직 추가

#### 2. 기본 암호화 유틸리티 개선
**현재 상태:** 기본 해시 및 Base64만 구현
**목표:** 실제 AES-256-GCM 암호화 지원

**작업 항목:**
- [ ] AES-256-GCM 암호화 구현 (PointyCastle 패키지 사용)
- [ ] IV 생성 로직 개선 (현재는 간단한 해시 기반)
- [ ] 키 관리 로직 추가

### 우선순위 2: 단기 (1-2주)

#### 3. Android Keystore 통합
**목표:** 암호화 키를 안전하게 저장

**작업 항목:**
- [ ] Android Keystore 플러그인 통합 (`flutter_secure_storage`가 이미 지원)
- [ ] 암호화 키를 Keystore에 저장
- [ ] 키 생성 및 로드 로직 구현

#### 4. Firebase Auth 토큰 관리
**현재 상태:** 기본 구조만 존재
**목표:** JWT 토큰 안전하게 관리 및 갱신

**작업 항목:**
- [ ] Firebase Auth 토큰을 Secure Storage에 저장
- [ ] 토큰 만료 시 자동 갱신 로직
- [ ] Refresh Token 관리

### 우선순위 3: 중기 (1개월 내)

#### 5. 생체 인증
**목표:** 앱 잠금 및 민감한 작업 보호

**작업 항목:**
- [ ] `local_auth` 패키지 통합
- [ ] 앱 시작 시 생체 인증 옵션
- [ ] 설정에서 생체 인증 활성화/비활성화

#### 6. 앱 잠금 기능
**목표:** 백그라운드로 전환 시 앱 잠금

**작업 항목:**
- [ ] 앱 생명주기 감지 (`AppLifecycleState`)
- [ ] 잠금 화면 구현
- [ ] PIN/패턴 잠금 옵션

---

## 🛡️ 보안 모범 사례 체크리스트

### 데이터 저장
- [x] 민감한 데이터는 SharedPreferences 대신 Secure Storage 사용
- [ ] API 키는 환경 변수나 안전한 곳에 저장
- [ ] 로그에 민감한 정보 출력 금지
- [ ] 디버그 모드에서만 상세 로그 출력

### 네트워크 보안
- [ ] TLS 1.3 사용 (Dio 기본 설정)
- [ ] 인증서 고정 구현 (선택사항)
- [ ] API 요청 서명 (향후 필요시)
- [ ] 타임아웃 설정 적절히 구성

### 코드 보안
- [ ] 릴리스 빌드에서 디버그 모드 비활성화
- [ ] 코드 난독화 활성화 (ProGuard/R8)
- [ ] Root 탐지 (선택사항, 사용자 경험 고려)
- [ ] 디버깅 방지 (선택사항)

### 인증 및 권한
- [ ] 최소 권한 원칙 (필요한 권한만 요청)
- [ ] 권한 거부 시 적절한 안내
- [ ] Firebase Auth 상태 관리
- [ ] 세션 타임아웃 관리

---

## 📝 구현 가이드

### 1. Secure Storage로 토큰 저장

**파일:** `lib/core/services/secure_storage_service.dart`

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Auth Token
  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: StorageKeys.authToken, value: token);
  }

  static Future<String?> getAuthToken() async {
    return await _storage.read(key: StorageKeys.authToken);
  }

  static Future<void> deleteAuthToken() async {
    await _storage.delete(key: StorageKeys.authToken);
  }

  // Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  // User ID
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: StorageKeys.userId, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: StorageKeys.userId);
  }

  // Clear all
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

### 2. AES-256-GCM 암호화 구현

**필요 패키지:**
```yaml
dependencies:
  pointycastle: ^3.7.3
```

**파일:** `lib/core/services/encryption_service.dart` (새로 생성)

```dart
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class EncryptionService {
  // AES-256-GCM 암호화
  static Future<EncryptedData> encrypt(String plaintext, Uint8List key) async {
    final iv = _generateIV();
    final cipher = GCMBlockCipher(AESEngine());
    
    final keyParam = KeyParameter(key);
    final params = AEADParameters(keyParam, 128, iv, Uint8List(0));
    cipher.init(true, params);
    
    final plaintextBytes = utf8.encode(plaintext);
    final ciphertext = cipher.process(plaintextBytes);
    
    return EncryptedData(
      ciphertext: base64Encode(ciphertext),
      iv: base64Encode(iv),
    );
  }

  // AES-256-GCM 복호화
  static Future<String> decrypt(EncryptedData encryptedData, Uint8List key) async {
    final iv = base64Decode(encryptedData.iv);
    final ciphertext = base64Decode(encryptedData.ciphertext);
    
    final cipher = GCMBlockCipher(AESEngine());
    final keyParam = KeyParameter(key);
    final params = AEADParameters(keyParam, 128, iv, Uint8List(0));
    cipher.init(false, params);
    
    final plaintext = cipher.process(ciphertext);
    return utf8.decode(plaintext);
  }

  // IV 생성 (12 bytes for GCM)
  static Uint8List _generateIV() {
    final random = SecureRandom('Fortuna');
    random.seed(KeyParameter(_generateRandomBytes(32)));
    return random.nextBytes(12);
  }

  static Uint8List _generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(length, (_) => random.nextInt(256)),
    );
  }
}
```

---

## ✅ 다음 단계

1. **즉시 실행:** Secure Storage로 토큰 저장 구현
2. **단기:** AES-256-GCM 암호화 구현
3. **중기:** 생체 인증 및 앱 잠금 기능

---

**마지막 업데이트:** 2024-01-15

