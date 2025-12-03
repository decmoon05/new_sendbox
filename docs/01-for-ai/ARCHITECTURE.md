# SendBox 아키텍처 상세 설계 문서

## 📐 Clean Architecture + Feature 모듈 구조

### 아키텍처 레이어

```
┌─────────────────────────────────────────┐
│        Presentation Layer               │
│  (UI, Widgets, State Management)        │
├─────────────────────────────────────────┤
│          Domain Layer                   │
│  (Entities, UseCases, Repository IF)    │
├─────────────────────────────────────────┤
│           Data Layer                    │
│  (Repositories, DataSources, Models)    │
├─────────────────────────────────────────┤
│         Infrastructure                  │
│  (Network, Storage, Platform Services)  │
└─────────────────────────────────────────┘
```

---

## 🏛️ 상세 프로젝트 구조

```
sendbox/
├── lib/
│   │
│   ├── core/                              # 핵심 공통 기능
│   │   ├── constants/
│   │   │   ├── app_constants.dart        # 앱 상수
│   │   │   ├── api_constants.dart        # API 엔드포인트
│   │   │   └── storage_keys.dart         # 저장소 키
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.dart           # 유효성 검사
│   │   │   ├── formatters.dart           # 포맷터
│   │   │   ├── date_utils.dart           # 날짜 유틸
│   │   │   └── encryption_utils.dart     # 암호화 유틸
│   │   │
│   │   ├── errors/
│   │   │   ├── exceptions.dart           # 예외 정의
│   │   │   ├── failures.dart             # 실패 타입
│   │   │   └── error_handler.dart        # 에러 핸들러
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart            # 테마 설정
│   │   │   ├── app_colors.dart           # 색상 시스템
│   │   │   ├── app_text_styles.dart      # 텍스트 스타일
│   │   │   └── app_animations.dart       # 애니메이션 상수
│   │   │
│   │   ├── extensions/
│   │   │   ├── string_extensions.dart
│   │   │   ├── datetime_extensions.dart
│   │   │   └── context_extensions.dart
│   │   │
│   │   ├── network/
│   │   │   ├── api_client.dart           # API 클라이언트
│   │   │   ├── interceptors.dart         # 인터셉터
│   │   │   └── network_info.dart         # 네트워크 상태
│   │   │
│   │   └── di/                           # 의존성 주입 설정
│   │       ├── injection_container.dart
│   │       └── providers.dart
│   │
│   ├── data/                              # 데이터 레이어
│   │   ├── datasources/
│   │   │   ├── local/
│   │   │   │   ├── conversation_local_ds.dart
│   │   │   │   ├── profile_local_ds.dart
│   │   │   │   ├── settings_local_ds.dart
│   │   │   │   └── encryption_ds.dart
│   │   │   │
│   │   │   └── remote/
│   │   │       ├── firebase_datasource.dart
│   │   │       ├── api_datasource.dart
│   │   │       └── sync_datasource.dart
│   │   │
│   │   ├── models/
│   │   │   ├── conversation_model.dart
│   │   │   ├── contact_profile_model.dart
│   │   │   ├── ai_recommendation_model.dart
│   │   │   ├── call_record_model.dart
│   │   │   └── sync_status_model.dart
│   │   │
│   │   ├── repositories/
│   │   │   ├── conversation_repository_impl.dart
│   │   │   ├── profile_repository_impl.dart
│   │   │   ├── ai_repository_impl.dart
│   │   │   └── sync_repository_impl.dart
│   │   │
│   │   └── services/
│   │       ├── ai/
│   │       │   ├── gemini_service.dart
│   │       │   ├── tensorflow_service.dart  # 오프라인 AI
│   │       │   ├── ai_adapter.dart          # 어댑터 패턴
│   │       │   └── prompt_builder.dart
│   │       │
│   │       ├── messaging/
│   │       │   ├── sms_service.dart
│   │       │   ├── kakao_adapter.dart
│   │       │   ├── discord_adapter.dart
│   │       │   ├── instagram_adapter.dart
│   │       │   ├── telegram_adapter.dart
│   │       │   └── messaging_interface.dart
│   │       │
│   │       ├── storage/
│   │       │   ├── hive_storage.dart
│   │       │   ├── firebase_storage.dart
│   │       │   └── encryption_service.dart
│   │       │
│   │       ├── sync/
│   │       │   ├── sync_service.dart
│   │       │   └── conflict_resolver.dart
│   │       │
│   │       ├── call/
│   │       │   ├── call_recorder_service.dart
│   │       │   ├── speech_to_text_service.dart
│   │       │   └── call_analyzer.dart
│   │       │
│   │       └── notification/
│   │           └── notification_listener_service.dart
│   │
│   ├── domain/                            # 도메인 레이어
│   │   ├── entities/
│   │   │   ├── conversation.dart
│   │   │   ├── contact_profile.dart
│   │   │   ├── ai_recommendation.dart
│   │   │   ├── call_record.dart
│   │   │   └── message.dart
│   │   │
│   │   ├── repositories/
│   │   │   ├── conversation_repository.dart
│   │   │   ├── profile_repository.dart
│   │   │   ├── ai_repository.dart
│   │   │   └── sync_repository.dart
│   │   │
│   │   └── usecases/
│   │       ├── conversation/
│   │       │   ├── get_conversations.dart
│   │       │   ├── save_conversation.dart
│   │       │   └── delete_conversation.dart
│   │       │
│   │       ├── profile/
│   │       │   ├── get_profile.dart
│   │       │   ├── update_profile.dart
│   │       │   └── analyze_profile.dart
│   │       │
│   │       ├── ai/
│   │       │   ├── get_message_recommendation.dart
│   │       │   ├── analyze_conversation.dart
│   │       │   └── get_item_recommendation.dart
│   │       │
│   │       └── sync/
│   │           ├── sync_to_cloud.dart
│   │           └── sync_from_cloud.dart
│   │
│   ├── presentation/                      # 프레젠테이션 레이어
│   │   ├── features/
│   │   │   │
│   │   │   ├── chat/                     # 메인 채팅 기능
│   │   │   │   ├── data/
│   │   │   │   │   └── models/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── entities/
│   │   │   │   │   └── usecases/
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── pages/
│   │   │   │   │   │   └── chat_page.dart
│   │   │   │   │   ├── widgets/
│   │   │   │   │   │   ├── message_bubble.dart
│   │   │   │   │   │   └── ai_recommendation_card.dart
│   │   │   │   │   └── providers/
│   │   │   │   │       └── chat_provider.dart
│   │   │   │   └── chat_module.dart
│   │   │   │
│   │   │   ├── profile/                  # 프로필 관리
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── pages/
│   │   │   │   │   │   ├── profile_list_page.dart
│   │   │   │   │   │   └── profile_detail_page.dart
│   │   │   │   │   ├── widgets/
│   │   │   │   │   └── providers/
│   │   │   │   └── profile_module.dart
│   │   │   │
│   │   │   ├── ai_recommend/             # AI 추천
│   │   │   │   └── presentation/
│   │   │   │       ├── pages/
│   │   │   │       ├── widgets/
│   │   │   │       └── providers/
│   │   │   │
│   │   │   ├── contacts/                 # 연락처 정리
│   │   │   │   └── presentation/
│   │   │   │
│   │   │   ├── call_history/             # 통화 기록
│   │   │   │   └── presentation/
│   │   │   │
│   │   │   └── settings/                 # 설정
│   │   │       └── presentation/
│   │   │
│   │   ├── widgets/                      # 공통 위젯
│   │   │   ├── buttons/
│   │   │   ├── inputs/
│   │   │   ├── cards/
│   │   │   ├── animations/
│   │   │   └── loading/
│   │   │
│   │   └── routes/                       # 라우팅
│   │       ├── app_router.dart
│   │       └── route_names.dart
│   │
│   └── main.dart
│
├── android/
│   └── app/src/main/
│       ├── java/com/sendbox/
│       │   ├── services/
│       │   │   ├── NotificationListenerService.kt
│       │   │   ├── CallRecordingService.kt
│       │   │   └── BackgroundSyncService.kt
│       │   ├── receivers/
│       │   │   ├── SmsReceiver.kt
│       │   │   └── BootReceiver.kt
│       │   └── utils/
│       │       └── EncryptionHelper.kt
│       └── res/
│
├── assets/
│   ├── images/
│   ├── fonts/
│   ├── l10n/                            # 다국어
│   │   ├── en/
│   │   │   └── messages.arb
│   │   └── ko/
│   │       └── messages.arb
│   └── models/                          # TensorFlow Lite 모델
│       └── ai_model.tflite
│
├── test/                                # 테스트
│   ├── unit/
│   ├── widget/
│   └── integration/
│
└── docs/                                # 문서
    ├── api/
    └── architecture/
```

