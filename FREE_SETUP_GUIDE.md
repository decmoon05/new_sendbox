# SendBox 무료 도구만으로 시작하기 가이드

> 예산 제로, 완전 무료 도구만 사용하는 설정 가이드

## 🎯 무료 구성 최종 정리

### ✅ 사용할 무료 도구 목록

| 카테고리 | 도구 | 가격 | 용도 |
|---------|------|------|------|
| **IDE** | VS Code | 무료 | 코드 작성 |
| **Flutter 버전** | FVM | 무료 | Flutter 버전 관리 |
| **디자인** | Figma | 무료 | UI 디자인 |
| **API 테스트** | Postman | 무료 | API 개발/테스트 |
| **버전 관리** | GitHub | 무료 | 코드 저장/협업 |
| **백엔드** | Firebase | 무료 (Spark 플랜) | 데이터베이스, 인증, 호스팅 |
| **CI/CD** | GitHub Actions | 무료 | 자동 빌드/테스트 |
| **모니터링** | Firebase Crashlytics | 무료 | 크래시 리포트 |
| **에러 추적** | Sentry (무료 플랜) | 무료 | 에러 모니터링 |
| **문서화** | Notion | 무료 | 프로젝트 문서 |
| **이슈 관리** | GitHub Issues | 무료 | 작업 관리 |

---

## 📦 설치 순서 (단계별)

### Step 1: 필수 도구 설치

#### 1.1 Visual Studio Code 설치

```bash
# Windows
# https://code.visualstudio.com/ 에서 다운로드

# 설치 후 필수 확장 프로그램 설치:
# - Flutter (Dart Code)
# - Dart
# - GitLens
# - Error Lens
# - Thunder Client (API 테스트)
```

**확장 프로그램 설치 방법:**
1. VS Code 열기
2. `Ctrl+Shift+X` (확장 프로그램)
3. 검색 후 설치:
   - `Flutter`
   - `Dart`
   - `GitLens`
   - `Error Lens`
   - `Thunder Client`

#### 1.2 Git 설치

```bash
# Windows
# https://git-scm.com/download/win 에서 다운로드

# 설치 확인
git --version
```

#### 1.3 Flutter 설치

```bash
# FVM을 통한 Flutter 설치 (권장)

# 1. Dart 설치 (Flutter에 포함되지만 먼저)
# https://dart.dev/get-dart

# 2. FVM 설치
dart pub global activate fvm

# 3. Flutter 설치
fvm install 3.24.0
fvm use 3.24.0

# 4. Flutter 확인
fvm flutter --version
```

**또는 직접 설치:**
- https://docs.flutter.dev/get-started/install/windows

#### 1.4 Android Studio 설치 (선택, 에뮬레이터용)

```bash
# https://developer.android.com/studio 에서 다운로드
# 무료 (Community 버전)

# 설치 후:
# 1. Android SDK 설치
# 2. 에뮬레이터 생성
```

---

### Step 2: 온라인 서비스 가입

#### 2.1 GitHub 가입 및 설정

**가입:**
1. https://github.com/ 접속
2. Sign up 클릭
3. 무료 계정 생성

**초기 설정:**
```bash
# Git 사용자 설정
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# SSH 키 생성 (선택)
ssh-keygen -t ed25519 -C "your.email@example.com"
```

**리포지토리 생성:**
1. GitHub에서 "New repository" 클릭
2. 이름: `sendbox`
3. Private 선택 (무료 플랜에서 가능)
4. README 추가 (선택)

**로컬 연결:**
```bash
# 리포지토리 클론
git clone https://github.com/yourusername/sendbox.git
cd sendbox

# 또는 기존 프로젝트 연결
git init
git remote add origin https://github.com/yourusername/sendbox.git
```

#### 2.2 Firebase 가입 및 프로젝트 생성

**가입:**
1. https://firebase.google.com/ 접속
2. Google 계정으로 로그인
3. "Get started" 클릭

**프로젝트 생성:**
1. "Add project" 클릭
2. 프로젝트 이름: `sendbox`
3. Google Analytics 활성화 (무료)
4. 프로젝트 생성 완료

**Firebase 설정:**
1. Android 앱 추가
   - 패키지 이름: `com.sendbox.app`
   - `google-services.json` 다운로드
   - `android/app/` 폴더에 저장

2. Firestore Database 설정
   - "Create database" 클릭
   - 테스트 모드로 시작 (나중에 보안 규칙 설정)

3. Authentication 설정
   - Sign-in method 활성화:
     - Email/Password
     - Google (선택)

4. Crashlytics 설정
   - "Enable Crashlytics" 클릭

**무료 플랜 (Spark) 제한:**
- ✅ Firestore: 읽기/쓰기 50,000/일
- ✅ Storage: 5GB
- ✅ Hosting: 10GB 전송/월
- ✅ Functions: 125,000 호출/월
- ✅ 충분한 무료 할당량!

