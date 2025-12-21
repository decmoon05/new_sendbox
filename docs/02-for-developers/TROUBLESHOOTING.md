# 문제 해결 가이드

> SendBox 개발 중 발생할 수 있는 문제와 해결 방법

## 📱 앱 설치 실패

### INSTALL_FAILED_INSUFFICIENT_STORAGE

**증상**: `INSTALL_FAILED_INSUFFICIENT_STORAGE: Failed to override installation location`

**원인**: 에뮬레이터나 디바이스의 저장 공간 부족

**해결 방법**:

#### 1. 에뮬레이터 저장 공간 확인
```bash
adb shell df -h
```

#### 2. 불필요한 앱 제거
```bash
# 설치된 앱 목록 확인
adb shell pm list packages

# 특정 앱 제거 (예시)
adb shell pm uninstall <package_name>
```

#### 3. 에뮬레이터 캐시 정리
```bash
# 에뮬레이터 재시작
adb reboot

# 또는 Android Studio에서 에뮬레이터를 Cold Boot Now
```

#### 4. APK 파일 크기 줄이기
현재 APK 크기가 약 154MB입니다. 크기를 줄이려면:
- 불필요한 assets 제거
- ProGuard/R8 활성화 (릴리스 빌드)
- Split APK 사용

#### 5. 에뮬레이터 설정 변경
- Android Studio > AVD Manager
- 에뮬레이터 편집 > Advanced Settings
- Internal Storage 증가

---

## 🔥 Firebase 초기화 오류

**증상**: `No Firebase App '[DEFAULT]' has been initialized`

**원인**: `google-services.json` 파일이 없거나 Firebase 초기화 실패

**해결 방법**:

### 방법 1: 오프라인 모드로 실행 (권장)
- 현재 코드는 Firebase 없이도 실행 가능
- 로컬 DB(Isar)만 사용
- Firebase 기능은 비활성화됨

### 방법 2: Firebase 설정
1. Firebase Console에서 프로젝트 생성
2. Android 앱 추가
3. `google-services.json` 다운로드
4. `android/app/` 폴더에 배치

---

## 💾 Isar 초기화 오류

**증상**: `Isar가 초기화되지 않았습니다`

**원인**: Isar 인스턴스가 Provider에 제대로 전달되지 않음

**해결 방법**:
- `main.dart`에서 Isar 초기화 후 `isarProvider`에 설정 확인
- 현재 코드에서는 `ProviderScope`의 `overrides` 사용

---

## 📦 빌드 에러

### Namespace not specified (Isar)
**해결**: pub cache의 `isar_flutter_libs` 패키지 build.gradle에 namespace 추가 (이미 수정됨)

### Core Library Desugaring
**해결**: `android/app/build.gradle.kts`에 desugaring 활성화 (이미 수정됨)

---

## 🔍 일반적인 문제

### 앱이 실행되지 않음
1. `flutter clean` 실행
2. `flutter pub get` 실행
3. 에뮬레이터 재시작
4. `flutter run` 다시 실행

### Hot Reload가 작동하지 않음
1. 앱 재시작 (`r` 키)
2. Hot Restart (`R` 키)
3. 완전 재시작 (`flutter run`)

### 패키지 충돌
```bash
flutter pub outdated
flutter pub upgrade
```

---

## 📝 디버깅 팁

### 로그 확인
```bash
# Android 로그 확인
adb logcat | Select-String "flutter"

# 특정 앱만 확인
adb logcat | Select-String "sendbox"
```

### 빌드 정보 확인
```bash
flutter doctor -v
flutter devices
```

---

## 🆘 여전히 문제가 있나요?

1. 에러 메시지 전체 복사
2. `flutter doctor -v` 결과 확인
3. GitHub Issues에 보고

