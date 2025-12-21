# 저장 공간 부족 해결 방법

> 에뮬레이터 저장 공간 부족 문제 해결

## 🔴 현재 상황

- 에뮬레이터 `/data` 파티션: 90% 사용 중 (603MB 남음)
- APK 크기: 약 154MB
- 설치 필요 공간: 약 200-300MB (압축 해제 포함)

## ✅ 해결 방법

### 방법 1: 에뮬레이터 Cold Boot (가장 효과적)

1. Android Studio 열기
2. **Device Manager** (Tools > Device Manager)
3. 실행 중인 에뮬레이터 옆 **...** 클릭
4. **Cold Boot Now** 선택

이렇게 하면 에뮬레이터가 완전히 초기화되어 저장 공간이 확보됩니다.

---

### 방법 2: 불필요한 앱 제거

```bash
# 설치된 앱 목록 확인
adb shell pm list packages -3

# 특정 앱 제거 (예시)
adb shell pm uninstall <package_name>

# 모든 사용자 앱 제거 (주의: 시스템 앱은 제외)
adb shell pm list packages -3 | ForEach-Object { 
    $package = $_ -replace "package:", ""
    adb shell pm uninstall $package
}
```

---

### 방법 3: 캐시 정리

```bash
# 특정 앱 캐시 정리
adb shell pm clear <package_name>

# Chrome 캐시 정리 (크기가 큰 경우)
adb shell pm clear com.android.chrome

# Google Play Store 캐시
adb shell pm clear com.android.vending
```

---

### 방법 4: 에뮬레이터 저장 공간 늘리기

1. Android Studio > Device Manager
2. 에뮬레이터 **Edit** (연필 아이콘)
3. **Show Advanced Settings**
4. **Internal Storage** 증가 (예: 8GB → 16GB)
5. 에뮬레이터 재생성 필요 (데이터는 사라짐)

---

### 방법 5: 다른 에뮬레이터 사용

사용 가능한 다른 에뮬레이터로 시도:

```bash
flutter emulators
flutter emulators --launch Medium_Phone_API_36
```

---

## 🚀 빠른 해결 (권장)

**가장 빠른 방법**: Android Studio에서 에뮬레이터를 **Cold Boot Now**로 재시작

1. Android Studio > Device Manager
2. 실행 중인 에뮬레이터 찾기
3. **...** 메뉴 > **Cold Boot Now**
4. 에뮬레이터 재시작 후 `flutter run` 다시 실행

---

## 📝 참고사항

- Cold Boot는 에뮬레이터의 모든 데이터를 삭제합니다
- 개발 중이므로 데이터 손실은 문제없습니다
- 앱 코드나 프로젝트 파일은 영향을 받지 않습니다

