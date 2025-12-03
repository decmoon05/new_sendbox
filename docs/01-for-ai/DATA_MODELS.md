# 데이터 모델 상세 설계

> SendBox 프로젝트 데이터 모델 상세 명세

## 📋 목차

1. [도메인 엔티티](#도메인-엔티티)
2. [데이터 모델](#데이터-모델)
3. [로컬 데이터베이스 스키마](#로컬-데이터베이스-스키마)
4. [클라우드 데이터베이스 스키마](#클라우드-데이터베이스-스키마)
5. [모델 변환](#모델-변환)

---

## 도메인 엔티티

### Message (메시지)

```dart
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final MessageType type;  // sent, received
  final DateTime timestamp;
  final bool isRead;
  final List<Attachment>? attachments;
  final Map<String, dynamic> metadata;  // 플랫폼별 추가 정보
}

enum MessageType {
  sent,
  received,
}

class Attachment {
  final String id;
  final String type;  // image, video, audio, file
  final String url;
  final String? thumbnailUrl;
  final int? size;  // bytes
  final String? mimeType;
}
```

---

### Conversation (대화)

```dart
class Conversation {
  final String id;
  final String contactId;
  final String platform;  // sms, kakao, discord, etc.
  final List<Message> messages;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isPinned;
  final Map<String, dynamic> metadata;
  
  // Computed properties
  Message? get lastMessage => messages.isNotEmpty 
    ? messages.last 
    : null;
}
```

---

### ContactProfile (연락처 프로필)

```dart
class ContactProfile {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? photoUrl;
  
  // 플랫폼별 식별자
  final List<PlatformIdentifier> platforms;
  
  // AI 분석 결과
  final ProfileAnalysis? aiAnalysis;
  
  // 사용자 태그 및 메모
  final List<String> tags;
  final String? notes;
  
  // 중요도 (사용자 설정)
  final int priority;  // 1-5
  
  final DateTime createdAt;
  final DateTime updatedAt;
}

class PlatformIdentifier {
  final String platform;  // sms, kakao, discord, etc.
  final String identifier;  // 전화번호, 카카오톡 ID, 등
  final DateTime? lastMessageAt;
  final int messageCount;
}

class ProfileAnalysis {
  final String tone;  // formal, casual, friendly
  final List<String> interests;
  final String relationship;  // friend, family, colleague, etc.
  final String communicationStyle;  // brief, detailed, emojis
  final List<String> topics;
  final String sentiment;  // positive, neutral, negative
  final DateTime analyzedAt;
}
```

---

### AIRecommendation (AI 추천)

```dart
class AIRecommendation {
  final String id;
  final String conversationId;
  final String messageContext;  // 원본 메시지 또는 컨텍스트
  final List<MessageOption> recommendations;
  final RecommendationType type;  // message, item, travel
  final DateTime createdAt;
  final bool isUsed;
  final String? selectedOptionId;
}

class MessageOption {
  final String id;
  final String message;
  final String tone;
  final String reason;
  final int confidence;  // 0-100
}

enum RecommendationType {
  message,    // 메시지 추천
  item,       // 물건 추천
  travel,     // 여행지 추천
}
```

---

### CallRecord (통화 기록)

```dart
class CallRecord {
  final String id;
  final String contactId;
  final DateTime startTime;
  final DateTime? endTime;
  final Duration? duration;
  final CallType type;  // incoming, outgoing, missed
  final String? audioFileUrl;  // 녹음 파일
  final String? transcript;  // 텍스트 변환 결과
  final CallAnalysis? analysis;  // AI 분석 결과
}

enum CallType {
  incoming,
  outgoing,
  missed,
}

class CallAnalysis {
  final String summary;
  final List<String> keyPoints;
  final String sentiment;
  final List<String> actionItems;  // 할 일 목록
  final DateTime analyzedAt;
}
```

---

### SyncStatus (동기화 상태)

```dart
class SyncStatus {
  final String id;
  final SyncType type;  // conversation, profile, etc.
  final String entityId;
  final SyncState state;  // pending, syncing, synced, error
  final DateTime? lastSyncedAt;
  final String? errorMessage;
  final int retryCount;
}

enum SyncType {
  conversation,
  profile,
  callRecord,
}

enum SyncState {
  pending,
  syncing,
  synced,
  error,
}
```

---

## 데이터 모델

### 로컬 데이터베이스 (Isar) 모델

Isar는 Dart 코드 생성 사용:

```dart
@collection
class ConversationModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String conversationId;
  
  late String contactId;
  late String platform;
  late DateTime lastMessageAt;
  late int unreadCount;
  late bool isPinned;
  
  final messages = IsarLinks<MessageModel>();
}

@collection
class MessageModel {
  Id id = Isar.autoIncrement;
  
  @Index()
  late String messageId;
  
  late String conversationId;
  late String senderId;
  late String? senderName;
  late String content;
  late String type;  // "sent", "received"
  late DateTime timestamp;
  late bool isRead;
}
```

---

### 클라우드 데이터베이스 (Firestore) 모델

JSON 형식으로 저장:

```dart
// Firestore Document
{
  "id": "conv_123",
  "contactId": "contact_456",
  "platform": "sms",
  "messages": [
    {
      "id": "msg_789",
      "senderId": "user_123",
      "content": "안녕하세요",
      "type": "sent",
      "timestamp": "2024-01-01T12:00:00Z",
      "isRead": true
    }
  ],
  "lastMessageAt": "2024-01-01T12:00:00Z",
  "encrypted": false,
  "syncedAt": "2024-01-01T12:05:00Z"
}
```

---

## 모델 변환

### Entity ↔ Model 변환

```dart
// Domain Entity → Data Model
extension ConversationModelX on ConversationModel {
  Conversation toEntity() {
    return Conversation(
      id: conversationId,
      contactId: contactId,
      platform: platform,
      messages: messages.map((m) => m.toEntity()).toList(),
      lastMessageAt: lastMessageAt,
      unreadCount: unreadCount,
      isPinned: isPinned,
      metadata: {},
    );
  }
}

// Data Model → Domain Entity
extension ConversationX on Conversation {
  ConversationModel toModel() {
    return ConversationModel()
      ..conversationId = id
      ..contactId = contactId
      ..platform = platform
      ..lastMessageAt = lastMessageAt
      ..unreadCount = unreadCount
      ..isPinned = isPinned;
  }
}
```

---

### Entity ↔ JSON 변환

```dart
// Domain Entity → JSON (for Firestore)
extension ConversationJsonX on Conversation {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactId': contactId,
      'platform': platform,
      'messages': messages.map((m) => m.toJson()).toList(),
      'lastMessageAt': Timestamp.fromDate(lastMessageAt),
      'unreadCount': unreadCount,
      'isPinned': isPinned,
      'metadata': metadata,
    };
  }
  
  static Conversation fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      contactId: json['contactId'],
      platform: json['platform'],
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList(),
      lastMessageAt: (json['lastMessageAt'] as Timestamp).toDate(),
      unreadCount: json['unreadCount'] ?? 0,
      isPinned: json['isPinned'] ?? false,
      metadata: json['metadata'] ?? {},
    );
  }
}
```

---

## 데이터 검증

### 유효성 검사 규칙

```dart
class MessageValidator {
  static ValidationResult validate(Message message) {
    final errors = <String>[];
    
    if (message.content.isEmpty) {
      errors.add('메시지 내용은 비어있을 수 없습니다.');
    }
    
    if (message.content.length > 10000) {
      errors.add('메시지는 10,000자를 초과할 수 없습니다.');
    }
    
    if (message.timestamp.isAfter(DateTime.now())) {
      errors.add('메시지 타임스탬프는 미래일 수 없습니다.');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}
```

---

## 데이터 무결성

### 제약 조건

1. **Conversation ↔ Message**: 1:N 관계
   - Conversation 삭제 시 관련 Message도 삭제

2. **ContactProfile ↔ Conversation**: 1:N 관계
   - ContactProfile 삭제 시 관련 Conversation은 보존 (참조만 제거)

3. **Message ID**: 고유해야 함

4. **동기화 충돌 해결**:
   - Last-Write-Wins 정책
   - 타임스탬프 기반 병합

---

**데이터 모델은 개발 과정에서 요구사항에 맞게 지속적으로 업데이트됩니다.**

