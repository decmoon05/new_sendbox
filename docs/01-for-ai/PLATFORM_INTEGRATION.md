# SendBox 플랫폼 통합 전략

## 🔌 통합 아키텍처 개요

### 플러그인 기반 아키텍처

```
┌─────────────────────────────────────┐
│     통합 메시지 인터페이스           │
│   (MessagingPlatformAdapter)        │
└─────────────────────────────────────┘
              ↕
┌─────────────────────────────────────┐
│      플랫폼별 어댑터                 │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │  SMS   │ │ Kakao  │ │Discord │  │
│  └────────┘ └────────┘ └────────┘  │
│  ┌────────┐ ┌────────┐             │
│  │Instagram││Telegram│             │
│  └────────┘ └────────┘             │
└─────────────────────────────────────┘
```

---

## 📱 플랫폼별 통합 전략

### 1. SMS 통합

#### 방법 1: Notification Listener Service (권장)

```kotlin
class SmsNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        // 알림에서 메시지 추출
        val message = extractMessageFromNotification(notification)
        // Flutter로 전달
        sendToFlutter(message)
    }
}
```

**장점:**
- 실시간 메시지 감지
- 시스템 권한만 필요
- 배터리 효율적

**단점:**
- 알림 텍스트가 제한될 수 있음

#### 방법 2: SMS Broadcast Receiver

```kotlin
class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val bundle = intent.extras
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        
        for (sms in messages) {
            val sender = sms.displayOriginatingAddress
            val body = sms.messageBody
            // Flutter로 전달
            sendToFlutter(sender, body)
        }
    }
}
```

**장점:**
- 정확한 메시지 내용
- 발신자 정보 확보

**단점:**
- SMS 권한 필요
- 일부 기기에서 제한

#### 방법 3: SMS Content Provider

```kotlin
class SmsContentProvider {
    fun readSms(): List<SmsMessage> {
        val cursor = contentResolver.query(
            Telephony.Sms.CONTENT_URI,
            null,
            null,
            null,
            "${Telephony.Sms.DATE} DESC"
        )
        // 커서에서 메시지 읽기
    }
}
```

**장점:**
- 전체 메시지 내역 접근
- 검색 가능

**필요 권한:**
```xml
<uses-permission android:name="android.permission.READ_SMS"/>
<uses-permission android:name="android.permission.SEND_SMS"/>
```

---

### 2. 카카오톡 통합

#### 방법 1: Notification Listener Service (주요 방법)

```kotlin
class KakaoNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        val packageName = notification?.packageName
        
        if (packageName == "com.kakao.talk") {
            // 알림에서 메시지 추출
            val message = extractKakaoMessage(notification)
            
            // 알림 확장 정보에서 전체 메시지 가져오기 시도
            val bigText = notification.notification.extras.getCharSequence(
                Notification.EXTRA_BIG_TEXT
            )
            
            sendToFlutter(message)
        }
    }
}
```

**제한사항:**
- 일부 메시지는 알림에 전체 내용이 없을 수 있음
- 이미지/미디어는 알림에서 접근 불가

#### 방법 2: Accessibility Service (보조 방법)

```kotlin
class KakaoAccessibilityService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.packageName == "com.kakao.talk") {
            // 화면 읽기 (제한적)
            val text = event.text?.joinToString()
            // Flutter로 전달
        }
    }
}
```

**제한사항:**
- 사용자 접근성 권한 필요
- 배터리 소모 증가
- 개인정보 보호 문제

#### 방법 3: 클립보드 모니터링 (선택적)

```kotlin
class ClipboardMonitor {
    fun monitorClipboard() {
        val clipboardManager = getSystemService(CLIPBOARD_SERVICE)
        clipboardManager.addPrimaryClipChangedListener {
            // 클립보드 변경 감지
        }
    }
}
```

**사용 시나리오:**
- 사용자가 메시지를 복사했을 때
- 제한적인 사용

---

### 3. 디스코드 통합

#### 방법 1: Discord Bot API (선택적, 고급)

```dart
class DiscordBotAdapter implements MessagingPlatformAdapter {
  final DiscordBotClient _client;
  
  @override
  Stream<Message> listenToMessages() async* {
    await _client.onReady();
    
    _client.onMessage.listen((discordMessage) {
      yield Message(
        id: discordMessage.id,
        content: discordMessage.content,
        sender: discordMessage.author.username,
        timestamp: discordMessage.timestamp,
      );
    });
  }
  
  @override
  Future<void> sendMessage(String to, String content) async {
    await _client.sendMessage(
      channelId: to,
      content: content,
    );
  }
}
```

