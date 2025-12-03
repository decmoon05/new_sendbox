# SendBox 보안 아키텍처 설계

## 🔐 보안 목표

### 보안 요구사항

1. **데이터 기밀성**: 민감한 대화 내용 보호
2. **데이터 무결성**: 데이터 변조 방지
3. **인증 및 권한**: 사용자 인증 및 접근 제어
4. **프라이버시**: 개인정보 보호
5. **규정 준수**: GDPR, 개인정보보호법 준수

---

## 🏗️ 보안 계층 구조

```
┌─────────────────────────────────────┐
│   애플리케이션 보안                  │
│   - 코드 난독화                       │
│   - Root 탐지                         │
│   - 디버깅 방지                       │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│   데이터 보안                        │
│   - 로컬 암호화                       │
│   - 키 관리                           │
│   - 안전한 저장소                      │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│   전송 보안                          │
│   - TLS 1.3                          │
│   - 인증서 고정                        │
│   - 요청 서명                          │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│   인증 및 권한                        │
│   - JWT + Refresh Token              │
│   - 생체 인증                         │
│   - 앱 잠금                           │
└─────────────────────────────────────┘
```

---

## 🔑 암호화 전략

### 1. 로컬 데이터 암호화

#### 알고리즘: AES-256-GCM

```dart
class EncryptionService {
  static const int keyLength = 32;  // 256 bits
  static const int ivLength = 12;   // 96 bits for GCM
  static const int tagLength = 16;  // 128 bits
  
  /// 데이터 암호화
  Future<EncryptedData> encrypt(String plaintext) async {
    // 1. 키 가져오기 (Android Keystore)
    final key = await _getEncryptionKey();
    
    // 2. IV 생성
    final iv = _generateIV();
    
    // 3. 암호화
    final cipher = AES(key, mode: AESMode.gcm);
    final encrypted = cipher.encrypt(
      plaintext,
      iv: iv,
    );
    
    return EncryptedData(
      ciphertext: encrypted.cipherText,
      iv: iv,
      tag: encrypted.tag,
    );
  }
  
  /// 데이터 복호화
  Future<String> decrypt(EncryptedData encryptedData) async {
    final key = await _getEncryptionKey();
    final cipher = AES(key, mode: AESMode.gcm);
    
    return cipher.decrypt(
      encryptedData.ciphertext,
      iv: encryptedData.iv,
      tag: encryptedData.tag,
    );
  }
  
  /// Android Keystore에서 키 가져오기
  Future<Key> _getEncryptionKey() async {
    final keystore = KeyStore('AndroidKeyStore');
    await keystore.load();
    
    if (!keystore.containsKey('sendbox_encryption_key')) {
      // 키 생성
      await _generateAndStoreKey();
    }
    
    final key = keystore.getKey('sendbox_encryption_key');
    return key;
  }
}
```

#### Android Keystore 통합

```kotlin
class EncryptionHelper {
    private val keyAlias = "sendbox_encryption_key"
    
    fun getOrCreateKey(): SecretKey {
        val keyStore = KeyStore.getInstance("AndroidKeyStore")
        keyStore.load(null)
        
        if (!keyStore.containsAlias(keyAlias)) {
            val keyGenerator = KeyGenerator.getInstance(
                KeyProperties.KEY_ALGORITHM_AES,
                "AndroidKeyStore"
            )
            
            val keyGenParameterSpec = KeyGenParameterSpec.Builder(
                keyAlias,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build()
            
            keyGenerator.init(keyGenParameterSpec)
            keyGenerator.generateKey()
        }
        
        return keyStore.getKey(keyAlias, null) as SecretKey
    }
}
```

### 2. 암호화 대상 데이터

- ✅ 대화 내역 (메시지 내용)
- ✅ 연락처 프로필 (상세 정보)
- ✅ 통화 전사본
- ✅ AI 분석 결과
- ✅ 사용자 설정 (민감한 설정)

### 3. 키 관리

#### 키 계층 구조

```
Master Key (Android Keystore)
  ↓
Encryption Keys (파일별/데이터별)
  ↓
Data Encryption
```

#### 키 로테이션

```dart
class KeyRotationService {
  Future<void> rotateKeys() async {
    // 1. 새 키 생성
    final newKey = await _generateNewKey();
    
    // 2. 기존 데이터 재암호화
    await _reencryptAllData(newKey);
    
    // 3. 이전 키 삭제
    await _deleteOldKey();
  }
}
```

---

## 🔒 전송 보안

### TLS 1.3 통신

```dart
class SecureApiClient {
  late Dio _dio;
  
  Future<void> initialize() async {
    _dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    // TLS 설정
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) {
          // 인증서 고정 검증
          return _validateCertificate(cert, host);
        };
        return client;
      },
    );
    
    // 인터셉터 추가
    _dio.interceptors.add(SecurityInterceptor());
  }
}
```

