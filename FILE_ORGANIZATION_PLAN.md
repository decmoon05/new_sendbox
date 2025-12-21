# 파일 정리 계획서

> MD 파일 정리 및 분류 계획

## 📋 현재 상태

총 **26개의 MD 파일**이 루트에 있습니다.

## 🗂️ 분류 계획

### ✅ 루트에 유지할 파일
- `README.md` - 프로젝트 진입점 (필수)

---

### 📁 docs/01-for-ai/ - AI 필수 문서

AI가 프로젝트를 이해하고 코드 생성 시 **반드시** 참고해야 하는 문서들입니다.

#### 이동할 파일:
1. `ARCHITECTURE_DESIGN.md` → `ARCHITECTURE.md`
2. `DATABASE_SCHEMA.md` → 그대로 이동
3. `AI_SYSTEM_DESIGN.md` → `AI_SYSTEM.md`
4. `PLATFORM_INTEGRATION.md` → 그대로 이동
5. `SECURITY_ARCHITECTURE.md` → `SECURITY.md`
6. `UI_UX_DESIGN_SYSTEM.md` → `UI_UX_DESIGN.md`
7. `ADVANCED_FEATURES.md` → 그대로 이동
8. `SCALABILITY_PRINCIPLES.md` → `SCALABILITY.md`
9. `PROJECT_PLAN.md` → `PROJECT_PLAN.md`
10. `DEVELOPMENT_ROADMAP.md` → `ROADMAP.md`

---

### 📁 docs/02-for-developers/ - 개발자 가이드

개발자가 프로젝트를 시작하고 개발하는 데 필요한 문서들입니다.

#### 이동/통합할 파일:
1. `KYS.md` → 그대로 이동
2. `FREE_SETUP_GUIDE.md` → `GETTING_STARTED.md`에 통합 (완료)
3. `GIT_SETUP.md` → `GIT_GUIDE.md` (일부 통합)
4. `FVM_GUIDE.md` → `GETTING_STARTED.md`에 통합 (완료)
5. `DEVELOPER_TOOLS.md` → 그대로 이동
6. `SECURITY_GUIDE.md` → 그대로 이동
7. `COMMIT_MESSAGES.md` → 그대로 이동
8. `WHY_FLUTTER.md` → 그대로 이동

---

### 📁 docs/99-archive/ - 아카이브

임시 작업 파일이나 과거 작업 기록입니다.

#### 아카이브로 이동할 파일:
1. `QUICK_START.md` → `PROJECT_SETUP_HISTORY.md`에 통합
2. `CURRENT_STATUS.md` → `PROJECT_SETUP_HISTORY.md`에 통합
3. `COMMIT_SUCCESS.md` → `PROJECT_SETUP_HISTORY.md`에 통합
4. `PUSH_SUCCESS.md` → `PROJECT_SETUP_HISTORY.md`에 통합
5. `FINAL_SUMMARY.md` → `PROJECT_SETUP_HISTORY.md`에 통합
6. `ENGLISH_COMMIT_GUIDE.md` → `PROJECT_SETUP_HISTORY.md`에 통합
7. `CHANGE_TO_ENGLISH.md` → 삭제 (이미 완료된 작업)
8. `fix_first_commit.sh` → 삭제 (더 이상 불필요)

---

## 🔄 통합 계획

### 통합 1: GETTING_STARTED.md (완료)
- `FREE_SETUP_GUIDE.md`
- `GIT_SETUP.md` (Git 부분만)
- `FVM_GUIDE.md`
- `QUICK_START.md` (일부)

### 통합 2: GIT_GUIDE.md (신규)
- `GIT_SETUP.md` (Git 기본 사용법)
- `COMMIT_MESSAGES.md` (이미 완성되어 있음)

### 통합 3: PROJECT_SETUP_HISTORY.md (신규)
- `QUICK_START.md`
- `CURRENT_STATUS.md`
- `COMMIT_SUCCESS.md`
- `PUSH_SUCCESS.md`
- `FINAL_SUMMARY.md`
- `ENGLISH_COMMIT_GUIDE.md`
- `CHANGE_TO_ENGLISH.md`

---

## 📝 파일 이름 변경

### 간결한 이름으로 변경:
- `ARCHITECTURE_DESIGN.md` → `ARCHITECTURE.md`
- `AI_SYSTEM_DESIGN.md` → `AI_SYSTEM.md`
- `UI_UX_DESIGN_SYSTEM.md` → `UI_UX_DESIGN.md`
- `SECURITY_ARCHITECTURE.md` → `SECURITY.md`
- `SCALABILITY_PRINCIPLES.md` → `SCALABILITY.md`
- `DEVELOPMENT_ROADMAP.md` → `ROADMAP.md`

---

## 🎯 최종 구조

```
new_sendbox/
├── README.md                    # 프로젝트 개요
├── LICENSE
├── .gitignore
│
├── docs/
│   ├── README.md               # 문서 구조 설명
│   │
│   ├── 01-for-ai/              # AI 필수 문서
│   │   ├── PROJECT_PLAN.md
│   │   ├── ARCHITECTURE.md
│   │   ├── DATABASE_SCHEMA.md
│   │   ├── AI_SYSTEM.md
│   │   ├── PLATFORM_INTEGRATION.md
│   │   ├── SECURITY.md
│   │   ├── UI_UX_DESIGN.md
│   │   ├── ADVANCED_FEATURES.md
│   │   ├── SCALABILITY.md
│   │   └── ROADMAP.md
│   │
│   ├── 02-for-developers/      # 개발자 가이드
│   │   ├── GETTING_STARTED.md
│   │   ├── KYS.md
│   │   ├── GIT_GUIDE.md
│   │   ├── COMMIT_MESSAGES.md
│   │   ├── DEVELOPER_TOOLS.md
│   │   ├── SECURITY_GUIDE.md
│   │   └── WHY_FLUTTER.md
│   │
│   └── 99-archive/             # 아카이브
│       └── PROJECT_SETUP_HISTORY.md
│
└── ... (기타 파일)
```

---

## ✅ 실행 순서

1. 디렉토리 생성 (완료)
2. 통합 문서 작성
3. 파일 이동
4. README.md 업데이트
5. 불필요한 파일 삭제

---

**이 계획대로 파일을 정리하시겠습니까?**


