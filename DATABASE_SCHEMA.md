# SendBox 데이터베이스 스키마 설계

## 📊 데이터베이스 아키텍처

### 하이브리드 저장 전략

```
┌──────────────────────────────────────┐
│      로컬 데이터베이스 (Hive/Isar)    │
│  - 빠른 접근                            │
│  - 오프라인 지원                         │
│  - 실시간 작업                            │
└──────────────────────────────────────┘
              ↕ 동기화
┌──────────────────────────────────────┐
│   클라우드 (Firebase Firestore)       │
│  - 백업 및 복원                          │
│  - 다기기 동기화                          │
│  - 장기 보관                             │
└──────────────────────────────────────┘
              ↕ (향후)
┌──────────────────────────────────────┐
│    자체 백엔드 (PostgreSQL/MongoDB)   │
│  - 고급 기능                             │
│  - 데이터 분석                            │
│  - 확장성                                 │
└──────────────────────────────────────┘
```

---

## 💾 로컬 데이터베이스 스키마 (Hive/Isar)

### 1. Conversation (대화 내역)

```dart
@HiveType(typeId: 0)
class Conversation {
  @HiveField(0)
  final String id;                    // 고유 ID
  
  @HiveField(1)
  final String contactId;             // 연락처 ID
  
  @HiveField(2)
  final String platform;              // 플랫폼 (sms, kakao, discord 등)
  
  @HiveField(3)
  final List<Message> messages;       // 메시지 리스트
  
  @HiveField(4)
  final DateTime lastMessageAt;       // 마지막 메시지 시간
  
  @HiveField(5)
  final bool isPinned;                // 고정 여부
  
  @HiveField(6)
  final String? encryptedData;        // 암호화된 민감 데이터
  
  @HiveField(7)
  final DateTime createdAt;           // 생성 시간
  
  @HiveField(8)
  final DateTime updatedAt;           // 업데이트 시간
  
  @HiveField(9)
  final SyncStatus syncStatus;        // 동기화 상태
}

@HiveType(typeId: 1)
class Message {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String conversationId;
  
  @HiveField(2)
  final String content;               // 메시지 내용
  
  @HiveField(3)
  final MessageType type;             // 발신/수신
  
  @HiveField(4)
  final DateTime timestamp;
  
  @HiveField(5)
  final bool isRead;
  
  @HiveField(6)
  final List<String>? attachments;    // 첨부파일 경로
}
```

### 2. ContactProfile (연락처 프로필)

```dart
@HiveType(typeId: 2)
class ContactProfile {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String displayName;           // 표시 이름
  
  @HiveField(2)
  final List<String> phoneNumbers;    // 전화번호 목록
  
  @HiveField(3)
  final Map<String, String> platformIds;  // 플랫폼별 ID
  
  @HiveField(4)
  final ProfileAnalysis? aiAnalysis;  // AI 분석 결과
  
  @HiveField(5)
  final List<String> tags;            // 태그 (친구, 가족, 직장 등)
  
  @HiveField(6)
  final int interactionCount;         // 상호작용 횟수
  
  @HiveField(7)
  final DateTime lastInteractionAt;   // 마지막 상호작용
  
  @HiveField(8)
  final RelationshipLevel relationshipLevel;  // 관계 수준
  
  @HiveField(9)
  final List<String> interests;       // 관심사
  
  @HiveField(10)
  final ConversationTone preferredTone;  // 선호하는 대화 톤
  
  @HiveField(11)
  final String? profileImagePath;     // 프로필 이미지
  
  @HiveField(12)
  final DateTime createdAt;
  
  @HiveField(13)
  final DateTime updatedAt;
  
  @HiveField(14)
  final SyncStatus syncStatus;
}

@HiveType(typeId: 3)
class ProfileAnalysis {
  @HiveField(0)
  final String summary;               // 요약
  
  @HiveField(1)
  final Map<String, dynamic> traits;  // 특성 (친근함, 정중함 등)
  
  @HiveField(2)
  final List<String> topics;          // 주요 대화 주제
  
  @HiveField(3)
  final DateTime analyzedAt;          // 분석 시간
  
  @HiveField(4)
  final double confidence;            // 분석 신뢰도
}
```

### 3. AIRecommendation (AI 추천 기록)

