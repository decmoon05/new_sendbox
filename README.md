# SendBox 프로젝트 재구축

> AI 기반 개인 맞춤형 메시지 추천 서비스 - 전체 재구축 계획서

## 📋 프로젝트 개요

SendBox는 전화/메시지 답변 스트레스를 해소하기 위한 AI 어시스턴트 앱입니다. 다양한 메신저 플랫폼을 통합하고, 대화 내역을 분석하여 적절한 메시지를 추천합니다.

---

## 📚 문서 구조

프로젝트 문서는 **목적별로 체계적으로 정리**되어 있습니다:

### 🤖 [AI 필수 문서](docs/01-for-ai/) - AI가 반드시 봐야하는 문서

AI가 프로젝트를 이해하고 코드를 생성하기 위해 필요한 핵심 문서들입니다.

- **[프로젝트 계획서](docs/01-for-ai/PROJECT_PLAN.md)** - 프로젝트 개요, 요구사항, 기술 스택
- **[아키텍처 설계](docs/01-for-ai/ARCHITECTURE.md)** - Clean Architecture 구조
- **[데이터베이스 스키마](docs/01-for-ai/DATABASE_SCHEMA.md)** - 데이터베이스 설계
- **[AI 시스템 설계](docs/01-for-ai/AI_SYSTEM.md)** - AI 시스템 (온라인/오프라인)
- **[플랫폼 통합](docs/01-for-ai/PLATFORM_INTEGRATION.md)** - 14개 플랫폼 통합 전략
- **[보안 아키텍처](docs/01-for-ai/SECURITY.md)** - 보안 설계
- **[UI/UX 디자인](docs/01-for-ai/UI_UX_DESIGN.md)** - 디자인 시스템
- **[고급 기능](docs/01-for-ai/ADVANCED_FEATURES.md)** - 고급 기능 설계
- **[확장성 원칙](docs/01-for-ai/SCALABILITY.md)** - 확장 가능한 코드 작성 가이드
- **[개발 로드맵](docs/01-for-ai/ROADMAP.md)** - 개발 일정

### 👨‍💻 [개발자 가이드](docs/02-for-developers/) - 개발자가 봐야하는 문서

개발자가 프로젝트를 시작하고 개발하는 데 필요한 문서들입니다.

- **[시작 가이드](docs/02-for-developers/GETTING_STARTED.md)** ⭐ **첫 시작 필수**
- **[시스템 이해 가이드 (KYS)](docs/02-for-developers/KYS.md)** - 초보자 필수
- **[Git 가이드](docs/02-for-developers/GIT_GUIDE.md)** - Git 사용법
- **[커밋 메시지 규칙](docs/02-for-developers/COMMIT_MESSAGES.md)** - 영어 커밋 규칙
- **[개발자 도구](docs/02-for-developers/DEVELOPER_TOOLS.md)** - 도구 추천
- **[보안 가이드](docs/02-for-developers/SECURITY_GUIDE.md)** - 개발 보안
- **[Flutter 선택 이유](docs/02-for-developers/WHY_FLUTTER.md)** - 기술 선택 배경

### 📦 [아카이브](docs/99-archive/) - 참고용

임시 작업 파일이나 과거 작업 기록입니다. 참고용으로만 보관합니다.

---

## 🚀 빠른 시작

### 새로운 개발자라면:

1. **[개발 시작 가이드](docs/02-for-developers/GETTING_STARTED.md)** 읽기
2. **[시스템 이해 가이드 (KYS)](docs/02-for-developers/KYS.md)** 읽기
3. 개발 환경 설정
4. 개발 시작!

### AI가 프로젝트를 이해한다면:

1. **[프로젝트 계획서](docs/01-for-ai/PROJECT_PLAN.md)** 읽기
2. **[아키텍처 설계](docs/01-for-ai/ARCHITECTURE.md)** 읽기
3. **[확장성 원칙](docs/01-for-ai/SCALABILITY.md)** 읽기
4. 코드 생성 시작!

**자세한 문서 구조:** [docs/README.md](docs/README.md)

---

## 🎯 핵심 기능

### 필수 기능
- ✅ AI 메시지 추천 (대화 내역 기반)
- ✅ 다중 플랫폼 통합 
  - **핵심**: SMS, 카카오톡, 디스코드, 인스타그램, 텔레그램
  - **확장**: 페이스북 메신저, LINE, WhatsApp, Slack, Microsoft Teams
  - **기타**: WeChat, Signal, Viber, Snapchat 등 (확장 가능)
- ✅ 개인 프로필 관리 및 AI 인물 분석
- ✅ 대화 중 AI 추천 (물건, 여행지 등)
- ✅ 친구 내역 정리 및 통합
- ✅ 전화 통화 내용 분석 및 통합
- ✅ 다국어 지원 (한국어, 영어, 확장 가능)
- ✅ 고급 UI/UX (미니멀 + 애플 스타일)

### 비기능 요구사항
- ✅ 하이브리드 데이터 저장 (로컬 + 클라우드)
- ✅ 오프라인 모드 완전 지원 (로컬 AI 모델)
- ✅ 높은 보안 수준 (대기업 SNS 수준)
- ✅ 확장성 (소규모 → 대규모)
- ✅ 에러 추적 및 모니터링

---