#### 2.3 Figma 가입

**가입:**
1. https://www.figma.com/ 접속
2. "Sign up" 클릭
3. 무료 계정 생성

**무료 플랜:**
- ✅ 개인 프로젝트 무제한
- ✅ 3개 Figma 파일
- ✅ 무제한 협업 (읽기 전용)

**초기 설정:**
1. 새 파일 생성: "SendBox Design"
2. Flutter 플러그인 설치:
   - File → Plugins → "Figma to Flutter" 검색

#### 2.4 Postman 가입

**가입:**
1. https://www.postman.com/ 접속
2. "Sign Up" 클릭
3. 무료 계정 생성

**초기 설정:**
1. Workspace 생성: "SendBox"
2. 환경 변수 설정:
   - `base_url`: API 기본 URL
   - `api_key`: API 키 (나중에)

#### 2.5 Notion 가입

**가입:**
1. https://www.notion.so/ 접속
2. "Sign up" 클릭
3. 무료 계정 생성

**초기 설정:**
1. 새 워크스페이스: "SendBox Project"
2. 프로젝트 템플릿 사용 (선택)

#### 2.6 Sentry 가입 (선택, 나중에)

**가입:**
1. https://sentry.io/ 접속
2. 무료 계정 생성

**무료 플랜:**
- ✅ 5,000 이벤트/월
- ✅ 1개 프로젝트
- ✅ 충분!

---

### Step 3: 프로젝트 초기 설정

#### 3.1 Flutter 프로젝트 생성

```bash
# 프로젝트 생성
fvm flutter create sendbox
cd sendbox

# 또는 직접 생성
flutter create sendbox
cd sendbox

# 의존성 확인
fvm flutter pub get
```

#### 3.2 필수 패키지 설치

**`pubspec.yaml`에 추가:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 상태 관리
  flutter_riverpod: ^2.5.1
  
  # 로컬 데이터베이스
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  
  # 네트워크
  dio: ^5.4.0
  
  # Firebase
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  firebase_storage: ^12.0.0
  firebase_crashlytics: ^4.0.0
  firebase_analytics: ^11.0.0
  
  # 로컬화
  easy_localization: ^3.0.3
  
  # 암호화
  crypto: ^3.0.3
  flutter_secure_storage: ^9.0.0
  
  # 유틸리티
  uuid: ^4.3.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  
  # 코드 생성
  build_runner: ^2.4.0
  json_serializable: ^6.7.1
  freezed: ^2.4.6
  
  # Isar 코드 생성
  isar_generator: ^3.1.0
```

**설치:**
```bash
fvm flutter pub get
```

#### 3.3 .gitignore 설정

`.gitignore` 파일이 이미 생성되어 있는지 확인하고, 다음 내용 추가:

```gitignore
# 이미 DEVELOPER_TOOLS.md에 포함된 .gitignore 사용
```

#### 3.4 환경 변수 설정

**`.env.example` 파일 생성:**

```
GEMINI_API_KEY=your_key_here
FIREBASE_API_KEY=your_key_here
```

**`.env` 파일 생성 (로컬용, .gitignore에 포함):**
- `.env.example` 복사
- 실제 값 입력

**환경 변수 읽기 패키지:**
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

---

### Step 4: GitHub Actions 설정 (CI/CD)

#### 4.1 GitHub Actions 워크플로우 생성

**`.github/workflows/flutter.yml` 파일 생성:**

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Analyze code
      run: flutter analyze
    
    - name: Run tests
      run: flutter test
    
    - name: Build APK
      run: flutter build apk --release
      if: github.ref == 'refs/heads/main'
```

**작동 방식:**
- 코드 푸시 시 자동으로 테스트 실행
- 분석 및 빌드 자동화
- 완전 무료!

---

### Step 5: Firebase 연동

#### 5.1 Firebase 초기화

**`lib/main.dart`:**

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

**Firebase 옵션 생성:**
```bash
fvm flutter pub add firebase_core
fvm flutter pub global activate flutterfire_cli
flutterfire configure
```

#### 5.2 Firebase 설정 파일

- `google-services.json` (Android)
  - 위치: `android/app/`
  - `.gitignore`에 추가되어 있음

---

### Step 6: 개발 환경 확인

#### 6.1 Flutter Doctor 실행

```bash
fvm flutter doctor
```

**확인 사항:**
- ✅ Flutter 설치 확인
- ✅ Android SDK 확인
- ✅ VS Code 확장 확인

#### 6.2 첫 빌드 테스트

```bash
# Android 에뮬레이터 시작 또는
# 실제 기기 연결

fvm flutter run
```

---

## 📁 프로젝트 구조 설정

### Clean Architecture 폴더 구조 생성