### 인증서 고정 (Certificate Pinning)

```dart
class CertificatePinningInterceptor extends Interceptor {
  static const Set<String> pinnedHosts = {
    'api.sendbox.app',
    'firebase.googleapis.com',
  };
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (pinnedHosts.contains(options.uri.host)) {
      // 인증서 고정 검증
      options.validateStatus = (status) {
        return _validateCertificate(options.uri.host);
      };
    }
    handler.next(options);
  }
}
```

### 요청 서명

```dart
class RequestSigningInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 요청 서명 추가
    final signature = _generateSignature(options);
    options.headers['X-Request-Signature'] = signature;
    options.headers['X-Timestamp'] = DateTime.now().toIso8601String();
    
    handler.next(options);
  }
  
  String _generateSignature(RequestOptions options) {
    final timestamp = DateTime.now().toIso8601String();
    final data = '${options.method}|${options.path}|$timestamp';
    final hmac = Hmac(sha256, _getApiSecret());
    final digest = hmac.convert(utf8.encode(data));
    return digest.toString();
  }
}
```

---

## 🔐 인증 및 권한

### 1. 사용자 인증

#### JWT + Refresh Token

```dart
class AuthenticationService {
  final SecureStorage _secureStorage;
  final ApiClient _apiClient;
  
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    
    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];
    
    // 안전하게 저장
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    
    return AuthResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
  
  Future<String> refreshAccessToken() async {
    final refreshToken = await _secureStorage.getRefreshToken();
    
    final response = await _apiClient.post('/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    
    final newAccessToken = response.data['accessToken'];
    await _secureStorage.saveAccessToken(newAccessToken);
    
    return newAccessToken;
  }
}
```

#### 생체 인증

```dart
class BiometricAuthService {
  final LocalAuthentication _localAuth;
  
  Future<bool> authenticate() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      
      if (!isAvailable) {
        return false;
      }
      
      return await _localAuth.authenticate(
        localizedReason: 'SendBox 잠금 해제',
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
```

### 2. 앱 잠금

```dart
class AppLockService {
  final SecureStorage _storage;
  final BiometricAuthService _biometricAuth;
  
  Future<void> enableAppLock({
    required Duration lockTimeout,
    required bool useBiometric,
  }) async {
    await _storage.saveAppLockSettings(
      enabled: true,
      lockTimeout: lockTimeout,
      useBiometric: useBiometric,
    );
  }
  
  Future<bool> checkAppLock() async {
    final settings = await _storage.getAppLockSettings();
    
    if (!settings.enabled) {
      return true; // 잠금 없음
    }
    
    final lastUnlockTime = await _storage.getLastUnlockTime();
    final now = DateTime.now();
    
    if (lastUnlockTime == null) {
      return false; // 처음 실행
    }
    
    final elapsed = now.difference(lastUnlockTime);
    
    if (elapsed > settings.lockTimeout) {
      // 잠금 필요
      if (settings.useBiometric) {
        return await _biometricAuth.authenticate();
      } else {
        // PIN 입력 화면
        return await _requestPIN();
      }
    }
    
    return true; // 잠금 불필요
  }
}
```

---

## 🛡️ 애플리케이션 보안

### 1. Root/탈옥 탐지

```dart
class SecurityCheckService {
  Future<SecurityStatus> performSecurityChecks() async {
    final checks = await Future.wait([
      _checkRootAccess(),
      _checkEmulator(),
      _checkDebugging(),
      _checkTampering(),
    ]);
    
    if (checks.any((check) => !check)) {
      return SecurityStatus.compromised;
    }
    
    return SecurityStatus.secure;
  }
  
  Future<bool> _checkRootAccess() async {
    // Root 탐지 로직
    try {
      final result = await MethodChannel('sendbox.security')
          .invokeMethod('checkRoot');
      return result == false;
    } catch (e) {
      return true; // 에러 시 안전하게 처리
    }
  }
  
  Future<bool> _checkDebugging() async {
    // 디버깅 상태 확인
    return !Platform.isDebugMode;
  }
}
```

### 2. 코드 난독화

```yaml
# pubspec.yaml
flutter:
  build:
    obfuscate: true
```

### 3. API 키 보호

```dart
class ApiKeyManager {
  // 빌드 시 환경 변수로 주입
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  
  // 런타임에 안전하게 가져오기
  static Future<String> getApiKey() async {
    // 환경 변수에서 가져오거나
    // 암호화된 저장소에서 가져오기
    final encryptedKey = await SecureStorage.getEncryptedApiKey();
    return await EncryptionService.decrypt(encryptedKey);
  }
}
```