## 🏗️ 기술 스택

### 프론트엔드
- **Flutter 3.24+** - 크로스 플랫폼 프레임워크
- **Dart 3.3+** - 프로그래밍 언어
- **Riverpod 2.5+** - 상태 관리
- **Isar 3.1+** - 로컬 데이터베이스
- **Dio 5.4+** - HTTP 클라이언트

### 백엔드/클라우드
- **Firebase** (주요)
  - Firestore
  - Firebase Auth
  - Firebase Storage
  - Firebase Crashlytics
- **자체 백엔드** (확장)

### AI
- **Google Gemini API** (온라인)
- **TensorFlow Lite** (오프라인)

---

## 📁 프로젝트 구조

```
sendbox/
├── lib/
│   ├── core/                    # 핵심 공통 기능
│   ├── data/                    # 데이터 레이어
│   ├── domain/                  # 도메인 레이어
│   └── presentation/            # 프레젠테이션 레이어
├── android/                     # Android 네이티브
├── assets/                      # 리소스
├── docs/                        # 문서
│   ├── 01-for-ai/              # AI 필수 문서
│   ├── 02-for-developers/      # 개발자 가이드
│   └── 99-archive/             # 아카이브
└── test/                        # 테스트
```

---

## 🔐 보안

- AES-256-GCM 암호화 (로컬 데이터)
- Android Keystore (키 관리)
- TLS 1.3 (전송 보안)
- JWT + Refresh Token (인증)
- 생체 인증 지원
- 앱 잠금 기능

**자세한 내용:** [보안 아키텍처](docs/01-for-ai/SECURITY.md) | [개발 보안 가이드](docs/02-for-developers/SECURITY_GUIDE.md)

---

## 🚀 개발 단계

1. **Phase 1**: 기초 인프라 구축 (4주)
2. **Phase 2**: 핵심 기능 개발 (6주)
3. **Phase 3**: 확장 기능 (6주)
4. **Phase 4**: 고급 기능 및 개선 (4주)
5. **Phase 5**: 안정화 및 배포 준비 (4주)

**총 예상 기간**: 24주 (6개월)

**자세한 일정:** [개발 로드맵](docs/01-for-ai/ROADMAP.md)

---

## 📝 주요 결정 사항

### 아키텍처
- **Clean Architecture** + Feature 모듈
- **MVVM 패턴** (Riverpod)
- **Repository 패턴**
- **Adapter 패턴** (AI, 메신저 플랫폼)

### 데이터 저장
- **로컬**: Isar (Hive 대안)
- **클라우드**: Firebase Firestore
- **동기화**: 하이브리드 전략

### AI 시스템
- **온라인 우선**: Google Gemini API
- **오프라인 Fallback**: TensorFlow Lite
- **자동 전환**: 네트워크 상태 기반

### 통합 방식
- **SMS**: Notification Listener + Broadcast Receiver
- **카카오톡**: Notification Listener (주요)
- **디스코드/텔레그램**: Notification Listener + Bot API (선택적)
- **기타 플랫폼**: Notification Listener 기반 (페이스북, LINE, WhatsApp 등)
- **엔터프라이즈**: 공식 API 활용 (Slack, Microsoft Teams)

### 통화 통합
- **자동 통화 녹음**
- **Speech-to-Text 변환**
- **AI 분석 및 문서화**

---

## 🎨 UI/UX 원칙

- **미니멀리즘**: 불필요한 요소 제거
- **애플 스타일**: 부드러운 애니메이션
- **일관성**: 통일된 디자인 시스템
- **접근성**: 모든 사용자 접근 가능

**자세한 내용:** [UI/UX 디자인 시스템](docs/01-for-ai/UI_UX_DESIGN.md)

---

## 📊 MVP 범위

### 포함
- SMS 통합
- 기본 AI 메시지 추천
- 프로필 관리 (기본)
- 로컬 저장

### 제외 (후속 단계)
- 클라우드 동기화
- 오프라인 AI
- 추가 메신저
- 통화 기능

---

## 📖 문서 읽는 순서

### 새로운 개발자
1. 이 README.md
2. [개발 시작 가이드](docs/02-for-developers/GETTING_STARTED.md)
3. [시스템 이해 가이드 (KYS)](docs/02-for-developers/KYS.md)

### AI가 프로젝트 이해하기
1. 이 README.md
2. [프로젝트 계획서](docs/01-for-ai/PROJECT_PLAN.md)
3. [아키텍처 설계](docs/01-for-ai/ARCHITECTURE.md)
4. [확장성 원칙](docs/01-for-ai/SCALABILITY.md)

---

## 🔄 다음 단계

1. ✅ 문서 정리 완료
2. ⏳ 사용자 승인 후 프로젝트 초기화
3. ⏳ Phase 1 개발 시작
4. ⏳ 정기적인 진행 상황 리뷰

---

## 📄 라이선스

[라이선스 정보](LICENSE)

---

## 👥 팀

Team 전메추
- 202202567 김영석
- 202202567 이윤기
- 202202599 변경록
- 202202603 송유진

---

**📚 모든 문서는 `docs/` 폴더에서 확인할 수 있습니다.**

**🚀 개발 시작은 [개발 시작 가이드](docs/02-for-developers/GETTING_STARTED.md)를 참고하세요!**
