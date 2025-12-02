# SendBox 프로젝트 재구축 계획서

## 📋 프로젝트 개요

**SendBox** - AI 기반 개인 맞춤형 메시지 추천 서비스
- 전화/메시지 답변 스트레스 해소를 위한 AI 어시스턴트
- 다양한 메신저 플랫폼 통합
- 대화 기반 인물 분석 및 프로필 관리

---

## 🎯 핵심 요구사항

### 기능 요구사항
1. ✅ AI 메시지 추천 (대화 내역 기반)
2. ✅ 다중 플랫폼 통합 
   - SMS, 카카오톡, 디스코드, 인스타그램, 텔레그램
   - 페이스북 메신저, LINE, WhatsApp
   - Slack, Microsoft Teams
   - WeChat, Signal, Viber, Snapchat 등 확장 가능
3. ✅ 개인 프로필 관리 및 AI 인물 분석
4. ✅ 대화 중 AI 추천 (물건, 여행지 등)
5. ✅ 친구 내역 정리 및 통합
6. ✅ 전화 통화 내용 분석 및 통합
7. ✅ 다국어 지원 (한국어, 영어, 확장 가능)
8. ✅ 고급 UI/UX (미니멀 + 애플 스타일 애니메이션)

### 비기능 요구사항
1. ✅ 하이브리드 데이터 저장 (로컬 + 클라우드)
2. ✅ 오프라인 모드 완전 지원
3. ✅ 높은 보안 수준 (대기업 SNS 수준)
4. ✅ 확장성 (소규모 → 대규모 배포 대응)
5. ✅ 에러 추적 및 모니터링
6. ✅ Android 우선 개발 (확장성 고려)

---

## 🏗️ 아키텍처 설계 (초안)

### 기술 스택 제안

#### 프론트엔드 (Flutter)
- **언어**: Dart 3.x
- **프레임워크**: Flutter 3.x (최신 안정 버전)
- **상태 관리**: Riverpod 2.x (완성도 높음, MVVM 패턴)
- **로컬 DB**: Hive + Isar (성능 최적화)
- **네트워크**: Dio + Retrofit 패턴
- **로컬화**: easy_localization
- **의존성 주입**: Riverpod (내장)

#### 백엔드/클라우드 (하이브리드 접근)
- **1차 우선**: Firebase (빠른 개발, 확장성)
  - Firestore (데이터베이스)
  - Firebase Auth (인증)
  - Firebase Storage (미디어)
  - Firebase Functions (서버리스)
  - Firebase Crashlytics (에러 추적 및 모니터링)
  
- **2차 확장**: 자체 백엔드 서버
  - Node.js + Express 또는 Python FastAPI
  - PostgreSQL 또는 MongoDB
  - RESTful API + GraphQL (선택적)
  - Firebase는 모니터링/크래시리틱스 + 선택적 기능 유지

#### AI 서비스
- **온라인**: Google Gemini API (주요)
- **오프라인**: TensorFlow Lite (로컬 모델 사용)
  - 경량 언어 모델 로드
  - 로컬 추론 엔진
  - 모델 업데이트 메커니즘
- **확장성**: 향후 OpenAI, Claude 등 추가 가능한 어댑터 패턴 구조

#### 보안
- **암호화**: AES-256 (로컬), TLS 1.3 (전송)
- **키 관리**: Android Keystore System
- **인증**: JWT + Refresh Token
- **데이터 보호**: 민감 정보는 로컬 암호화 후 클라우드 동기화

---

## 📁 프로젝트 구조 (제안)

```
sendbox/
├── lib/
│   ├── core/                    # 핵심 공통 기능
│   │   ├── constants/
│   │   ├── utils/
│   │   ├── errors/
│   │   ├── theme/
│   │   └── extensions/
│   │
│   ├── data/                    # 데이터 레이어
│   │   ├── datasources/         # 데이터 소스 (로컬, 원격)
│   │   ├── models/              # 데이터 모델
│   │   ├── repositories/        # 리포지토리 구현
│   │   └── services/            # 외부 서비스 연동
│   │       ├── ai/
│   │       ├── messaging/       # 메신저 통합
│   │       ├── storage/
│   │       └── sync/
│   │
│   ├── domain/                  # 비즈니스 로직
│   │   ├── entities/            # 엔티티
│   │   ├── repositories/        # 리포지토리 인터페이스
│   │   └── usecases/            # 유즈케이스
│   │
│   ├── presentation/            # UI 레이어
│   │   ├── features/            # 기능별 모듈
│   │   │   ├── chat/           # 메인 채팅 화면
│   │   │   ├── profile/        # 프로필 관리
│   │   │   ├── ai_recommend/   # AI 추천
│   │   │   ├── contacts/       # 연락처 정리
│   │   │   └── settings/       # 설정
│   │   ├── widgets/            # 공통 위젯
│   │   └── providers/          # Riverpod providers
│   │
│   └── main.dart
│
├── android/                     # Android 네이티브 코드
│   ├── app/src/main/
│   │   ├── java/.../services/  # 백그라운드 서비스
│   │   └── res/
│   └── build.gradle
│
├── assets/                      # 리소스
│   ├── images/
│   ├── fonts/
│   └── l10n/                   # 다국어 파일
│
└── test/                        # 테스트
```

---

## 🔐 보안 아키텍처

