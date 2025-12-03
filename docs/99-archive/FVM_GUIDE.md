# FVM (Flutter Version Management) 가이드

> Flutter 버전을 프로젝트별로 관리하는 도구

## 🎯 FVM이 왜 필요한가?

### 문제 상황
- Flutter 버전이 자주 업데이트됨
- 프로젝트마다 다른 Flutter 버전 필요할 수 있음
- 팀원마다 다른 Flutter 버전 사용 → 문제 발생

### 해결책: FVM
- 프로젝트별 Flutter 버전 고정
- 팀원 간 버전 동기화
- 버전 전환 쉬움

---

## 📦 FVM 설치

### Windows에서 설치

```bash
# Dart가 설치되어 있어야 함 (Flutter에 포함)

# FVM 설치
dart pub global activate fvm

# 설치 확인
fvm --version
```

### 설치 경로 확인

FVM은 Flutter 버전을 `$HOME/.fvm/` 또는 `C:\Users\<사용자>\.fvm\`에 저장합니다.

---

## 🚀 FVM 기본 사용법

### 1. Flutter 버전 설치

```bash
# 특정 버전 설치
fvm install 3.24.0

# 최신 안정 버전 설치
fvm install stable

# 최신 베타 버전 설치
fvm install beta

# 사용 가능한 버전 목록
fvm releases
```

### 2. 프로젝트에 Flutter 버전 지정

```bash
# 프로젝트 디렉토리로 이동
cd C:\Users\WannaGoHome\Desktop\new_sendbox

# Flutter 3.24.0 사용
fvm use 3.24.0

# 또는 최신 안정 버전
fvm use stable
```

**결과:**
- `.fvm/flutter_sdk` 심볼릭 링크 생성
- `.fvmrc` 또는 `fvm_config.json` 파일 생성

### 3. Flutter 명령어 사용

```bash
# FVM을 통한 Flutter 명령어
fvm flutter --version
fvm flutter pub get
fvm flutter run
fvm flutter build apk

# 또는 별칭(alias) 설정 (선택)
```

### 4. 현재 사용 중인 버전 확인

```bash
fvm list
```

---

## 🔧 VS Code 설정

### VS Code에서 FVM 사용하기

### 방법 1: 설정 파일 수정

**`.vscode/settings.json` 파일 생성:**

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "search.exclude": {
    "**/.fvm": true
  },
  "files.watcherExclude": {
    "**/.fvm": true
  }
}
```

### 방법 2: 환경 변수 설정 (고급)

VS Code가 자동으로 FVM을 인식하도록 설정

---

## 📁 프로젝트 구조

FVM 사용 시 프로젝트 구조:

```
new_sendbox/
├── .fvm/
│   └── flutter_sdk/  # Flutter SDK 심볼릭 링크
├── .fvmrc            # 또는 fvm_config.json
├── lib/
├── pubspec.yaml
└── ...
```

### .fvmrc 파일 내용

```yaml
flutter: "3.24.0"
```

**이 파일을 Git에 커밋하면:**
- 팀원들이 같은 Flutter 버전 사용
- 프로젝트별 버전 고정

---

## ✅ SendBox 프로젝트에 FVM 적용

### 1. FVM 설치 확인

```bash
fvm --version
```

### 2. Flutter 3.24.0 설치 (또는 최신 안정 버전)

```bash
# Flutter 3.24.0 설치
fvm install 3.24.0

# 또는 최신 안정 버전 확인 후 설치
fvm install stable
```

### 3. 프로젝트에 적용

```bash
cd C:\Users\WannaGoHome\Desktop\new_sendbox

# Flutter 버전 지정
fvm use 3.24.0
```

### 4. .gitignore에 FVM 추가 (선택)

`.gitignore`에 다음 추가:

```gitignore
# FVM
.fvm/flutter_sdk
```

**하지만 `.fvmrc` 파일은 커밋해야 함!** (팀원 간 버전 동기화)

### 5. .fvmrc 커밋

```bash
git add .fvmrc
git commit -m "Add FVM configuration: Flutter 3.24.0"
```

---

## 🎯 일상적인 사용

### Flutter 명령어 실행

```bash
# pub get
fvm flutter pub get

# 앱 실행
fvm flutter run

# 빌드
fvm flutter build apk

# 분석
fvm flutter analyze

# 테스트
fvm flutter test
```

### 별칭 설정 (선택)

**PowerShell 프로필에 추가:**

```powershell
# 프로필 편집
notepad $PROFILE

# 다음 추가
function flutter { fvm flutter $args }
```

이제 `fvm` 없이 `flutter` 명령어만 사용 가능!

---

## 📚 FVM 고급 사용법

### 여러 버전 관리

```bash
# 설치된 버전 목록
fvm list

# 버전 삭제
fvm remove 3.20.0

# 글로벌 버전 설정
fvm global 3.24.0
```

### 버전 업그레이드

```bash
# 현재 버전 확인
fvm list

# 새 버전 설치
fvm install 3.25.0

# 프로젝트 버전 변경
fvm use 3.25.0

# 테스트
fvm flutter --version
```

---

## ⚠️ 주의사항

### 1. .fvmrc 파일은 커밋해야 함

- 팀원들이 같은 버전 사용
- 프로젝트 버전 명시

### 2. .fvm/flutter_sdk는 커밋하지 않음

- 심볼릭 링크 또는 실제 파일
- 각자 로컬에서 생성됨

### 3. GitHub Actions에서도 FVM 사용

**`.github/workflows/flutter.yml`:**

```yaml
- name: Setup FVM
  run: |
    dart pub global activate fvm
    fvm install 3.24.0
    fvm use 3.24.0

- name: Install dependencies
  run: fvm flutter pub get
```

---

## 🔍 문제 해결

### 문제 1: "fvm: command not found"

**해결:**
```bash
# Dart 경로 확인
dart --version

# FVM 재설치
dart pub global activate fvm

# PATH 확인
echo $PATH  # 또는 $env:PATH (PowerShell)
```

### 문제 2: VS Code가 FVM을 인식하지 않음

**해결:**
1. `.vscode/settings.json` 설정 확인
2. VS Code 재시작
3. 또는 전체 Flutter 경로 설정

### 문제 3: "Flutter SDK not found"

**해결:**
```bash
# FVM Flutter 버전 다시 설치
fvm install 3.24.0
fvm use 3.24.0

# 경로 확인
fvm flutter --version
```

---

## 📝 체크리스트

### FVM 설치 및 설정
- [ ] FVM 설치 (`dart pub global activate fvm`)
- [ ] 설치 확인 (`fvm --version`)
- [ ] Flutter 3.24.0 설치 (`fvm install 3.24.0`)
- [ ] 프로젝트에 적용 (`fvm use 3.24.0`)
- [ ] VS Code 설정 (`.vscode/settings.json`)
- [ ] `.fvmrc` 파일 커밋

---

## 🎯 결론

### FVM 사용의 장점
- ✅ 프로젝트별 Flutter 버전 고정
- ✅ 팀원 간 버전 동기화
- ✅ 버전 전환 쉬움
- ✅ 여러 프로젝트 관리 용이

### SendBox 프로젝트
- Flutter 3.24.0 사용 권장
- `.fvmrc` 파일로 버전 고정
- 모든 팀원이 같은 버전 사용

---

**FVM 설정 완료! 이제 Flutter 버전을 안전하게 관리할 수 있습니다!** 🎉


