# 개발 시작 가이드

> SendBox 프로젝트 개발 환경 설정 및 시작하기

## 📋 목차

1. [사전 요구사항](#사전-요구사항)
2. [개발 도구 설치](#개발-도구-설치)
3. [온라인 서비스 설정](#온라인-서비스-설정)
4. [Git 및 GitHub 설정](#git-및-github-설정)
5. [프로젝트 초기 설정](#프로젝트-초기-설정)
6. [개발 시작](#개발-시작)

---

## 사전 요구사항

### 필요 도구

- Windows 10 이상
- 인터넷 연결
- GitHub 계정

---

## 개발 도구 설치

### 1. Visual Studio Code

**설치:**
- https://code.visualstudio.com/ 에서 다운로드

**필수 확장 프로그램:**
1. `Flutter` (Dart Code)
2. `Dart`
3. `GitLens`
4. `Error Lens`
5. `Thunder Client`

**설치 방법:**
- VS Code 열기 → `Ctrl+Shift+X` → 검색 후 설치

### 2. Git

**설치:**
- https://git-scm.com/download/win 에서 다운로드

**설정:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. Flutter 설치

#### 방법 1: FVM 사용 (권장)

**FVM 설치:**
```bash
dart pub global activate fvm
```

**Flutter 설치:**
```bash
fvm install 3.24.0
fvm use 3.24.0
fvm flutter --version
```

**VS Code 설정:**
`.vscode/settings.json` 생성:
```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "search.exclude": {
    "**/.fvm": true
  }
}
```

#### 방법 2: 직접 설치

- https://docs.flutter.dev/get-started/install/windows

### 4. Android Studio (선택)

**에뮬레이터 사용 시 필요:**
- https://developer.android.com/studio 에서 다운로드

---

## 온라인 서비스 설정

### 1. GitHub

**가입:**
1. https://github.com/ 접속
2. Sign up
3. 무료 계정 생성

**레포지토리:**
- https://github.com/decmoon05/new_sendbox

### 2. Firebase

**가입:**
1. https://firebase.google.com/ 접속
2. Google 계정으로 로그인
3. 프로젝트 생성: `sendbox`

**설정:**
- Android 앱 추가
- Firestore Database 활성화
- Authentication 활성화
- Crashlytics 활성화

### 3. 기타 서비스

- **Figma**: https://www.figma.com/
- **Postman**: https://www.postman.com/
- **Notion**: https://www.notion.so/

---

## Git 및 GitHub 설정

### Git 초기화

```bash
# 프로젝트 디렉토리에서
git init
git branch -M main
```

### GitHub 연동

```bash
# 원격 저장소 추가
git remote add origin https://github.com/decmoon05/new_sendbox.git

# 확인
git remote -v
```

### 커밋 및 푸시

```bash
# 파일 추가
git add .

# 커밋 (영어로!)
git commit -m "feat: Add new feature"

# 푸시
git push -u origin main
```

**GitHub 인증:**
- Personal Access Token 생성: https://github.com/settings/tokens
- 권한: `repo` (전체) 선택
- 푸시 시 비밀번호 대신 토큰 사용

**자세한 가이드:** [GIT_GUIDE.md](GIT_GUIDE.md)

---

## 프로젝트 초기 설정

### 1. Flutter 프로젝트 생성

```bash
# FVM 사용 시
fvm flutter create sendbox
cd sendbox

# 또는 직접
flutter create sendbox
cd sendbox
```

### 2. 의존성 설치

`pubspec.yaml` 설정 후:

```bash
fvm flutter pub get
```

### 3. Firebase 연동

```bash
# Firebase CLI 설치
dart pub global activate flutterfire_cli

# Firebase 설정
flutterfire configure
```

**파일:**
- `google-services.json` → `android/app/`
- `.gitignore`에 추가되어 있음

---

## 개발 시작

### 첫 빌드

```bash
# 상태 확인
fvm flutter doctor

# 빌드 및 실행
fvm flutter run
```

### 개발 워크플로우

```bash
# 1. 브랜치 생성
git checkout -b feature/new-feature

# 2. 개발
# ... 코드 작성 ...

# 3. 커밋
git add .
git commit -m "feat: Add new feature"

# 4. 푸시
git push origin feature/new-feature

# 5. Pull Request 생성
```

---

## 체크리스트

### 설치 확인
- [ ] VS Code 설치 및 확장 프로그램 설치
- [ ] Git 설치 및 설정
- [ ] Flutter 설치 (FVM 또는 직접)
- [ ] Android Studio 설치 (선택)

### 서비스 가입
- [ ] GitHub 가입
- [ ] Firebase 프로젝트 생성
- [ ] Figma 가입
- [ ] Postman 설치

### Git 설정
- [ ] Git 저장소 초기화
- [ ] GitHub 원격 저장소 연결
- [ ] Personal Access Token 생성

### 프로젝트 설정
- [ ] Flutter 프로젝트 생성
- [ ] Firebase 연동
- [ ] 첫 빌드 성공

---

## 다음 단계

1. [KYS.md](KYS.md) - 시스템 이해 가이드 읽기
2. [COMMIT_MESSAGES.md](COMMIT_MESSAGES.md) - 커밋 메시지 규칙 확인
3. [ROADMAP.md](../01-for-ai/ROADMAP.md) - 개발 일정 확인
4. 개발 시작!

---

## 참고 자료

- [KYS - 시스템 이해 가이드](KYS.md)
- [Git 가이드](GIT_GUIDE.md)
- [개발자 도구 추천](DEVELOPER_TOOLS.md)
- [보안 가이드](SECURITY_GUIDE.md)

---

**준비 완료! 이제 개발을 시작할 수 있습니다!** 🚀