---

## 🔄 의존성 방향 (Dependency Rule)

```
Presentation → Domain ← Data
     ↓           ↑
  (UI only)  (Business Logic)
              (Entities)
```

- **Domain Layer**: 외부 의존성 없음 (순수 Dart)
- **Data Layer**: Domain을 구현
- **Presentation Layer**: Domain만 의존

---

## 📦 주요 디자인 패턴

### 1. Repository Pattern
- 데이터 소스 추상화
- 로컬/원격 데이터 소스 통합 관리
- 테스트 용이성 향상

### 2. UseCase Pattern
- 단일 책임 원칙
- 비즈니스 로직 캡슐화
- 재사용성 증가

### 3. Adapter Pattern
- AI 서비스 스위칭 (Gemini ↔ TensorFlow Lite)
- 메신저 플랫폼 통합

### 4. Factory Pattern
- 서비스 생성
- 모델 변환

### 5. Observer Pattern
- Riverpod으로 상태 관찰
- 이벤트 스트림 처리

### 6. Strategy Pattern
- 암호화 전략
- 동기화 전략
- AI 추천 전략

---

## 🔌 플러그인 아키텍처

### 메신저 통합 인터페이스

```dart
abstract class MessagingPlatformAdapter {
  Future<List<Message>> getRecentMessages();
  Future<void> sendMessage(String to, String content);
  Stream<Message> listenToMessages();
  bool isPlatformAvailable();
}
```

