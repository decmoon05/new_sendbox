# SendBox 개발 보안 가이드

> 개발 과정에서 지켜야 할 보안 규칙 및 체크리스트

## 🔐 보안 원칙

### 1. 민감한 정보는 절대 커밋하지 않기

다음 정보들은 **절대** Git에 커밋하면 안 됩니다:

- ✅ API 키 (Gemini, Firebase 등)
- ✅ 비밀번호
- ✅ 암호화 키
- ✅ 인증 토큰
- ✅ 데이터베이스 연결 정보
- ✅ 개인 식별 정보 (테스트 데이터 포함)

### 2. 환경 변수 사용

민감한 정보는 환경 변수나 설정 파일로 관리:

```dart
// ❌ 나쁜 예: 하드코딩
const String apiKey = "AIzaSyC-example-key-12345";

// ✅ 좋은 예: 환경 변수
const String apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: '',
);
```

### 3. .gitignore 활용

`.gitignore` 파일에 민감한 파일 패턴 추가:

```
# .gitignore에 포함된 항목들
*.key
*.pem
.env
google-services.json
firebase_options.dart
**/secrets.dart
```

---

## 📝 개발 시 보안 체크리스트

### 코드 작성 전

- [ ] API 키를 하드코딩하지 않았는가?
- [ ] 비밀번호나 토큰을 코드에 직접 넣지 않았는가?
- [ ] 테스트 데이터에 실제 개인정보가 없는가?

### 커밋 전

- [ ] `git status`로 변경사항 확인
- [ ] 민감한 파일이 추가 목록에 없는가?
- [ ] `.env` 파일이나 설정 파일이 커밋되지 않았는가?
- [ ] 로그 파일에 민감한 정보가 없는가?

### 커밋 후 (푸시 전)

- [ ] `git log`로 최근 커밋 확인
- [ ] 실수로 커밋된 민감한 정보가 없는가?
- [ ] 공개 저장소에 푸시하기 전 이중 확인

---

## 🚨 사고 발생 시 대응

### API 키가 커밋된 경우

1. **즉시 키 무효화**
   - Google Cloud Console에서 키 삭제/재생성
   - Firebase에서 키 재생성

2. **Git 히스토리에서 제거**
   ```bash
   # 커밋 취소 (가장 최근 커밋)
   git reset HEAD~1
   
   # 파일 수정 후 재커밋
   git add .
   git commit -m "보안 수정: API 키 제거"
   ```

3. **이미 푸시된 경우**
   ```bash
   # 강제 푸시 (주의!)
   git push --force
   ```
   **주의**: 팀 작업 시 협의 후 진행

### 다른 민감한 정보 노출 시

1. 정보 무효화 (비밀번호 변경 등)
2. Git 히스토리에서 제거
3. 팀/고객에게 알림 (필요 시)

---

## 🔧 안전한 설정 방법

### 1. API 키 관리

#### 방법 1: 환경 변수 사용

**빌드 시 환경 변수 전달:**
```bash
flutter build apk --dart-define=GEMINI_API_KEY=your-key-here
```

**코드에서 사용:**
```dart
class ApiKeys {
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  
  static bool get isValid => geminiApiKey.isNotEmpty;
}
```

#### 방법 2: 설정 파일 (로컬 개발용)

**파일: `lib/core/config/api_keys.dart.example`**
```dart
class ApiKeys {
  static const String geminiApiKey = 'YOUR_KEY_HERE';
  static const String firebaseApiKey = 'YOUR_KEY_HERE';
}
```

**파일: `lib/core/config/api_keys.dart`** (실제 파일)
- `.gitignore`에 추가
- `.example` 파일만 커밋

### 2. Firebase 설정

**`google-services.json` (Android):**
- `.gitignore`에 추가
- 팀원들은 각자 Firebase 프로젝트에서 다운로드

**`GoogleService-Info.plist` (iOS):**
- `.gitignore`에 추가
- 팀원들은 각자 Firebase 프로젝트에서 다운로드

