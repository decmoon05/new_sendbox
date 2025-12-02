# SendBox 프로젝트 재구축 계획

> AI 기반 개인 맞춤형 메시지 추천 서비스 - 전체 재구축 계획서

## 📋 프로젝트 개요

SendBox는 전화/메시지 답변 스트레스를 해소하기 위한 AI 어시스턴트 앱입니다. 다양한 메신저 플랫폼을 통합하고, 대화 내역을 분석하여 적절한 메시지를 추천합니다.

---

## 📚 문서 구조

이 프로젝트의 계획 문서는 다음과 같이 구성되어 있습니다:

### 1. [프로젝트 계획서](PROJECT_PLAN.md)
- 프로젝트 개요
- 핵심 요구사항
- 기술 스택
- 기본 아키텍처

### 2. [아키텍처 상세 설계](ARCHITECTURE_DESIGN.md)
- Clean Architecture 구조
- 레이어별 상세 설계
- 디자인 패턴
- 의존성 관리

### 3. [데이터베이스 스키마](DATABASE_SCHEMA.md)
- 로컬 데이터베이스 설계
- 클라우드 데이터베이스 설계
- 동기화 전략
- 암호화 전략

### 4. [AI 시스템 설계](AI_SYSTEM_DESIGN.md)
- 온라인 AI (Gemini API)
- 오프라인 AI (TensorFlow Lite)
- 프롬프트 엔지니어링
- AI 기능 상세 설계

### 5. [플랫폼 통합 전략](PLATFORM_INTEGRATION.md)
- SMS 통합
- 카카오톡 통합
- 디스코드/인스타그램/텔레그램 통합
- 페이스북/LINE/WhatsApp 등 확장 플랫폼
- 통합 인터페이스 설계

### 6. [보안 아키텍처](SECURITY_ARCHITECTURE.md)
- 암호화 전략
- 인증 및 권한
- 데이터 프라이버시
- 보안 감사

### 7. [UI/UX 디자인 시스템](UI_UX_DESIGN_SYSTEM.md)
- 디자인 원칙
- 색상 및 타이포그래피
- 컴포넌트 시스템
- 애니메이션

### 8. [개발 로드맵](DEVELOPMENT_ROADMAP.md)
- 개발 단계
- 일정 계획
- MVP 범위
- 배포 전략

### 9. [KYS - 시스템 이해 가이드](KYS.md) ⭐ **초보자 필수**
- 기술 스택 상세 설명
- 개념 이해 (대학생 수준에 맞춤)
- 각 기술의 역할과 동작 방식
- 학습 자료 추천

### 10. [개발 보안 가이드](SECURITY_GUIDE.md) 🔒
- Git 보안 규칙
- API 키 관리 방법
- 민감한 정보 보호
- 개발 시 보안 체크리스트

### 11. [고급 기능 설계](ADVANCED_FEATURES.md) 🚀
- 컨텍스트 인식 메시지 분류 (공적/사적 구분)
- 스마트 메시지 분석 (의도, 긴급도, 감정)
- 광고 및 스팸 차단
- 일정 연동 및 관리
- 보안 및 사기 차단 (런타임 스캠 감지)
- 사용자 인증 시스템 (회원가입)
- 추가 고급 기능들

### 12. [개발자 도구 추천](DEVELOPER_TOOLS.md) 🛠️
- 개발 환경 도구 (IDE, 에디터)
- 디자인 및 UI 도구
- API 개발 및 테스트 도구
- 배포 및 CI/CD 플랫폼
- 모니터링 및 분석 도구
- 협업 도구
- 비용별 추천 가이드

### 13. [무료 도구만으로 시작하기](FREE_SETUP_GUIDE.md) 💰
- 완전 무료 도구 구성
- 단계별 설치 가이드
- 초기 설정 체크리스트
- 무료 플랜 제한 및 대응
- 개발 시작 가이드

### 14. [왜 Flutter인가?](WHY_FLUTTER.md) 🎯
- Flutter vs React Native 비교
- SendBox 프로젝트에 Flutter가 적합한 이유
- 성능, UI/UX, 개발 생산성 분석

### 15. [Git 설정 가이드](GIT_SETUP.md) 📝
- Git 초기화
- GitHub 연동
- 커밋 및 푸시 방법

### 16. [FVM 가이드](FVM_GUIDE.md) 🔧
- Flutter 버전 관리 도구
- 프로젝트별 버전 고정
- 설치 및 사용 방법

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
- ✅ 높은 보안 수준
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

---

## 🚀 개발 단계

1. **Phase 1**: 기초 인프라 구축 (4주)
2. **Phase 2**: 핵심 기능 개발 (6주)
3. **Phase 3**: 확장 기능 (6주)
4. **Phase 4**: 고급 기능 및 개선 (4주)
5. **Phase 5**: 안정화 및 배포 준비 (4주)

**총 예상 기간**: 24주 (6개월)

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

## 🔄 다음 단계

1. 사용자 승인 후 프로젝트 초기화
2. Phase 1 개발 시작
3. 정기적인 진행 상황 리뷰

---

## 📄 라이선스

[라이선스 정보]

---

## 👥 팀

Team 전메추
- 202202567 김영석
- 202202567 이윤기
- 202202599 변경록
- 202202603 송유진

---

**상세한 내용은 각 문서를 참고하세요.**