---

## 🔐 데이터 프라이버시

### 1. 개인정보 최소화

```dart
class PrivacyService {
  /// AI 분석 시 개인정보 제거
  Future<String> anonymizeForAI(String content) async {
    // 전화번호 마스킹
    content = _maskPhoneNumbers(content);
    
    // 이메일 마스킹
    content = _maskEmails(content);
    
    // 주소 제거
    content = _removeAddresses(content);
    
    return content;
  }
  
  String _maskPhoneNumbers(String text) {
    final regex = RegExp(r'\d{3}[-.\s]?\d{3,4}[-.\s]?\d{4}');
    return text.replaceAll(regex, '[전화번호]');
  }
}
```

### 2. 데이터 보관 정책

```dart
class DataRetentionPolicy {
  static const Duration conversationRetention = Duration(days: 365);
  static const Duration callRecordRetention = Duration(days: 180);
  
  Future<void> cleanupOldData() async {
    final cutoffDate = DateTime.now().subtract(conversationRetention);
    
    // 오래된 대화 삭제
    await _conversationRepository.deleteOlderThan(cutoffDate);
    
    // 오래된 통화 기록 삭제
    await _callRecordRepository.deleteOlderThan(cutoffDate);
  }
}
```

### 3. 사용자 데이터 삭제

```dart
class DataDeletionService {
  Future<void> deleteAllUserData(String userId) async {
    // 1. 로컬 데이터 삭제
    await _localDatabase.deleteAll(userId);
    
    // 2. 클라우드 데이터 삭제
    await _cloudDatabase.deleteAll(userId);
    
    // 3. 암호화된 백업 삭제
    await _backupService.deleteBackups(userId);
    
    // 4. 로그 확인
    await _auditLog.logDeletion(userId);
  }
}
```

---

## 📋 보안 감사 및 로깅

### 1. 보안 이벤트 로깅

```dart
class SecurityAuditLogger {
  Future<void> logSecurityEvent({
    required SecurityEventType type,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    final event = SecurityAuditEvent(
      type: type,
      description: description,
      timestamp: DateTime.now(),
      metadata: metadata ?? {},
    );
    
    // 로컬 로그 저장
    await _localLogger.log(event);
    
    // 중요 이벤트는 클라우드로 전송 (익명화)
    if (_isCriticalEvent(type)) {
      await _cloudLogger.logAnonymized(event);
    }
  }
}

enum SecurityEventType {
  authenticationSuccess,
  authenticationFailure,
  dataAccess,
  dataModification,
  encryptionError,
  rootDetected,
  apiKeyExposed,
}
```

### 2. 이상 행위 탐지

```dart
class AnomalyDetectionService {
  Future<bool> detectAnomaly(UserActivity activity) async {
    // 빈번한 로그인 실패
    if (activity.failedLoginAttempts > 5) {
      await _securityAuditLogger.logSecurityEvent(
        type: SecurityEventType.authenticationFailure,
        description: 'Multiple failed login attempts',
      );
      return true;
    }
    
    // 비정상적인 데이터 접근
    if (activity.dataAccessRate > _normalThreshold) {
      return true;
    }
    
    return false;
  }
}
```

---

## 🔒 클라우드 보안

### 1. Firestore 보안 규칙

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자는 자신의 데이터만 접근
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
      
      // 암호화된 데이터만 저장 가능
      match /conversations/{conversationId} {
        allow write: if request.resource.data.keys().hasAll(['encryptedData'])
                     && request.resource.data.encryptedData is string;
      }
    }
  }
}
```

### 2. Firebase Storage 보안

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null 
                         && request.auth.uid == userId;
    }
  }
}
```

---

## ✅ 보안 체크리스트

### 개발 단계
- [ ] 코드 난독화 활성화
- [ ] API 키 환경 변수로 관리
- [ ] 디버그 빌드에서 민감 정보 제거
- [ ] Root/탈옥 탐지 구현
- [ ] 인증서 고정 구현

### 런타임
- [ ] 로컬 데이터 암호화
- [ ] TLS 1.3 통신
- [ ] 생체 인증 옵션
- [ ] 앱 잠금 기능
- [ ] 세션 타임아웃

### 데이터 관리
- [ ] 최소 권한 원칙
- [ ] 데이터 보관 정책
- [ ] 사용자 데이터 삭제 기능
- [ ] 개인정보 익명화

### 모니터링
- [ ] 보안 이벤트 로깅
- [ ] 이상 행위 탐지
- [ ] 크래시 리포트
- [ ] 정기 보안 감사

---

## 📚 다음 단계

1. 암호화 서비스 구현
2. Android Keystore 통합
3. 인증 시스템 구축
4. 보안 테스트 계획
5. 보안 감사 체크리스트


