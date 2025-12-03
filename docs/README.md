# SendBox 문서 디렉토리

> 문서 구조 및 사용 가이드

## 📁 디렉토리 구조

```
docs/
├── 01-for-ai/          # AI가 반드시 봐야하는 파일
├── 02-for-developers/  # 개발자가 봐야하는 파일
└── 99-archive/         # 아카이브 (임시 작업 파일)
```

---

## 🤖 01-for-ai/ - AI 필수 문서

AI가 프로젝트를 이해하고 코드를 생성하기 위해 **반드시** 확인해야 하는 문서들입니다.

### 핵심 아키텍처
- [ARCHITECTURE.md](01-for-ai/ARCHITECTURE.md) - Clean Architecture 상세 설계
- [DATABASE_SCHEMA.md](01-for-ai/DATABASE_SCHEMA.md) - 데이터베이스 스키마
- [SCALABILITY.md](01-for-ai/SCALABILITY.md) - 확장성 및 유연성 원칙

### 시스템 설계
- [AI_SYSTEM.md](01-for-ai/AI_SYSTEM.md) - AI 시스템 설계 (온라인/오프라인)
- [PLATFORM_INTEGRATION.md](01-for-ai/PLATFORM_INTEGRATION.md) - 플랫폼 통합 전략
- [SECURITY.md](01-for-ai/SECURITY.md) - 보안 아키텍처

### UI/UX 및 기능
- [UI_UX_DESIGN.md](01-for-ai/UI_UX_DESIGN.md) - UI/UX 디자인 시스템
- [ADVANCED_FEATURES.md](01-for-ai/ADVANCED_FEATURES.md) - 고급 기능 설계

### 프로젝트 계획
- [PROJECT_PLAN.md](01-for-ai/PROJECT_PLAN.md) - 프로젝트 계획 및 요구사항
- [ROADMAP.md](01-for-ai/ROADMAP.md) - 개발 로드맵

**이 폴더의 문서는 AI가 코드 생성 시 항상 참고해야 합니다.**

---

## 👨‍💻 02-for-developers/ - 개발자 가이드

개발자가 프로젝트를 시작하고 개발하는 데 필요한 문서들입니다.

### 시작 가이드
- [GETTING_STARTED.md](02-for-developers/GETTING_STARTED.md) - 개발 환경 설정 및 시작
- [KYS.md](02-for-developers/KYS.md) - 시스템 이해 가이드 (초보자용)

### 개발 도구
- [DEVELOPER_TOOLS.md](02-for-developers/DEVELOPER_TOOLS.md) - 개발 도구 추천
- [GIT_GUIDE.md](02-for-developers/GIT_GUIDE.md) - Git 사용 가이드
- [COMMIT_MESSAGES.md](02-for-developers/COMMIT_MESSAGES.md) - 커밋 메시지 규칙

### 참고 자료
- [WHY_FLUTTER.md](02-for-developers/WHY_FLUTTER.md) - Flutter 선택 이유
- [SECURITY_GUIDE.md](02-for-developers/SECURITY_GUIDE.md) - 개발 보안 가이드

---

## 📦 99-archive/ - 아카이브

임시 작업 파일이나 과거 작업 기록입니다. 참고용으로만 보관합니다.

- [PROJECT_SETUP_HISTORY.md](99-archive/PROJECT_SETUP_HISTORY.md) - 프로젝트 설정 과정 기록

---

## 📖 문서 읽는 순서

### 새로운 AI가 프로젝트 이해하기
1. 루트 [README.md](../README.md)
2. [01-for-ai/PROJECT_PLAN.md](01-for-ai/PROJECT_PLAN.md)
3. [01-for-ai/ARCHITECTURE.md](01-for-ai/ARCHITECTURE.md)
4. [01-for-ai/SCALABILITY.md](01-for-ai/SCALABILITY.md)

### 새로운 개발자 시작하기
1. 루트 [README.md](../README.md)
2. [02-for-developers/GETTING_STARTED.md](02-for-developers/GETTING_STARTED.md)
3. [02-for-developers/KYS.md](02-for-developers/KYS.md)

---

**문서 구조가 명확하게 정리되어 있습니다!** 📚