**요구사항:**
- Discord Bot 토큰
- 서버 관리자 권한 (봇 초대)
- 제한적 사용 (서버 채널만 가능)

#### 방법 2: Notification Listener (주요 방법)

```kotlin
class DiscordNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.discord") {
            val message = extractDiscordMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

---

### 4. 인스타그램 DM 통합

#### 방법 1: Notification Listener

```kotlin
class InstagramNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.instagram.android") {
            val message = extractInstagramDM(notification)
            sendToFlutter(message)
        }
    }
}
```

**제한사항:**
- Instagram API는 공식적으로 DM 접근 불가
- 알림 기반만 가능
- 제한적 정보

#### 방법 2: 웹뷰 통합 (선택적)

```dart
class InstagramWebAdapter {
  WebViewController? _webViewController;
  
  Future<void> initialize() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // 페이지 로드 후 메시지 추출 시도
            _extractMessages();
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.instagram.com/direct/inbox/'));
  }
}
```

**제한사항:**
- 로그인 세션 관리 필요
- 웹 구조 변경 시 깨질 수 있음
- 보안 리스크

---

### 5. 텔레그램 통합

#### 방법 1: Telegram Bot API

```dart
class TelegramBotAdapter implements MessagingPlatformAdapter {
  final TelegramBotClient _client;
  
  @override
  Stream<Message> listenToMessages() async* {
    _client.onUpdate.listen((update) {
      if (update.message != null) {
        yield Message(
          id: update.message!.messageId.toString(),
          content: update.message!.text ?? '',
          sender: update.message!.from!.username ?? '',
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            update.message!.date * 1000,
          ),
        );
      }
    });
  }
}
```

**장점:**
- 공식 API 지원
- 완전한 메시지 접근
- 안정적

**제한사항:**
- 봇으로 받는 메시지만 가능
- 개인 메시지는 사용자가 봇에게 전달해야 함

#### 방법 2: Notification Listener

```kotlin
class TelegramNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "org.telegram.messenger") {
            val message = extractTelegramMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

---

### 6. 페이스북 메신저 (Facebook Messenger) 통합

#### 방법 1: Notification Listener (주요 방법)

```kotlin
class FacebookMessengerNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.facebook.orca" || 
            notification?.packageName == "com.facebook.mlite") {
            val message = extractFacebookMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

**제한사항:**
- Facebook Messenger API는 제한적 (주로 페이지 메시지만 가능)
- 개인 메시지는 알림 기반만 가능
- 일부 메시지는 전체 내용이 알림에 없을 수 있음

#### 방법 2: Facebook Graph API (선택적, 페이지용)

```dart
class FacebookPageAdapter implements MessagingPlatformAdapter {
  final FacebookGraphApiClient _client;
  
  @override
  Future<List<Message>> getRecentMessages({
    int limit = 50,
    DateTime? since,
  }) async {
    // Facebook 페이지 메시지만 접근 가능
    final response = await _client.get('/me/conversations');
    return _parseMessages(response);
  }
}
```

**제한사항:**
- Facebook 페이지 관리자 권한 필요
- 개인 메시지 접근 불가
- API 승인 과정 복잡

---

### 7. LINE 통합

#### 방법 1: Notification Listener (주요 방법)

```kotlin
class LineNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "jp.naver.line.android") {
            val message = extractLineMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

**특징:**
- LINE은 알림에서 메시지 내용을 잘 제공함
- 실시간 감지 가능
- 스티커, 이미지 등은 제한적

#### 방법 2: LINE Bot API (선택적)

```dart
class LineBotAdapter implements MessagingPlatformAdapter {
  final LineMessagingApiClient _client;
  
  @override
  Stream<Message> listenToMessages() async* {
    // LINE Bot API를 통한 메시지 수신
    // 웹훅을 통해 메시지 받기
    yield* _webhookStream;
  }
}
```

**제한사항:**
- 봇 채널 생성 필요
- 사용자가 봇을 친구 추가해야 함
- 개인 1:1 대화는 알림 기반이 더 적합

---

### 8. WhatsApp 통합

#### 방법 1: Notification Listener (주요 방법)

```kotlin
class WhatsAppNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.whatsapp") {
            val message = extractWhatsAppMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

**제한사항:**
- WhatsApp은 알림에서 메시지 내용이 제한될 수 있음
- 암호화된 메시지로 보안이 강함
- 일부 기기에서는 접근 제한

#### 방법 2: WhatsApp Business API (비즈니스 계정용)

```dart
class WhatsAppBusinessAdapter implements MessagingPlatformAdapter {
  final WhatsAppBusinessApiClient _client;
  
