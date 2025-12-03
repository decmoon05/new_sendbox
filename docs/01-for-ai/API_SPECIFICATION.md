# API 명세서

> SendBox 프로젝트 API 설계 및 명세

## 📋 목차

1. [API 아키텍처](#api-아키텍처)
2. [Firebase API](#firebase-api)
3. [Google Gemini API](#google-gemini-api)
4. [자체 백엔드 API](#자체-백엔드-api)
5. [플랫폼별 API](#플랫폼별-api)
6. [에러 처리](#에러-처리)

---

## API 아키텍처

### 하이브리드 API 구조

```
┌─────────────────────────────────────┐
│      클라이언트 (Flutter App)        │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│      API 클라이언트 (Dio)            │
│  - 인터셉터                         │
│  - 에러 핸들링                      │
│  - 로깅                            │
└─────────────────────────────────────┘
    ↕              ↕              ↕
┌─────────┐  ┌──────────┐  ┌──────────┐
│Firebase │  │Gemini API│  │자체 백엔드│
│Firestore│  │          │  │REST API  │
│Auth     │  │          │  │          │
│Storage  │  │          │  │          │
└─────────┘  └──────────┘  └──────────┘
```

---

## Firebase API

### Authentication

#### Sign Up (회원가입)

**Endpoint:** Firebase Auth

```dart
Future<UserCredential> signUp({
  required String email,
  required String password,
});
```

**Request:**
- `email`: 사용자 이메일
- `password`: 비밀번호 (최소 8자)

**Response:**
```dart
UserCredential {
  user: User {
    uid: String,
    email: String,
    displayName: String?,
  }
}
```

**에러:**
- `email-already-in-use`: 이미 사용 중인 이메일
- `weak-password`: 비밀번호가 너무 약함
- `invalid-email`: 유효하지 않은 이메일

---

#### Sign In (로그인)

**Endpoint:** Firebase Auth

```dart
Future<UserCredential> signIn({
  required String email,
  required String password,
});
```

**Response:** `UserCredential`

**에러:**
- `user-not-found`: 사용자를 찾을 수 없음
- `wrong-password`: 잘못된 비밀번호
- `user-disabled`: 계정이 비활성화됨

---

#### Sign Out (로그아웃)

```dart
Future<void> signOut();
```

---

### Firestore Database

#### User Document Structure

**Collection:** `users/{userId}`

```dart
{
  "uid": String,
  "email": String,
  "displayName": String?,
  "createdAt": Timestamp,
  "updatedAt": Timestamp,
  "preferences": {
    "language": String,  // "ko", "en"
    "theme": String,     // "light", "dark", "system"
    "notifications": bool,
  },
  "subscription": {
    "tier": String,      // "free", "premium"
    "expiresAt": Timestamp?,
  }
}
```

---

#### Sync Conversation

**Collection:** `users/{userId}/conversations/{conversationId}`

**Write:**

```dart
Future<void> syncConversation({
  required String userId,
  required Conversation conversation,
});
```

**Document Structure:**
```dart
{
  "id": String,
  "contactId": String,
  "platform": String,        // "sms", "kakao", "discord", etc.
  "encrypted": bool,         // true if encrypted
  "messages": [
    {
      "id": String,
      "senderId": String,
      "content": String,     // Encrypted if encrypted=true
      "type": String,        // "sent", "received"
      "timestamp": Timestamp,
      "isRead": bool,
    }
  ],
  "lastMessageAt": Timestamp,
  "syncedAt": Timestamp,
}
```

**Read:**

```dart
Future<List<Conversation>> getConversations({
  required String userId,
  int? limit,
  DateTime? after,
});
```

---

#### Sync Profile

**Collection:** `users/{userId}/profiles/{profileId}`

```dart
Future<void> syncProfile({
  required String userId,
  required ContactProfile profile,
});
```

**Document Structure:**
```dart
{
  "id": String,
  "name": String,
  "phoneNumber": String?,
  "encrypted": bool,
  "platforms": [
    {
      "platform": String,
      "identifier": String,
      "lastMessageAt": Timestamp,
    }
  ],
  "aiAnalysis": {
    "tone": String,          // "formal", "casual", "friendly"
    "interests": [String],
    "relationship": String,   // "friend", "family", "colleague", etc.
    "lastAnalyzedAt": Timestamp,
  },
  "syncedAt": Timestamp,
}
```

---

### Firebase Storage

#### Upload Media

**Path:** `users/{userId}/media/{messageId}/{filename}`

```dart
Future<String> uploadMedia({
  required String userId,
  required String messageId,
  required File file,
  required String mimeType,
});
```

**Response:** Download URL

---

## Google Gemini API

### Message Recommendation (메시지 추천)

**Endpoint:** `https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent`

**Method:** POST

**Headers:**
```
Content-Type: application/json
Authorization: Bearer {API_KEY}
```

**Request:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "{prompt}"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 1024,
  }
}
```

**Prompt Template:**
```
You are an AI assistant helping users write personalized messages.

Context:
- Contact Name: {contactName}
- Relationship: {relationship}
- Conversation History: {conversationHistory}
- Contact Profile: {contactProfile}
- Message Context: {messageContext}

Task: Generate {count} message recommendations that are:
- Appropriate for the relationship
- Match the conversation tone
- Natural and authentic
- Respectful and considerate

Return the recommendations as a JSON array:
[
  {
    "message": "message text",
    "tone": "formal|casual|friendly",
    "reason": "brief explanation"
  }
]
```

**Response:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "[\n  {\n    \"message\": \"안녕하세요, 오늘 잘 보내셨나요?\",\n    \"tone\": \"formal\",\n    \"reason\": \"정중한 인사\"\n  }\n]"
          }
        ]
      }
    }
  ]
}
```

---

### Profile Analysis (프로필 분석)

**Endpoint:** Same as above

**Prompt Template:**
```
Analyze the following conversation history and provide insights about the contact:

Conversation History: {conversationHistory}

Provide analysis in JSON format:
{
  "tone": "formal|casual|friendly",
  "interests": ["interest1", "interest2"],
  "relationship": "friend|family|colleague|acquaintance",
  "communicationStyle": "brief|detailed|emojis",
  "topics": ["topic1", "topic2"],
  "sentiment": "positive|neutral|negative"
}
```

---

### Item Recommendation (아이템 추천)

**Prompt Template:**
```
Based on the conversation, recommend {itemType} that might interest this person:

Conversation: {conversation}
Contact Profile: {contactProfile}

Return recommendations as JSON array:
[
  {
    "item": "item name",
    "reason": "why recommended",
    "category": "category"
  }
]
```

---

## 자체 백엔드 API

### Base URL

**Development:** `https://api-dev.sendbox.app/v1`
**Production:** `https://api.sendbox.app/v1`

---

### Authentication

모든 요청에 JWT 토큰 필요:

```
Authorization: Bearer {jwt_token}
```

---

### Endpoints

#### GET /users/me

현재 사용자 정보 조회

**Response:**
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "createdAt": "2024-01-01T00:00:00Z",
  "preferences": {
    "language": "ko",
    "theme": "dark"
  }
}
```

---

#### POST /sync/conversations

대화 내역 동기화

**Request:**
```json
{
  "conversations": [
    {
      "id": "conv_id",
      "contactId": "contact_id",
      "platform": "sms",
      "messages": [...],
      "lastMessageAt": "2024-01-01T00:00:00Z"
    }
  ]
}
```

**Response:**
```json
{
  "synced": 10,
  "conflicts": 0,
  "syncedAt": "2024-01-01T00:00:00Z"
}
```

---

#### GET /sync/conversations

동기화된 대화 내역 조회

**Query Parameters:**
- `limit`: int (기본값: 50)
- `offset`: int (기본값: 0)
- `platform`: string? (필터)
- `after`: ISO 8601 datetime?

**Response:**
```json
{
  "conversations": [...],
  "total": 100,
  "hasMore": true
}
```

---

## 플랫폼별 API

### Discord Bot API

**Base URL:** `https://discord.com/api/v10`

**Endpoints:**
- `POST /channels/{channelId}/messages` - 메시지 전송
- `GET /channels/{channelId}/messages` - 메시지 조회

**Authentication:**
```
Authorization: Bot {BOT_TOKEN}
```

---

### Telegram Bot API

**Base URL:** `https://api.telegram.org/bot{BOT_TOKEN}`

**Endpoints:**
- `POST /sendMessage` - 메시지 전송
- `GET /getUpdates` - 메시지 조회

---

### Slack API

**Base URL:** `https://slack.com/api`

**Endpoints:**
- `POST /chat.postMessage` - 메시지 전송
- `GET /conversations.history` - 대화 내역 조회

**Authentication:**
```
Authorization: Bearer {SLACK_TOKEN}
```

---

## 에러 처리

### 공통 에러 형식

```dart
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      // Additional error details
    }
  }
}
```

### 에러 코드

| 코드 | HTTP 상태 | 설명 |
|------|-----------|------|
| `UNAUTHORIZED` | 401 | 인증 필요 |
| `FORBIDDEN` | 403 | 권한 없음 |
| `NOT_FOUND` | 404 | 리소스를 찾을 수 없음 |
| `VALIDATION_ERROR` | 400 | 유효성 검사 실패 |
| `RATE_LIMIT_EXCEEDED` | 429 | 요청 한도 초과 |
| `INTERNAL_ERROR` | 500 | 서버 내부 오류 |
| `SERVICE_UNAVAILABLE` | 503 | 서비스 이용 불가 |

---

## API 클라이언트 구현

### Dio 설정

```dart
final dio = Dio(
  BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
    },
  ),
);

// Interceptor 추가
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      // JWT 토큰 추가
      final token = authService.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (error, handler) {
      // 에러 처리
      return handler.next(error);
    },
  ),
);
```

---

**이 API 명세서는 개발 과정에서 지속적으로 업데이트됩니다.**