### 데이터 암호화 전략
1. **로컬 저장 데이터**
   - 대화 내역: AES-256 암호화
   - 프로필 정보: AES-256 암호화
   - 암호화 키: Android Keystore에 안전하게 저장

2. **전송 데이터**
   - 모든 API 통신: TLS 1.3
   - 클라우드 동기화: 암호화된 데이터만 전송
   - API 키: 환경 변수로 관리, 빌드 시 주입

3. **인증 및 권한**
   - 생체 인증 지원 (선택적)
   - 앱 잠금 기능
   - 민감한 작업 시 재인증 요구

---

## 📊 데이터베이스 설계 (초안)

### 로컬 데이터베이스 (Hive/Isar)
- **대화 내역** (Conversation)
- **연락처 프로필** (ContactProfile)
- **AI 추천 기록** (AIRecommendation)
- **앱 설정** (AppSettings)
- **동기화 상태** (SyncStatus)

### 클라우드 데이터베이스 (Firestore/PostgreSQL)
- **사용자 계정** (User)
- **동기화된 대화** (SyncedConversation) - 암호화됨
- **프로필 백업** (ProfileBackup) - 암호화됨
- **AI 학습 데이터** (AITrainingData) - 익명화됨

---

## 🔌 플랫폼 통합 전략

### 각 플랫폼별 통합 방법

#### 1. SMS
- Android Notification Listener Service
- SMS 수신 브로드캐스트 리스너
- 직접 SMS API 사용 (권한 필요)

#### 2. 카카오톡
- 알림 텍스트 추출 (Notification Listener)
- Accessibility Service 활용
- API는 제한적이므로 주로 알림 기반

#### 3. 디스코드
- Discord Bot API (선택적)
- 알림 기반 메시지 추출
- 클립보드 연동

#### 4. 인스타그램
- 알림 기반
- 웹뷰 통합 (선택적)
- 클립보드 연동

#### 5. 텔레그램
- Telegram Bot API (선택적)
- 알림 기반
- 클립보드 연동

### 통합 아키텍처
- 플러그인 패턴으로 각 플랫폼별 어댑터 구현
- 통합 메시지 인터페이스로 통일
- 백그라운드 서비스로 실시간 모니터링

---

## 🤖 AI 기능 설계

### 온라인 모드
- Google Gemini API 연동
- 대화 컨텍스트 관리
- 프롬프트 엔지니어링 최적화
- 스트리밍 응답 지원

### 오프라인 모드
- TensorFlow Lite 로컬 모델 사용
- 로컬 추론 엔진으로 실시간 추천
- 캐시된 컨텍스트 활용
- 제한적 기능 제공 (기본 추천 가능)

### AI 기능 목록
1. 메시지 추천 생성
2. 인물 프로필 자동 분석
3. 대화 톤 분석 (정중함, 친근함 등)
4. 물건/여행지 추천
5. 관계 분석 및 알림

---

## 🎨 UI/UX 디자인 원칙

### 디자인 철학
- **미니멀리즘**: 불필요한 요소 제거
- **애플 스타일**: 부드러운 애니메이션, 자연스러운 인터랙션
- **일관성**: 디자인 시스템 기반 통일된 UI

### 애니메이션 전략
- Hero 애니메이션
- 페이지 전환 애니메이션
- 로딩 상태 시각화
- 마이크로 인터랙션
- 스프링 애니메이션

### 테마 시스템
- 라이트/다크 모드 지원
- 동적 색상 시스템
- 커스터마이징 가능

---

## 📱 개발 단계 계획

### Phase 1: 기초 인프라 구축
- [ ] 프로젝트 초기 설정
- [ ] 아키텍처 구조 생성
- [ ] 상태 관리 설정 (Riverpod)
- [ ] 테마 시스템 구축
- [ ] 로컬 데이터베이스 설정

### Phase 2: 핵심 기능
- [ ] SMS 통합
- [ ] 기본 AI 추천 기능
- [ ] 프로필 관리
- [ ] 대화 내역 저장

### Phase 3: 확장 기능
- [ ] 추가 메신저 통합
- [ ] 클라우드 동기화
- [ ] 오프라인 모드
- [ ] 전화 통화 통합

### Phase 4: 고급 기능
- [ ] AI 인물 분석 고도화
- [ ] 추천 시스템 확장
- [ ] 다국어 지원
- [ ] 고급 UI/UX

### Phase 5: 안정화 및 배포
- [ ] 테스트 및 버그 수정
- [ ] 성능 최적화
- [ ] 보안 감사
- [ ] 스토어 등록 준비

---

## ❓ 추가 결정 필요 사항

다음 항목들에 대한 결정이 필요합니다:

1. **전화 통화 통합 방법**: 녹음 vs 수동 입력 vs 기록 분석
2. **오프라인 AI 처리**: 로컬 모델 vs 패턴 기반
3. **클라우드 서비스 선택**: Firebase vs 자체 백엔드
4. **모니터링 도구**: Firebase Crashlytics vs Sentry
5. **초기 지원 언어**: 한국어 + 영어 vs 추가 언어
6. **MVP 범위**: 최소 기능 세트 정의

---

## 📝 다음 단계

사용자의 추가 답변을 기다리며:
- 상세 아키텍처 문서 작성
- 데이터베이스 스키마 상세 설계
- API 명세서 작성
- UI/UX 와이어프레임 계획
- 보안 상세 계획 수립