각 플랫폼별 어댑터 구현:
- `SmsAdapter`
- `KakaoAdapter`
- `DiscordAdapter`
- `InstagramAdapter`
- `TelegramAdapter`

---

## 🗄️ 데이터 흐름

### 1. 메시지 수신 → AI 추천 흐름

```
메시지 수신
  ↓
NotificationListenerService (Android)
  ↓
MessagingPlatformAdapter
  ↓
SaveConversationUseCase
  ↓
ConversationRepository
  ↓
GetMessageRecommendationUseCase
  ↓
AIRepository (Gemini/TFLite)
  ↓
UI 업데이트 (Riverpod)
```

### 2. 동기화 흐름

```
로컬 변경 감지
  ↓
SyncService
  ↓
암호화 처리
  ↓
Firebase/자체 백엔드 업로드
  ↓
다른 기기 동기화
```

---

## 🔐 보안 계층

1. **애플리케이션 레벨**
   - 코드 난독화
   - Root/탈옥 탐지
   - 디버깅 방지

2. **데이터 레벨**
   - AES-256 암호화
   - Android Keystore 키 관리

3. **전송 레벨**
   - TLS 1.3
   - 인증서 고정

4. **인증 레벨**
   - JWT + Refresh Token
   - 생체 인증

---

## 🌐 다국어 지원 구조

- **초기**: 한국어, 영어
- **확장 가능**: `easy_localization` 사용
- 구조:
  ```
  assets/l10n/
  ├── en/
  │   └── messages.arb
  ├── ko/
  │   └── messages.arb
  └── (향후 추가 언어)
  ```
- 모든 텍스트는 localization 키로 관리

---

## 🚀 성능 최적화 전략

1. **로컬 캐싱**
   - 자주 사용하는 데이터 메모리 캐시
   - 이미지/프로필 캐싱

2. **Lazy Loading**
   - 대화 내역 페이지네이션
   - 이미지 지연 로딩

3. **백그라운드 처리**
   - AI 분석 비동기 처리
   - 동기화 백그라운드 실행

4. **데이터베이스 최적화**
   - 인덱싱
   - 쿼리 최적화

---

## 📱 플랫폼 특화 기능

### Android 네이티브 서비스

1. **NotificationListenerService**
   - 실시간 알림 감지
   - 메시지 텍스트 추출

2. **CallRecordingService**
   - 통화 녹음
   - 권한 관리

3. **BackgroundSyncService**
   - 백그라운드 동기화
   - 배터리 최적화

---

## 🔄 상태 관리 (Riverpod)

### Provider 구조

```dart
// Feature-based Providers
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(...);
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(...);

// Repository Providers
final conversationRepoProvider = Provider<ConversationRepository>(...);
final aiRepoProvider = Provider<AIRepository>(...);

// Service Providers
final geminiServiceProvider = Provider<GeminiService>(...);
final syncServiceProvider = Provider<SyncService>(...);
```

---

## 📊 모니터링 및 로깅

### Firebase Crashlytics 통합

- 자동 크래시 리포트
- 커스텀 로그
- 성능 모니터링
- 사용자 여정 추적

### 로깅 레벨

```dart
enum LogLevel {
  debug,    // 개발 중
  info,     // 일반 정보
  warning,  // 경고
  error,    // 에러
  critical, // 치명적 에러
}
```

---

## ✅ 다음 단계

1. 데이터베이스 스키마 상세 설계
2. API 명세서 작성
3. UI/UX 컴포넌트 시스템 설계
4. 보안 구현 상세 계획
5. 테스트 전략 수립