  @override
  Future<List<Message>> getRecentMessages({
    int limit = 50,
    DateTime? since,
  }) async {
    // WhatsApp Business API 사용
    final response = await _client.get('/messages');
    return _parseMessages(response);
  }
}
```

**제한사항:**
- WhatsApp Business 계정 필요
- API 승인 및 비용 발생
- 개인 계정은 불가능

---

### 9. Slack 통합

#### 방법 1: Slack Bot API (권장)

```dart
class SlackBotAdapter implements MessagingPlatformAdapter {
  final SlackApiClient _client;
  
  @override
  Stream<Message> listenToMessages() async* {
    // Slack RTM API 또는 WebSocket 사용
    _client.onMessage.listen((slackMessage) {
      yield Message(
        id: slackMessage.ts,
        content: slackMessage.text,
        sender: slackMessage.user,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (double.parse(slackMessage.ts) * 1000).toInt(),
        ),
      );
    });
  }
  
  @override
  Future<void> sendMessage({
    required String to,
    required String content,
  }) async {
    await _client.chatPostMessage(
      channel: to,
      text: content,
    );
  }
}
```

**장점:**
- 공식 API 지원
- 완전한 메시지 접근
- 웹훅 지원

#### 방법 2: Notification Listener (보조)

```kotlin
class SlackNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.Slack") {
            val message = extractSlackMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

---

### 10. Microsoft Teams 통합

#### 방법 1: Microsoft Graph API

```dart
class TeamsAdapter implements MessagingPlatformAdapter {
  final MicrosoftGraphApiClient _client;
  
  @override
  Future<List<Message>> getRecentMessages({
    int limit = 50,
    DateTime? since,
  }) async {
    final response = await _client.get('/me/chats/{chatId}/messages');
    return _parseMessages(response);
  }
}
```

**요구사항:**
- Microsoft Graph API 인증
- 적절한 권한 (Chat.Read, Chat.ReadWrite)
- 엔터프라이즈 계정

#### 방법 2: Notification Listener

```kotlin
class TeamsNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.microsoft.teams") {
            val message = extractTeamsMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

---

### 11. WeChat (위챗) 통합

#### 방법: Notification Listener (주요 방법)

```kotlin
class WeChatNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.tencent.mm") {
            val message = extractWeChatMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

**제한사항:**
- WeChat API는 매우 제한적
- 알림 기반만 가능
- 중국 내부 서비스로 접근 제한

---

### 12. Signal 통합

#### 방법: Notification Listener (유일한 방법)

```kotlin
class SignalNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "org.thoughtcrime.securesms") {
            val message = extractSignalMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

**제한사항:**
- Signal은 강력한 암호화 사용
- API 없음
- 알림에서도 제한적 정보만 가능
- 프라이버시 우선 서비스

---

### 13. Viber 통합

#### 방법: Notification Listener

```kotlin
class ViberNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.viber.voip") {
            val message = extractViberMessage(notification)
            sendToFlutter(message)
        }
    }
}
```

---

### 14. Snapchat 통합

#### 방법: Notification Listener (매우 제한적)

```kotlin
class SnapchatNotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(notification: StatusBarNotification?) {
        if (notification?.packageName == "com.snapchat.android") {
            // Snapchat은 메시지 내용을 알림에 거의 표시하지 않음
            val sender = extractSnapchatSender(notification)
            // 제한적 정보만 가능
        }
    }
}
```

**제한사항:**
- Snapchat은 자체 삭제 메시지 시스템
- 알림에 내용 표시 안 함
- 매우 제한적

---

## 🔧 통합 인터페이스 설계

### 기본 인터페이스

```dart
abstract class MessagingPlatformAdapter {
  /// 플랫폼 식별자
  String get platformId;
  
  /// 플랫폼 이름
  String get platformName;
  
  /// 플랫폼 사용 가능 여부
  Future<bool> isAvailable();
  
  /// 최근 메시지 가져오기
  Future<List<Message>> getRecentMessages({
    int limit = 50,
    DateTime? since,
  });
  