```dart
@HiveType(typeId: 4)
class AIRecommendation {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String conversationId;
  
  @HiveField(2)
  final String messageId;             // 관련 메시지 ID
  
  @HiveField(3)
  final List<String> recommendedMessages;  // 추천 메시지 목록
  
  @HiveField(4)
  final RecommendationType type;      // 메시지, 물건, 여행지 등
  
  @HiveField(5)
  final Map<String, dynamic> context; // 컨텍스트 정보
  
  @HiveField(6)
  final bool wasUsed;                 // 사용 여부
  
  @HiveField(7)
  final String? userModifiedVersion;  // 사용자 수정 버전
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final bool isOffline;               // 오프라인 모드 생성 여부
}
```

### 4. CallRecord (통화 기록)

```dart
@HiveType(typeId: 5)
class CallRecord {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String contactId;
  
  @HiveField(2)
  final DateTime callStartedAt;
  
  @HiveField(3)
  final DateTime? callEndedAt;
  
  @HiveField(4)
  final Duration duration;
  
  @HiveField(5)
  final CallType type;                // 발신/수신/부재중
  
  @HiveField(6)
  final String? audioFilePath;        // 녹음 파일 경로
  
  @HiveField(7)
  final String? transcript;           // 텍스트 변환 내용
  
  @HiveField(8)
  final CallAnalysis? analysis;       // AI 분석 결과
  
  @HiveField(9)
  final List<String> keyPoints;       // 주요 내용 요약
  
  @HiveField(10)
  final DateTime createdAt;
  
  @HiveField(11)
  final SyncStatus syncStatus;
}

@HiveType(typeId: 6)
class CallAnalysis {
  @HiveField(0)
  final String summary;
  
  @HiveField(1)
  final List<String> actionItems;     // 할 일 항목
  
  @HiveField(2)
  final List<String> mentionedItems;  // 언급된 물건/장소
  
  @HiveField(3)
  final Map<String, dynamic> sentiment;  // 감정 분석
  
  @HiveField(4)
  final DateTime analyzedAt;
}
```

### 5. AppSettings (앱 설정)

```dart
@HiveType(typeId: 7)
class AppSettings {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String languageCode;          // 언어 코드 (ko, en)
  
  @HiveField(2)
  final ThemeMode themeMode;          // 라이트/다크/시스템
  
  @HiveField(3)
  final bool enableAutoSync;          // 자동 동기화
  
  @HiveField(4)
  final bool enableCallRecording;     // 통화 녹음 활성화
  
  @HiveField(5)
  final bool enableOfflineMode;       // 오프라인 모드
  
  @HiveField(6)
  final List<String> enabledPlatforms;  // 활성화된 플랫폼
  
  @HiveField(7)
  final AISettings aiSettings;        // AI 설정
  
  @HiveField(8)
  final SecuritySettings securitySettings;  // 보안 설정
  
  @HiveField(9)
  final DateTime updatedAt;
}

@HiveType(typeId: 8)
class AISettings {
  @HiveField(0)
  final AIPreference preferredAI;     // 선호 AI (Gemini, TFLite)
  
  @HiveField(1)
  final bool autoRecommend;           // 자동 추천
  
  @HiveField(2)
  final int maxRecommendations;       // 최대 추천 개수
  
  @HiveField(3)
  final Map<String, dynamic> customPrompts;  // 커스텀 프롬프트
}

@HiveType(typeId: 9)
class SecuritySettings {
  @HiveField(0)
  final bool enableBiometricAuth;     // 생체 인증
  
  @HiveField(1)
  final bool enableAppLock;           // 앱 잠금
  
  @HiveField(2)
  final int lockTimeoutMinutes;       // 잠금 시간 제한
  
  @HiveField(3)
  final bool encryptLocalData;        // 로컬 데이터 암호화
}
```

### 6. SyncStatus (동기화 상태)

```dart
@HiveType(typeId: 10)
class SyncStatus {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final SyncState state;              // pending, syncing, synced, error
  
  @HiveField(2)
  final DateTime? lastSyncedAt;
  
  @HiveField(3)
  final DateTime? lastModifiedAt;
  
  @HiveField(4)
  final String? errorMessage;
  
  @HiveField(5)
  final int retryCount;
}
```

