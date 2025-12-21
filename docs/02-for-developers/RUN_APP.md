# 앱 실행 가이드

> SendBox 앱을 실행하는 방법

## 🎯 현재 상황

빌드는 성공했지만 Android 디바이스가 연결되어 있지 않아 실행할 수 없습니다.

## 📱 실행 방법

### 방법 1: Android 에뮬레이터 사용 (추천)

#### 1. 에뮬레이터 확인
```bash
flutter emulators
```

#### 2. 에뮬레이터 실행
```bash
# 사용 가능한 에뮬레이터 목록 보기
flutter emulators

# 특정 에뮬레이터 실행
flutter emulators --launch <emulator_id>
```

또는 Android Studio에서:
1. Android Studio 열기
2. Tools > Device Manager
3. 원하는 에뮬레이터 시작

#### 3. 앱 실행
```bash
flutter run
```

---

### 방법 2: 실제 Android 기기 사용

#### 1. USB 디버깅 활성화
- 기기에서 **설정 > 개발자 옵션 > USB 디버깅** 활성화

#### 2. USB로 연결
- 기기를 PC에 USB로 연결

#### 3. 연결 확인
```bash
flutter devices
```

#### 4. 앱 실행
```bash
flutter run
```

---

### 방법 3: APK 파일 직접 설치

이미 생성된 APK 파일을 직접 설치할 수 있습니다.

#### 1. APK 파일 위치 확인
```
build/app/outputs/flutter-apk/app-debug.apk
```

#### 2. 기기에 전송 및 설치
- **USB로 전송**: `adb install build/app/outputs/flutter-apk/app-debug.apk`
- **이메일/클라우드로 전송**: APK 파일을 기기로 전송 후 직접 설치

#### 3. 기기에서 설치
1. APK 파일 열기
2. "알 수 없는 출처" 허용 (필요시)
3. 설치 완료

---

## 🔍 디바이스 확인

현재 연결된 디바이스 확인:
```bash
flutter devices
```

Android 디바이스가 표시되면 `flutter run`으로 실행할 수 있습니다.

---

## ⚠️ 문제 해결

### "No supported devices connected" 오류
- Android 에뮬레이터가 실행 중인지 확인
- 실제 기기의 USB 디버깅이 활성화되어 있는지 확인
- USB 케이블이 정상 작동하는지 확인

### 에뮬레이터가 보이지 않는 경우
- Android Studio에서 에뮬레이터 생성 필요
- AVD Manager에서 새 가상 디바이스 생성

---

## 📝 참고사항

- **Windows/Chrome/Edge**: 현재 프로젝트는 Android 전용입니다. 다른 플랫폼을 지원하려면 추가 설정이 필요합니다.
- **빌드된 APK**: `build/app/outputs/flutter-apk/app-debug.apk` 파일을 직접 설치할 수 있습니다.

