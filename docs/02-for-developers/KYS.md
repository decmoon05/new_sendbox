# KYS (Know Your System) - 시스템 이해 가이드

> 대학생 2학년 수준에 맞춘 SendBox 기술 스택 및 아키텍처 이해 가이드

## 📚 목차

1. [전체 시스템 개요](#전체-시스템-개요)
2. [Flutter란?](#flutter란)
3. [Clean Architecture란?](#clean-architecture란)
4. [상태 관리 (Riverpod)](#상태-관리-riverpod)
5. [데이터베이스](#데이터베이스)
6. [클라우드 서비스 (Firebase)](#클라우드-서비스-firebase)
7. [AI 서비스](#ai-서비스)
8. [메신저 통합](#메신저-통합)
9. [보안](#보안)
10. [개발 도구](#개발-도구)

---

## 전체 시스템 개요

### SendBox는 어떻게 동작하나요?

```
사용자 → 앱 실행 → 메시지 수신 감지 → AI 분석 → 추천 메시지 제공
```

**간단한 비유:**
- SendBox = 스마트한 메시지 도우미
- 메시지를 받으면 → 과거 대화를 기억하고 → 적절한 답변을 추천해줌
- 여러 메신저(SMS, 카카오톡 등)를 하나의 앱에서 관리

### 시스템 구성도 (초보자용)

```
┌─────────────────────────────────────┐
│      사용자가 보는 화면 (UI)         │
│  - 메시지 목록                       │
│  - AI 추천 메시지                    │
│  - 프로필 화면                        │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│      앱의 두뇌 (비즈니스 로직)       │
│  - 메시지 처리                       │
│  - AI 추천 생성                      │
│  - 데이터 관리                        │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│      데이터 저장소                    │
│  - 폰 안 (로컬)                      │
│  - 인터넷 (클라우드)                 │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│      외부 서비스                      │
│  - AI 서비스 (Gemini)                │
│  - 메신저 앱들                       │
└─────────────────────────────────────┘
```

---

## Flutter란?

### Flutter를 왜 사용하나요?

**Flutter = 하나의 코드로 여러 플랫폼 만들기**

- 일반적 방법: 안드로이드 앱(Java/Kotlin) + iOS 앱(Swift) = 2개 코드
- Flutter 방법: 하나의 코드(Dart) → 안드로이드 + iOS 모두 가능

**비유:**
- 한 번에 한국어와 영어로 번역되는 책 = Flutter
- 두 번 따로 번역 = 일반 방식

### Dart 언어 간단 소개

Dart는 Google이 만든 프로그래밍 언어입니다.

```dart
// 변수 선언
String 이름 = "SendBox";
int 숫자 = 10;
bool 참거짓 = true;

// 함수 (메서드)
void 인사하기() {
  print("안녕하세요!");
}

// 클래스 (객체)
class 메시지 {
  String 내용;
  DateTime 시간;
  
  메시지(this.내용, this.시간);
}
```

**주요 특징:**
- 쉬운 문법
- 빠른 실행 속도
- 비동기 처리 쉬움 (async/await)

---

## Clean Architecture란?

### 왜 Clean Architecture를 사용하나요?

**문제 상황:**
- 모든 코드가 한 곳에 있으면 → 수정할 때 전체가 꼬임
- 테스트하기 어려움
- 다른 사람이 이해하기 어려움

**해결책: Clean Architecture**
- 코드를 역할별로 나눔 (레이어)
- 각 레이어는 독립적
- 수정이 쉬움

### 3개 레이어 (쉬운 설명)

#### 1. Presentation Layer (표시층) - "화면"
```
역할: 사용자가 보는 화면
예시: 버튼, 메시지 목록, 입력창

비유: 레스토랑의 식탁 (손님이 보는 곳)
```

#### 2. Domain Layer (도메인층) - "규칙"
```
역할: 비즈니스 규칙 (어떻게 동작해야 하는지)
예시: "메시지를 받으면 AI 추천을 생성한다"

비유: 레스토랑의 레시피 (요리 방법)
```

#### 3. Data Layer (데이터층) - "저장"
```
역할: 데이터 저장/가져오기
예시: 폰에 저장, 인터넷에서 가져오기

비유: 레스토랑의 창고 (재료 보관)
```

### 레이어 간 관계

```
Presentation (화면)
     ↓ 요청
Domain (규칙)
     ↓ 요청
Data (저장)
```

**중요한 점:**
- 화면은 규칙만 알고 있음 (저장 방법 몰라도 됨)
- 규칙은 저장 방법만 알고 있음 (화면 몰라도 됨)
- 각각 독립적으로 수정 가능!

---

## 상태 관리 (Riverpod)

### 상태 관리가 왜 필요한가요?

**문제:**
- 앱에서 데이터(예: 메시지 목록)가 바뀔 때
- 여러 화면에 동시에 반영되어야 함
- 데이터를 어디서 관리할지?

**해결: Riverpod**

### Riverpod 간단 설명

**Riverpod = 앱 전체 데이터 공유 창고**

```dart
// 1. 데이터 정의
final 메시지목록 = StateProvider<List<메시지>>((ref) => []);

// 2. 데이터 사용
class 메시지화면 extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final 목록 = ref.watch(메시지목록); // 데이터 읽기
    
    return ListView(
      children: 목록.map((메시지) => Text(메시지.내용)).toList(),
    );
  }
}

// 3. 데이터 변경
void 새메시지추가() {
  ref.read(메시지목록.notifier).state = [...기존목록, 새메시지];
}
```

**비유:**
- 학교 게시판 = Riverpod
- 누구나 읽을 수 있음 (watch)
- 누구나 업데이트할 수 있음 (notifier)
- 변경되면 모든 사람이 알 수 있음 (자동 업데이트)

### Provider vs StateProvider vs StateNotifierProvider

```dart
// Provider: 변하지 않는 값 (설정값 등)
final 앱이름 = Provider<String>((ref) => "SendBox");

// StateProvider: 간단한 값 변경 (카운터 등)
final 카운터 = StateProvider<int>((ref) => 0);

// StateNotifierProvider: 복잡한 상태 관리 (메시지 목록 등)
final 메시지목록 = StateNotifierProvider<메시지Notifier, 메시지상태>((ref) {
  return 메시지Notifier();
});
```

---

## 데이터베이스

### 왜 데이터베이스가 필요한가요?

- 메시지, 프로필, 설정 등을 저장해야 함
- 앱을 껐다 켜도 데이터가 남아있어야 함

### 로컬 데이터베이스: Isar

**Isar = 폰 안에 데이터 저장하는 도구**

```dart
// 1. 데이터 모델 정의
@collection
class 메시지 {
  Id id = Isar.autoIncrement;
  late String 내용;
  late DateTime 시간;
}

// 2. 데이터 저장
final isar = await Isar.open([메시지Schema]);
await isar.writeTxn(() async {
  await isar.메시지.put(새메시지);
});

// 3. 데이터 가져오기
final 메시지들 = await isar.메시지.where().findAll();
```

**비유:**
- 책장 = Isar
- 책 = 메시지 데이터
- 책을 찾을 때 = 쿼리 (검색)

**장점:**
- 매우 빠름
- 오프라인에서도 사용 가능
- 복잡한 검색 가능

### 클라우드 데이터베이스: Firebase Firestore

**Firestore = 인터넷에 데이터 저장하는 도구**

```
로컬 (Isar)            클라우드 (Firestore)
┌────────┐            ┌──────────┐
│ 폰 안  │  ↔ 동기화  │ 인터넷   │
└────────┘            └──────────┘
```

**왜 둘 다 사용?**
- 로컬: 빠른 접근, 오프라인 사용
- 클라우드: 백업, 여러 기기 공유

### 데이터 동기화 흐름

```
1. 메시지 받음 (폰)
   ↓
2. 로컬에 저장 (Isar) - 즉시
   ↓
3. 인터넷 있으면 클라우드에 저장 (Firestore)
   ↓
4. 다른 기기에서도 보임
```

---

## 클라우드 서비스 (Firebase)

### Firebase란?

**Firebase = Google의 백엔드 서비스 모음**

개발자가 직접 서버를 만들 필요 없이, Firebase가 대신 해줌!

### Firebase 주요 서비스

#### 1. Firebase Authentication (인증)
```
역할: 사용자 로그인 관리
예시: 이메일/비밀번호, 구글 로그인

비유: 학교 출입증 발급기
```

#### 2. Cloud Firestore (데이터베이스)
```
역할: 데이터 저장 및 동기화
예시: 메시지, 프로필 저장

비유: 구글 드라이브 (데이터 버전)
```

#### 3. Firebase Storage (파일 저장)
```
역할: 이미지, 파일 저장
예시: 프로필 사진

비유: 구글 드라이브 (파일)
```

#### 4. Firebase Crashlytics (에러 추적)
```
역할: 앱 크래시 감지 및 리포트
예시: 버그가 발생하면 자동으로 알림

비유: 자동 오류 신고 시스템
```

### Firebase 사용 예시

```dart
// 1. 로그인
final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: "user@example.com",
  password: "password123",
);

// 2. 데이터 저장
await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .set({'name': '홍길동'});

// 3. 데이터 가져오기
final snapshot = await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .get();

final data = snapshot.data(); // {'name': '홍길동'}
```

---

## AI 서비스

### AI가 어떻게 메시지를 추천하나요?

**전체 과정:**
```
1. 사용자가 메시지 받음
   ↓
2. 과거 대화 내역 수집
   ↓
3. AI에게 전달: "이 상황에서 뭐라고 답하면 좋을까?"
   ↓
4. AI가 여러 추천 메시지 생성
   ↓
5. 사용자에게 추천 메시지 보여줌
```

### Google Gemini API (온라인 AI)

**Gemini = Google의 AI 모델**

```dart
// AI에게 요청
final prompt = '''
과거 대화:
- 친구: "내일 만날까?"
- 나: "좋아"

새 메시지:
친구: "오후 2시 어때?"

적절한 답변을 3개 추천해줘.
''';

// AI 응답 받기
final response = await gemini.generateContent(prompt);
// → ["네 좋아!", "오후 2시면 괜찮아", "OK!"]
```

**비유:**
- Gemini = 천재 비서
- 질문하면 답변해줌
- 인터넷 필요 (온라인)

### TensorFlow Lite (오프라인 AI)

**TensorFlow Lite = 폰 안에 있는 작은 AI 모델**

```
온라인 (Gemini)           오프라인 (TFLite)
┌──────────┐            ┌──────────┐
│ 인터넷   │            │ 폰 안    │
│ 필요     │            │ 필요없음  │
│ 강력함   │            │ 제한적   │
└──────────┘            └──────────┘
```

**왜 둘 다?**
- 온라인: 더 똑똑함 (인터넷 필요)
- 오프라인: 항상 사용 가능 (인터넷 없어도)

**사용 전략:**
```
인터넷 있음? 
  → Yes: Gemini 사용 (더 좋은 추천)
  → No: TFLite 사용 (기본 추천)
```

### 프롬프트 엔지니어링

**프롬프트 = AI에게 주는 지시문**

```
나쁜 프롬프트:
"답변 추천해줘"
→ AI가 뭘 어떻게 해야 할지 모름

좋은 프롬프트:
"과거 대화를 분석해서,
 친근하고 정중한 톤으로
 3개의 답변을 추천해줘.
 각 답변은 50자 이내로."
→ AI가 정확히 이해하고 좋은 답변 생성
```

**SendBox에서 사용하는 프롬프트 구조:**
```
1. 역할 정의: "당신은 SendBox AI입니다"
2. 컨텍스트: 과거 대화, 프로필 정보
3. 요청: "적절한 답변을 3개 추천"
4. 제약: "간결하게, 정중하게"
```

---

## 메신저 통합

### 어떻게 다른 앱의 메시지를 가져오나요?

**3가지 방법:**

#### 1. Notification Listener (알림 감지)
```
다른 앱이 알림 보냄
   ↓
SendBox가 알림 감지
   ↓
알림에서 메시지 텍스트 추출
   ↓
SendBox에 저장
```

**비유:**
- 학교 게시판에 공지 올라옴
- 우리가 보고 내용 파악
- 우리 노트에 적어둠

#### 2. Broadcast Receiver (시스템 메시지 감지)
```
시스템: "SMS가 왔어요!"
   ↓
SendBox가 들음
   ↓
SMS 내용 가져오기
```

**주로 SMS에 사용**

#### 3. Bot API (봇 API)
```
디스코드/텔레그램 봇 생성
   ↓
봇이 메시지 받음
   ↓
봇이 SendBox에 전달
```

**주로 디스코드, 텔레그램에 사용**

### 각 플랫폼별 통합 방법

| 플랫폼 | 방법 | 설명 |
|--------|------|------|
| SMS | Broadcast Receiver | 시스템 메시지 직접 받기 |
| 카카오톡 | Notification Listener | 알림에서 텍스트 추출 |
| 디스코드 | Notification + Bot API | 알림 또는 봇 사용 |
| 텔레그램 | Notification + Bot API | 알림 또는 봇 사용 |
| 인스타그램 | Notification Listener | 알림에서 텍스트 추출 |
| 페이스북 | Notification Listener | 알림에서 텍스트 추출 |
| LINE | Notification Listener | 알림에서 텍스트 추출 |

**중요:**
- 일부 플랫폼은 API가 없어서 알림만으로는 제한적
- 완벽하지 않을 수 있음 (일부 메시지만 가능)

### 통합 아키텍처

```
각 메신저 앱
   ↓
Adapter (변환기)
   ↓
통합 메시지 형식
   ↓
SendBox 저장
```

**Adapter 패턴:**
- 각 플랫폼마다 다른 형식
- Adapter가 통일된 형식으로 변환
- SendBox는 통일된 형식만 처리

---

## 보안

### 왜 보안이 중요한가요?

- 대화 내용 = 매우 사적인 정보
- 해킹당하면 심각한 문제

### 암호화 (Encryption)

**암호화 = 읽을 수 없는 코드로 변환**

```
원본: "안녕하세요"
   ↓ 암호화
암호문: "Xk9#mP2$vL8@"
   ↓ 복호화
원본: "안녕하세요"
```

**SendBox에서 사용:**
- AES-256-GCM 알고리즘
- 매우 강력한 암호화
- 해독 거의 불가능

### Android Keystore

**Keystore = 암호화 키를 안전하게 보관하는 곳**

```
일반 저장소: 키를 그냥 파일로 저장
   → 해커가 파일 읽으면 키 노출 ❌

Keystore: 안드로이드 시스템이 보호
   → 해커가 읽을 수 없음 ✅
```

**비유:**
- 일반 금고 = 일반 저장소
- 은행 금고 = Keystore

### 전송 보안 (TLS)

**TLS = 인터넷 통신 암호화**

```
폰 → 인터넷 → 서버
   ↓ 암호화됨
해커가 가로채도 읽을 수 없음
```

**비유:**
- 일반 편지 = HTTP (누구나 읽을 수 있음)
- 암호 편지 = HTTPS/TLS (암호화되어 있음)

### 인증 (Authentication)

**인증 = "이 사람이 맞다" 확인**

```
1. 사용자: 이메일/비밀번호 입력
   ↓
2. Firebase: 확인 중...
   ↓
3. Firebase: 맞습니다! 토큰 발급
   ↓
4. SendBox: 토큰으로 이후 요청
```

**JWT 토큰:**
- 로그인 증명서
- 일정 시간 후 만료
- Refresh Token으로 갱신

---

## 개발 도구

### Git & GitHub

**Git = 코드 버전 관리 도구**

```
문제:
- 코드 수정했는데 망가짐
- 이전 버전으로 돌아가고 싶음

해결: Git
- 모든 변경사항 기록
- 언제든지 되돌리기 가능
- 여러 사람과 협업 가능
```

**기본 명령어:**
```bash
git add .           # 변경사항 추가
git commit -m "메시지"  # 저장
git push            # 서버에 업로드
git pull            # 서버에서 다운로드
```

### VS Code / Android Studio

**IDE = 코드 작성 도구**

- 코드 자동 완성
- 에러 찾기
- 디버깅 (버그 찾기)

### 패키지 관리

**pubspec.yaml = 필요한 라이브러리 목록**

```yaml
dependencies:
  flutter: ...
  riverpod: ^2.5.0    # 상태 관리
  isar: ^3.1.0        # 데이터베이스
  dio: ^5.4.0         # 네트워크
```

**비유:**
- 레시피의 재료 목록 = pubspec.yaml
- flutter pub get = 재료 구매

---

## 전체 흐름 예시

### 사용자가 메시지를 받았을 때

```
1. [Android 시스템]
   SMS 메시지 수신
   ↓
2. [Notification Listener]
   SendBox가 알림 감지
   ↓
3. [Adapter]
   SMS 형식 → SendBox 형식 변환
   ↓
4. [Repository]
   데이터베이스에 저장 (Isar)
   ↓
5. [UseCase]
   "AI 추천 생성" 로직 실행
   ↓
6. [AI Service]
   Gemini API 호출 (온라인) 또는
   TFLite 추론 (오프라인)
   ↓
7. [Repository]
   추천 메시지 저장
   ↓
8. [Riverpod]
   상태 업데이트
   ↓
9. [UI]
   화면에 추천 메시지 표시
   ↓
10. [사용자]
    추천 메시지 선택 및 전송
```

---

## 용어 정리

| 용어 | 쉬운 설명 |
|------|----------|
| **API** | 다른 프로그램과 대화하는 방법 |
| **SDK** | 개발을 쉽게 해주는 도구 모음 |
| **Repository** | 데이터를 가져오고 저장하는 곳 |
| **Provider** | 데이터를 공유하는 창고 |
| **Stream** | 계속 흐르는 데이터 (실시간) |
| **Async/Await** | 시간이 걸리는 작업 기다리기 |
| **Widget** | Flutter의 화면 구성 요소 |
| **State** | 화면의 현재 상태 (변할 수 있는 값) |

---

## 학습 자료 추천

### Flutter
- 공식 문서: https://flutter.dev/docs
- 한국어 튜토리얼: https://flutter-ko.dev/

### Dart
- 공식 문서: https://dart.dev/guides
- DartPad (온라인 연습): https://dartpad.dev/

### Clean Architecture
- 유튜브: "Clean Architecture Flutter"
- 블로그: "Flutter Clean Architecture 패턴"

### Riverpod
- 공식 문서: https://riverpod.dev/
- 예제: https://riverpod.dev/docs/introduction/getting_started

---

## 질문이 있다면?

이 문서는 계속 업데이트됩니다. 
이해가 안 되는 부분이나 추가 설명이 필요한 부분이 있으면 알려주세요!