```bash
# lib 폴더 구조
lib/
├── core/
│   ├── constants/
│   ├── utils/
│   ├── errors/
│   ├── theme/
│   └── extensions/
├── data/
│   ├── datasources/
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── features/
│   ├── widgets/
│   └── routes/
└── main.dart
```

**스크립트로 생성:**
```bash
# Windows PowerShell
mkdir -p lib/core/{constants,utils,errors,theme,extensions}
mkdir -p lib/data/{datasources,models,repositories,services}
mkdir -p lib/domain/{entities,repositories,usecases}
mkdir -p lib/presentation/{features,widgets,routes}
```

---

## 🎨 디자인 시작 (Figma)

### Figma 프로젝트 설정

1. **새 파일 생성**
   - 이름: "SendBox Design System"

2. **프레임 설정**
   - Mobile: 375x812 (iPhone 13 기준)
   - Android: 360x640 (기본)

3. **컬러 시스템 생성**
   - Primary Color
   - Secondary Color
   - Background Colors
   - Text Colors

4. **타이포그래피 스타일**
   - Headline 1-3
   - Body Large/Medium/Small
   - Caption

5. **컴포넌트 제작**
   - Button
   - Input Field
   - Card
   - 등등

---

## 📚 문서화 시작 (Notion)

### Notion 워크스페이스 구조

```
SendBox Project
├── 📋 프로젝트 개요
├── 📝 요구사항
├── 🎨 디자인 시스템
├── 🏗️ 아키텍처
├── 📅 개발 일정
├── 🐛 버그 트래킹
└── 📖 개발 노트
```

**템플릿 사용:**
1. Notion에서 "Project Management" 템플릿 검색
2. 또는 직접 페이지 생성

---

## 🔧 초기 개발 체크리스트

### 개발 시작 전 확인

- [ ] VS Code 설치 및 Flutter 확장 설치
- [ ] Git 설치 및 GitHub 가입
- [ ] FVM 설치 및 Flutter 설치
- [ ] GitHub 리포지토리 생성
- [ ] Firebase 프로젝트 생성
- [ ] Figma 계정 생성
- [ ] Postman 설치
- [ ] Notion 워크스페이스 생성

### 프로젝트 설정

- [ ] Flutter 프로젝트 생성
- [ ] 의존성 패키지 설치
- [ ] .gitignore 설정
- [ ] 환경 변수 파일 생성
- [ ] GitHub Actions 설정
- [ ] Firebase 연동
- [ ] 첫 빌드 성공

### 문서화

- [ ] Notion 프로젝트 페이지 생성
- [ ] 개발 일정 작성
- [ ] 아키텍처 문서 정리

---

## 💡 무료 플랜 제한 및 대응

### Firebase 제한

**읽기/쓰기 50,000/일:**
- 개발 단계: 충분함
- 나중에 확장 필요 시 Blaze 플랜 전환
- 또는 자체 백엔드 구축

**대응:**
- 캐싱 최대화
- 불필요한 요청 최소화
- 로컬 데이터베이스 적극 활용

### GitHub 제한

**퍼블릭 리포지토리:**
- 무제한

**프라이빗 리포지토리:**
- 무료 (무제한)
- 협업자 제한 없음

**Actions:**
- 퍼블릭: 무제한
- 프라이빗: 2,000분/월

**대응:**
- 충분한 할당량
- 프라이빗 리포지토리 사용 가능

### Sentry 제한

**5,000 이벤트/월:**
- 개발 단계: 충분함
- 프로덕션: 모니터링 필요

**대응:**
- 중요한 에러만 추적
- 샘플링 설정

---

## 🚀 다음 단계

### 개발 시작

1. **Phase 1: 기초 인프라**
   - 프로젝트 구조 생성
   - 상태 관리 설정
   - 테마 시스템 구축

2. **Phase 2: 핵심 기능**
   - SMS 통합
   - 기본 AI 추천
   - 프로필 관리

### 지속적인 개선

- 정기적으로 도구 업데이트
- 새로운 무료 도구 탐색
- 커뮤니티 참여

---

## 📞 도움이 필요할 때

### 공식 문서

- Flutter: https://docs.flutter.dev/
- Firebase: https://firebase.google.com/docs
- GitHub Actions: https://docs.github.com/actions

### 커뮤니티

- Flutter Discord
- Stack Overflow
- GitHub Discussions

---

## ✅ 최종 체크리스트

개발 시작 전 최종 확인:

- [ ] 모든 도구 설치 완료
- [ ] 모든 서비스 가입 완료
- [ ] 프로젝트 초기 설정 완료
- [ ] 첫 빌드 성공
- [ ] GitHub 리포지토리 연결
- [ ] Firebase 연동 확인

**준비 완료! 이제 개발을 시작할 수 있습니다!** 🎉

---

**모든 것이 완전 무료입니다. 비용 걱정 없이 개발하세요!** 💰✨

