# 다음 단계 가이드

> SendBox 프로젝트 실행을 위한 필수 작업

## 🚨 현재 상태

✅ **완료된 것:**
- 코드 구조 및 아키텍처 (100%)
- Core, Domain, Data, Presentation 레이어 구현
- Isar 코드 생성 완료

❌ **아직 필요한 것:**
- Android/iOS 프로젝트 구조 생성
- 실제 앱 빌드 및 실행
- 컴파일 에러 수정

---

## 📋 즉시 해야 할 작업

### 1. Flutter 프로젝트 구조 완성 (최우선)

현재 `lib/` 폴더만 있고 실제 플랫폼 프로젝트가 없습니다.

```bash
# Android 프로젝트 생성
flutter create --platforms=android .
```

**주의:** 이미 `lib/` 폴더가 있으므로 `--org`, `--project-name` 등은 자동으로 감지됩니다.

---

### 2. 컴파일 에러 확인 및 수정

```bash
# 분석 실행
flutter analyze

# 빌드 시도 (에러 확인)
flutter build apk --debug
```

---

### 3. Firebase 설정 (선택사항이지만 권장)

Firebase 없이도 로컬 DB로 테스트 가능하지만, 완전한 기능 테스트를 위해서는:

1. [Firebase Console](https://console.firebase.google.com/)에서 프로젝트 생성
2. Android 앱 추가
3. `google-services.json` 다운로드
4. `android/app/` 폴더에 배치

---

### 4. API 키 설정

Gemini API를 사용하려면:

1. [Google AI Studio](https://makersuite.google.com/app/apikey)에서 API 키 생성
2. 환경 변수로 설정하거나 (권장)
3. 임시로 코드에 설정 (개발용만)

---

### 5. 기본 실행 테스트

```bash
# 디바이스/에뮬레이터 확인
flutter devices

# 앱 실행
flutter run
```

---

## 🔧 예상되는 문제 및 해결

### 문제 1: Android 프로젝트가 없음
**해결:** `flutter create --platforms=android .` 실행

### 문제 2: Firebase 초기화 에러
**해결:** 
- 임시로 Firebase 초기화를 옵셔널로 만들기
- 또는 `google-services.json` 파일 추가

### 문제 3: Gemini API 키 없음
**해결:**
- API 키를 환경 변수로 설정
- 또는 임시로 더미 데이터 사용

### 문제 4: Isar 스키마 에러
**해결:** 
- `flutter pub run build_runner build --delete-conflicting-outputs` 재실행

---

## 📝 단계별 체크리스트

### Phase 1: 프로젝트 구조 완성
- [ ] Android 프로젝트 생성
- [ ] iOS 프로젝트 생성 (선택사항)
- [ ] `flutter analyze` 통과 확인
- [ ] 기본 빌드 성공 확인

### Phase 2: 설정 및 구성
- [ ] Firebase 프로젝트 생성 (선택)
- [ ] API 키 설정
- [ ] 권한 설정 (AndroidManifest.xml)

### Phase 3: 실행 및 테스트
- [ ] 앱 실행 성공
- [ ] 기본 UI 표시 확인
- [ ] 로컬 DB 동작 확인

---

## 🎯 권장 작업 순서

1. **즉시 실행:**
   ```bash
   flutter create --platforms=android .
   flutter analyze
   flutter run
   ```

2. **에러 수정:**
   - 컴파일 에러 하나씩 해결
   - 필수 의존성 확인

3. **기능 테스트:**
   - UI 화면 확인
   - 로컬 DB 동작 확인
   - 기본 CRUD 테스트

4. **향상 작업:**
   - Firebase 연동
   - API 키 설정
   - 실제 기능 테스트

---

## 💡 참고사항

- 현재 코드는 구조적으로 완성되었지만, 실제 실행을 위해서는 플랫폼 프로젝트가 필요합니다.
- Firebase 없이도 로컬 DB(Isar)로 대부분의 기능을 테스트할 수 있습니다.
- API 키는 나중에 추가해도 되지만, AI 추천 기능은 API 키가 있어야 동작합니다.

---

**다음 명령어부터 시작하세요:**
```bash
flutter create --platforms=android .
```