### 3. 로컬 개발 환경 변수

**`.env.local` 파일 생성:**
```
GEMINI_API_KEY=your-dev-key
FIREBASE_API_KEY=your-dev-key
DEBUG_MODE=true
```

- `.gitignore`에 `.env*` 패턴 추가
- 팀원들은 각자 `.env.local` 파일 생성

---

## 📦 배포 시 보안

### 1. 릴리스 빌드 전 체크

- [ ] 디버그 로그 비활성화
- [ ] API 키가 프로덕션 키인가?
- [ ] 테스트 데이터 제거
- [ ] 코드 난독화 활성화

### 2. 코드 난독화

**`pubspec.yaml`:**
```yaml
flutter:
  build:
    obfuscate: true
```

**빌드 시:**
```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

### 3. 프로덕션 API 키

- 개발용 키와 프로덕션 키 분리
- 프로덕션 키는 최소 권한만 부여
- 키 사용량 모니터링 설정

---

## 🔍 정기적인 보안 점검

### 주간 체크

- [ ] Git 히스토리 검토
- [ ] API 키 사용량 확인
- [ ] 로그 파일 점검

### 월간 체크

- [ ] 의존성 패키지 보안 업데이트
- [ ] API 키 로테이션 검토
- [ ] 접근 권한 검토

### 분기별 체크

- [ ] 전체 코드 보안 감사
- [ ] 외부 보안 전문가 검토 (선택적)
- [ ] 보안 정책 업데이트

---

## 📚 학습 자료

### Git 보안
- [GitHub 보안 모범 사례](https://docs.github.com/en/code-security)
- [Git Secrets 관리](https://git-secret.io/)

### Flutter 보안
- [Flutter 보안 가이드](https://docs.flutter.dev/security)
- [앱 보안 모범 사례](https://docs.flutter.dev/deployment/obfuscate)

### API 키 관리
- [12 Factor App - Config](https://12factor.net/config)
- [환경 변수 모범 사례](https://www.twilio.com/blog/environment-variables-python)

---

## ⚠️ 주의사항

### 절대 하지 말아야 할 것

1. ❌ API 키를 코드에 하드코딩
2. ❌ 민감한 정보를 주석으로 남기기
3. ❌ 테스트 데이터에 실제 정보 사용
4. ❌ `.gitignore` 무시하고 커밋
5. ❌ 공개 저장소에 민감한 정보 푸시

### 해야 할 것

1. ✅ 환경 변수 사용
2. ✅ `.gitignore` 제대로 설정
3. ✅ 커밋 전 항상 확인
4. ✅ 정기적인 보안 점검
5. ✅ 팀원들과 보안 규칙 공유

---

## 🆘 도움이 필요할 때

문제가 발생했거나 확실하지 않을 때:

1. **커밋하기 전**: 팀원이나 멘토에게 확인
2. **의심스러운 파일**: 커밋하지 말고 확인
3. **보안 사고**: 즉시 키 무효화 후 대응

**기억하세요:**
> "의심되면 커밋하지 마세요. 나중에 고치는 것보다 처음부터 안전한 것이 낫습니다."

---

## ✅ 최종 체크리스트

개발을 시작하기 전:

- [ ] `.gitignore` 파일 확인
- [ ] API 키가 환경 변수로 설정되어 있는가?
- [ ] 민감한 파일이 Git에 추가되지 않았는가?
- [ ] 팀원들과 보안 규칙을 공유했는가?

코드 작성 중:

- [ ] 하드코딩된 비밀번호/키가 없는가?
- [ ] 로그에 민감한 정보가 출력되지 않는가?
- [ ] 테스트 데이터에 실제 정보가 없는가?

커밋 전:

- [ ] `git status` 확인
- [ ] 변경된 파일 목록 검토
- [ ] 민감한 정보가 포함되지 않았는가?

---

**보안은 한 번의 실수로 끝날 수 있습니다. 항상 주의하세요!** 🔒