  /// 메시지 전송
  Future<void> sendMessage({
    required String to,
    required String content,
    List<String>? attachments,
  });
  
  /// 실시간 메시지 수신 스트림
  Stream<Message> listenToMessages();
  
  /// 메시지 읽음 처리
  Future<void> markAsRead(String messageId);
  
  /// 연락처 목록 가져오기
  Future<List<Contact>> getContacts();
  
  /// 초기화
  Future<void> initialize();
  
  /// 정리
  Future<void> dispose();
}
```

### 통합 메시지 모델

```dart
class UnifiedMessage {
  final String id;
  final String platform;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final MessageType type;  // sent, received
  final DateTime timestamp;
  final bool isRead;
  final List<Attachment>? attachments;
  final Map<String, dynamic> metadata;
}

enum MessageType {
  sent,
  received,
}
```

---

## 🔄 메시지 수집 서비스

### 통합 서비스

```dart
class MessageCollectionService {
  final List<MessagingPlatformAdapter> _adapters = [];
  final StreamController<UnifiedMessage> _messageController = 
      StreamController.broadcast();
  
  Stream<UnifiedMessage> get messageStream => _messageController.stream;
  
  Future<void> initialize() async {
    // 모든 어댑터 초기화
    for (final adapter in _adapters) {
      if (await adapter.isAvailable()) {
        await adapter.initialize();
        
        // 메시지 스트림 구독
        adapter.listenToMessages().listen((message) {
          _messageController.add(_convertToUnified(message, adapter));
        });
      }
    }
  }
  
  UnifiedMessage _convertToUnified(
    Message message,
    MessagingPlatformAdapter adapter,
  ) {
    return UnifiedMessage(
      id: '${adapter.platformId}_${message.id}',
      platform: adapter.platformId,
      conversationId: message.conversationId,
      senderId: message.senderId,
      senderName: message.senderName,
      content: message.content,
      type: message.type,
      timestamp: message.timestamp,
      isRead: message.isRead,
      attachments: message.attachments,
      metadata: {
        'platform': adapter.platformId,
        'original_id': message.id,
      },
    );
  }
}
```

---

## 🔐 권한 관리

### 필요한 권한

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.READ_SMS"/>
<uses-permission android:name="android.permission.SEND_SMS"/>
<uses-permission android:name="android.permission.RECEIVE_SMS"/>

<uses-permission android:name="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"/>
<uses-permission android:name="android.permission.BIND_ACCESSIBILITY_SERVICE"/>

<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

### 런타임 권한 요청

```dart
class PermissionManager {
  static Future<bool> requestNotificationAccess() async {
    // Notification Listener 권한 요청
    return await _requestRuntimePermission('notification_listener');
  }
  
  static Future<bool> requestSmsPermission() async {
    return await Permission.sms.request().isGranted;
  }
  