### 7. Indexes (인덱스 설정)

```dart
// Isar 인덱스 예시
@Collection()
class Conversation {
  @Index()
  late String contactId;
  
  @Index()
  late DateTime lastMessageAt;
  
  @Index()
  late String platform;
}

@Collection()
class ContactProfile {
  @Index()
  late String displayName;
  
  @Index()
  late DateTime lastInteractionAt;
}
```

---

## ☁️ 클라우드 데이터베이스 스키마 (Firestore)

### Collections 구조

```
users/
  {userId}/
    profile/
      displayName: string
      email: string
      createdAt: timestamp
      lastActiveAt: timestamp
    
    conversations/
      {conversationId}/
        contactId: string
        platform: string
        lastMessageAt: timestamp
        encryptedData: string          // 암호화된 메시지
        syncMetadata: object
        createdAt: timestamp
    
    contacts/
      {contactId}/
        displayName: string
        encryptedProfile: string       // 암호화된 프로필
        syncMetadata: object
        lastSyncedAt: timestamp
    
    callRecords/
      {callRecordId}/
        contactId: string
        callStartedAt: timestamp
        duration: number
        encryptedTranscript: string    // 암호화된 전사본
        syncMetadata: object
    
    syncState/
      lastFullSync: timestamp
      syncVersion: number
      deviceId: string
```

### 보안 규칙 (Firestore Security Rules)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자는 자신의 데이터만 접근 가능
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // 암호화된 데이터는 서버에서만 읽을 수 있음 (필요시)
    match /users/{userId}/conversations/{conversationId} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth.uid == userId 
                   && request.resource.data.encryptedData is string;
    }
  }
}
```

---

## 🔄 동기화 전략

### 1. 동기화 메커니즘

```
로컬 변경 감지
  ↓
변경사항 큐에 추가
  ↓
암호화 처리
  ↓
클라우드 업로드
  ↓
다른 기기 알림 (FCM)
  ↓
다른 기기에서 다운로드
  ↓
충돌 해결
  ↓
로컬 업데이트
```

### 2. 충돌 해결 전략

- **Last Write Wins**: 마지막 수정 시간 기준
- **Manual Merge**: 사용자가 선택
- **Version Control**: 버전 기반 병합

### 3. 동기화 상태 관리

```dart
enum SyncState {
  pending,      // 대기 중
  syncing,      // 동기화 중
  synced,       // 완료
  conflict,     // 충돌
  error,        // 에러
}
```

---

## 🔐 암호화 전략

### 로컬 암호화

- **알고리즘**: AES-256-GCM
- **키 관리**: Android Keystore
- **암호화 대상**:
  - 대화 내역
  - 프로필 정보
  - 통화 전사본

### 클라우드 전송

- **전송 전**: 로컬에서 암호화
- **저장**: 암호화된 상태로 클라우드 저장
- **복호화**: 다운로드 후 로컬에서만 복호화

---

## 📈 성능 최적화

### 1. 인덱싱 전략

- 자주 검색되는 필드 인덱싱
- 복합 인덱스 활용
- 쿼리 최적화

### 2. 캐싱

- 자주 접근하는 프로필 메모리 캐시
- 대화 목록 페이지네이션
- 이미지 로딩 최적화

### 3. 배치 작업

- 대량 데이터 동기화 배치 처리
- AI 분석 배치 처리
- 백그라운드 작업 최적화

---

## 🔍 검색 기능

### 로컬 검색

- 대화 내용 전체 텍스트 검색
- 연락처 이름 검색
- 태그 기반 필터링

### 클라우드 검색 (향후)

- 전체 텍스트 검색 인덱스
- AI 기반 의미 검색

---

## 📊 데이터 마이그레이션 전략

### 버전 관리

```dart
class DatabaseVersion {
  static const int currentVersion = 1;
  
  static Future<void> migrate(int fromVersion, int toVersion) async {
    // 마이그레이션 로직
  }
}
```

### 스키마 변경 대응

- 하위 호환성 유지
- 점진적 마이그레이션
- 롤백 지원

---

## ✅ 다음 단계

1. 실제 구현 코드 작성
2. 마이그레이션 스크립트 작성
3. 백업/복원 기능 설계
4. 성능 테스트 계획