  static Future<bool> requestAccessibilityPermission() async {
    // 접근성 권한은 설정 화면으로 이동
    return await _openAccessibilitySettings();
  }
}
```

---

## 📊 플랫폼별 기능 매트릭스

| 플랫폼 | 메시지 수신 | 메시지 전송 | 실시간 감지 | 전체 내역 | 이미지 | 패키지명/식별자 |
|--------|------------|------------|------------|----------|--------|----------------|
| SMS    | ✅         | ✅         | ✅         | ✅       | ❌     | android.provider.Telephony |
| 카카오톡 | ⚠️        | ❌         | ✅         | ❌       | ⚠️     | com.kakao.talk |
| 디스코드 | ✅ (봇)   | ✅ (봇)   | ✅         | ✅ (봇) | ✅     | com.discord |
| 인스타그램 | ⚠️      | ❌         | ✅         | ❌       | ⚠️     | com.instagram.android |
| 텔레그램 | ✅ (봇)   | ✅ (봇)   | ✅         | ✅ (봇) | ✅     | org.telegram.messenger |
| 페이스북 메신저 | ⚠️  | ❌         | ✅         | ❌       | ⚠️     | com.facebook.orca, com.facebook.mlite |
| LINE   | ⚠️         | ❌         | ✅         | ❌       | ⚠️     | jp.naver.line.android |
| WhatsApp | ⚠️       | ❌         | ✅         | ❌       | ⚠️     | com.whatsapp |
| Slack  | ✅ (봇)   | ✅ (봇)   | ✅         | ✅ (봇) | ✅     | com.Slack |
| Microsoft Teams | ✅ (API) | ✅ (API) | ✅ | ✅ (API) | ✅ | com.microsoft.teams |
| WeChat | ⚠️         | ❌         | ✅         | ❌       | ⚠️     | com.tencent.mm |
| Signal | ⚠️         | ❌         | ✅         | ❌       | ❌     | org.thoughtcrime.securesms |
| Viber  | ⚠️         | ❌         | ✅         | ❌       | ⚠️     | com.viber.voip |
| Snapchat | ⚠️      | ❌         | ⚠️         | ❌       | ❌     | com.snapchat.android |

**범례:**
- ✅ 완전 지원
- ⚠️ 제한적 지원 (알림 기반 또는 제한적 API)
- ❌ 지원 불가
- (봇): 봇 API를 통한 지원
- (API): 공식 API를 통한 지원

**참고:**
- 알림 기반 플랫폼들은 알림 권한 필요
- 봇 API는 별도 설정 및 권한 필요
- 일부 플랫폼은 지역/계정 제한 가능

---

## 🚀 구현 우선순위

### Phase 1: 핵심 기능 (MVP)
1. ✅ **SMS** (완전 통합)
   - Broadcast Receiver
   - Notification Listener
   - 직접 전송 가능

2. ✅ **카카오톡** (알림 기반)
   - Notification Listener Service
   - 한국 시장 중요도 높음

3. ✅ **디스코드** (알림 기반)
   - Notification Listener
   - 젊은 사용자층 중요

### Phase 2: 확장 기능
4. ✅ **텔레그램** (알림 + 봇 API)
   - Notification Listener
   - Bot API (선택적)

5. ✅ **인스타그램 DM** (알림 기반)
   - Notification Listener
   - 소셜 미디어 통합

6. ✅ **LINE** (알림 기반)
   - Notification Listener
   - 일본/아시아 시장

7. ✅ **페이스북 메신저** (알림 기반)
   - Notification Listener
   - 글로벌 사용자

### Phase 3: 비즈니스 및 엔터프라이즈
8. ✅ **WhatsApp** (알림 기반)
   - Notification Listener
   - WhatsApp Business API (선택적)

9. ✅ **Slack** (봇 API)
   - Slack Bot API
   - 워크스페이스 통합

10. ✅ **Microsoft Teams** (Graph API)
    - Microsoft Graph API
    - 엔터프라이즈 환경

### Phase 4: 추가 플랫폼
11. ✅ **WeChat** (알림 기반)
    - Notification Listener
    - 중국 시장 (제한적)

12. ✅ **Signal** (알림 기반)
    - Notification Listener
    - 프라이버시 강화 앱

13. ✅ **Viber** (알림 기반)
    - Notification Listener
    - 유럽/러시아 시장

14. ⚠️ **Snapchat** (매우 제한적)
    - Notification Listener
    - 알림 내용 거의 없음 (우선순위 낮음)

---

## 🔄 실시간 동기화

### 백그라운드 서비스

```kotlin
class MessageSyncService : Service() {
    private val notificationListener = NotificationListenerService()
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // 백그라운드에서 메시지 모니터링 시작
        startForeground(NOTIFICATION_ID, createNotification())
        return START_STICKY
    }
    
    private fun monitorMessages() {
        // 모든 플랫폼 모니터링
        // 새 메시지 수신 시 Flutter로 전달
        // 로컬 DB 저장
    }
}
```

---

## 🛡️ 에러 처리 및 재시도

```dart
class PlatformAdapterWithRetry implements MessagingPlatformAdapter {
  final MessagingPlatformAdapter _adapter;
  final int _maxRetries = 3;
  
  @override
  Future<List<Message>> getRecentMessages({
    int limit = 50,
    DateTime? since,
  }) async {
    int retries = 0;
    
    while (retries < _maxRetries) {
      try {
        return await _adapter.getRecentMessages(
          limit: limit,
          since: since,
        );
      } catch (e) {
        retries++;
        if (retries >= _maxRetries) rethrow;
        await Future.delayed(Duration(seconds: retries * 2));
      }
    }
    
    throw Exception('Failed after $_maxRetries retries');
  }
}
```

---

## ✅ 다음 단계

1. 각 플랫폼별 어댑터 구현
2. Notification Listener Service 구현
3. 권한 관리 시스템 구축
4. 메시지 통합 테스트
5. 성능 최적화

