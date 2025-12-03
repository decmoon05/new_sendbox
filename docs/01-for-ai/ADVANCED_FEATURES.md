# SendBox 고급 기능 설계

> 추가 및 발전 가능한 기능들의 상세 설계

## 📋 목차

1. [컨텍스트 인식 메시지 분류](#컨텍스트-인식-메시지-분류)
2. [스마트 메시지 분석](#스마트-메시지-분석)
3. [광고 및 스팸 차단](#광고-및-스팸-차단)
4. [일정 연동 및 관리](#일정-연동-및-관리)
5. [보안 및 사기 차단](#보안-및-사기-차단)
6. [사용자 인증 시스템](#사용자-인증-시스템)
7. [추가 고급 기능](#추가-고급-기능)

---

## 1. 컨텍스트 인식 메시지 분류

### 1.1 공적/사적 메시지 자동 구분

**문제:**
- 같은 사람이 Slack 채널과 DM으로 보낸 메시지는 다른 맥락
- 공적 메시지: 비즈니스, 형식적
- 사적 메시지: 개인적, 비격식적

**해결책: AI 기반 컨텍스트 분류**

```dart
enum MessageContext {
  public,      // 공개 채널 (Slack 채널, 디스코드 서버)
  private,     // 1:1 DM
  group,       // 그룹 채팅
  broadcast,   // 브로드캐스트 (공지사항)
  spam,        // 스팸/광고
}

class ContextAwareMessage {
  final Message message;
  final MessageContext context;
  final double confidence;  // 분류 신뢰도
  final Map<String, dynamic> metadata;
}
```

### 1.2 컨텍스트 분석 서비스

```dart
class ContextAnalysisService {
  final AIServiceAdapter _aiService;
  
  /// 메시지 컨텍스트 자동 분류
  Future<MessageContext> analyzeContext(Message message) async {
    // 1. 플랫폼 정보 확인
    final platformInfo = _getPlatformInfo(message.platform);
    
    // 2. 메시지 특성 분석
    final messageFeatures = _extractFeatures(message);
    
    // 3. AI 기반 분류
    final prompt = '''
다음 메시지의 컨텍스트를 분석해주세요:

플랫폼: ${message.platform}
수신자: ${message.recipientCount}명
내용: ${message.content}
톤: ${messageFeatures.tone}

이 메시지는:
1. 공개 채널 메시지 (public)
2. 1:1 사적 메시지 (private)
3. 그룹 채팅 (group)
4. 브로드캐스트 (broadcast)
5. 스팸/광고 (spam)

중 어떤 유형인가요? 하나만 선택하고 신뢰도를 0-1 사이로 알려주세요.
''';
    
    final analysis = await _aiService.analyzeContext(prompt);
    return analysis.context;
  }
  
  /// 컨텍스트별 프로필 관리
  Future<Profile> getContextualProfile(
    String contactId,
    MessageContext context,
  ) async {
    // 같은 사람이라도 컨텍스트별로 다른 프로필
    final profileKey = '${contactId}_${context.name}';
    return await _profileRepository.get(profileKey);
  }
}
```

### 1.3 컨텍스트별 AI 추천

```dart
class ContextualRecommendationService {
  Future<List<MessageRecommendation>> recommend({
    required Message message,
    required MessageContext context,
  }) async {
    final profile = await _contextAnalysisService.getContextualProfile(
      message.senderId,
      context,
    );
    
    // 컨텍스트에 맞는 톤 선택
    final tone = context == MessageContext.public
        ? ConversationTone.formal
        : ConversationTone.casual;
    
    return await _aiService.recommendMessages(
      conversation: message.conversation,
      profile: profile,
      context: {
        'messageContext': context.name,
        'preferredTone': tone.name,
      },
    );
  }
}
```

### 1.4 UI 표현

```dart
class MessageListItem extends StatelessWidget {
  final Conversation conversation;
  
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final contextType = conversation.messageContext;
        
        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(...),
              // 컨텍스트 표시
              if (contextType == MessageContext.public)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(Icons.groups, size: 16),
                ),
            ],
          ),
          title: Row(
            children: [
              Text(conversation.contactName),
              if (contextType == MessageContext.public)
                Chip(
                  label: Text('공개'),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        );
      },
    );
  }
}
```

---

## 2. 스마트 메시지 분석

### 2.1 DM 내용 자동 분석

```dart
class MessageAnalysisService {
  final AIServiceAdapter _aiService;
  
  /// 메시지 내용 심층 분석
  Future<MessageAnalysis> analyzeMessage(Message message) async {
    final prompt = '''
다음 메시지를 분석해주세요:

${message.content}

다음 정보를 JSON 형식으로 제공:
{
  "intent": "질문|요청|약속|정보공유|불만|칭찬|기타",
  "urgency": "긴급|중요|일반|낮음",
  "emotion": "긍정|중립|부정",
  "topics": ["주제1", "주제2"],
  "entities": {
    "people": ["인물명"],
    "locations": ["장소명"],
    "dates": ["날짜"],
    "times": ["시간"],
    "items": ["물건명"]
  },
  "actionItems": ["해야 할 일"],
  "requiresResponse": true/false,
  "responseDeadline": "날짜시간 또는 null"
}
''';
    
    final analysis = await _aiService.analyze(prompt);
    return MessageAnalysis.fromJson(analysis);
  }
}
```

### 2.2 메시지 분석 결과 모델

```dart
class MessageAnalysis {
  final MessageIntent intent;
  final UrgencyLevel urgency;
  final Emotion emotion;
  final List<String> topics;
  final ExtractedEntities entities;
  final List<String> actionItems;
  final bool requiresResponse;
  final DateTime? responseDeadline;
  final double confidence;
}

enum MessageIntent {
  question,        // 질문
  request,         // 요청
  appointment,     // 약속
  information,     // 정보 공유
  complaint,       // 불만
  compliment,      // 칭찬
  spam,            // 스팸
  other,
}

enum UrgencyLevel {
  critical,        // 긴급
  high,            // 중요
  normal,          // 일반
  low,             // 낮음
}

enum Emotion {
  positive,        // 긍정
  neutral,         // 중립
  negative,        // 부정
}

class ExtractedEntities {
  final List<String> people;
  final List<String> locations;
  final List<DateTime> dates;
  final List<TimeOfDay> times;
  final List<String> items;
}
```

### 2.3 우선순위 기반 정렬

```dart
class SmartMessageSorter {
  List<Conversation> sortByPriority(
    List<Conversation> conversations,
  ) {
    return conversations
      ..sort((a, b) {
        // 1. 긴급도
        final urgencyDiff = b.analysis.urgency.index - 
                           a.analysis.urgency.index;
        if (urgencyDiff != 0) return urgencyDiff;
        
        // 2. 응답 필요 여부
        if (a.analysis.requiresResponse != 
            b.analysis.requiresResponse) {
          return a.analysis.requiresResponse ? -1 : 1;
        }
        
        // 3. 시간
        return b.lastMessageAt.compareTo(a.lastMessageAt);
      });
  }
}
```

### 2.4 액션 아이템 자동 추출

```dart
class ActionItemExtractor {
  Future<List<ActionItem>> extractActionItems(Message message) async {
    final analysis = await _messageAnalysisService.analyzeMessage(message);
    
    return analysis.actionItems.map((item) {
      return ActionItem(
        id: Uuid().v4(),
        title: item,
        sourceMessageId: message.id,
        sourceContactId: message.senderId,
        dueDate: analysis.responseDeadline,
        priority: analysis.urgency,
        status: ActionItemStatus.pending,
        createdAt: DateTime.now(),
      );
    }).toList();
  }
}
```

---

## 3. 광고 및 스팸 차단

### 3.1 스팸 감지 시스템

```dart
class SpamDetectionService {
  final AIServiceAdapter _aiService;
  final SpamPatternDatabase _patternDatabase;
  
  /// 스팸/광고 메시지 감지
  Future<SpamDetectionResult> detectSpam(Message message) async {
    // 1. 패턴 기반 감지
    final patternMatch = _patternDatabase.checkPatterns(message.content);
    if (patternMatch.isSpam) {
      return SpamDetectionResult(
        isSpam: true,
        confidence: patternMatch.confidence,
        reason: patternMatch.reason,
        method: DetectionMethod.pattern,
      );
    }
    
    // 2. AI 기반 감지
    final aiResult = await _detectWithAI(message);
    if (aiResult.isSpam) {
      return aiResult;
    }
    
    // 3. URL/링크 분석
    final urlAnalysis = _analyzeUrls(message.content);
    if (urlAnalysis.isSuspicious) {
      return SpamDetectionResult(
        isSpam: true,
        confidence: urlAnalysis.confidence,
        reason: '의심스러운 링크 포함',
        method: DetectionMethod.url,
      );
    }
    
    return SpamDetectionResult(isSpam: false);
  }
  
  Future<SpamDetectionResult> _detectWithAI(Message message) async {
    final prompt = '''
다음 메시지가 스팸/광고 메시지인지 판단해주세요:

${message.content}

판단 기준:
1. 상업적 목적 (제품/서비스 홍보)
2. 과도한 링크/URL 포함
3. 짧은 시간 내 반복 전송
4. 수상한 도메인 주소
5. 요청하지 않은 정보

JSON 형식:
{
  "isSpam": true/false,
  "confidence": 0.0-1.0,
  "reason": "이유",
  "category": "광고|피싱|스캠|일반스팸"
}
''';
    
    final result = await _aiService.analyze(prompt);
    return SpamDetectionResult.fromJson(result);
  }
}
```

### 3.2 스팸 패턴 데이터베이스

```dart
class SpamPatternDatabase {
  final List<SpamPattern> _patterns = [
    // URL 패턴
    SpamPattern(
      type: PatternType.url,
      pattern: RegExp(r'https?://[^\s]+'),
      weight: 0.3,
    ),
    // 단축 URL
    SpamPattern(
      type: PatternType.shortUrl,
      pattern: RegExp(r'(bit\.ly|t\.co|tinyurl|goo\.gl)'),
      weight: 0.5,
    ),
    // 광고 키워드
    SpamPattern(
      type: PatternType.keyword,
      pattern: RegExp(r'(무료|할인|특가|이벤트|당첨|확인|클릭)'),
      weight: 0.4,
    ),
    // 반복 문자
    SpamPattern(
      type: PatternType.repetition,
      pattern: RegExp(r'(.)\1{5,}'),  // 같은 문자 6번 이상
      weight: 0.3,
    ),
  ];
  
  SpamPatternMatch checkPatterns(String content) {
    double totalScore = 0.0;
    List<String> reasons = [];
    
    for (final pattern in _patterns) {
      if (pattern.pattern.hasMatch(content)) {
        totalScore += pattern.weight;
        reasons.add(pattern.type.name);
      }
    }
    
    return SpamPatternMatch(
      isSpam: totalScore > 0.6,
      confidence: totalScore.clamp(0.0, 1.0),
      reason: reasons.join(', '),
    );
  }
}
```

### 3.3 자동 차단 및 필터링

```dart
class SpamFilterService {
  final SpamDetectionService _detectionService;
  final MessageRepository _messageRepository;
  
  Stream<Message> filterSpam(Stream<Message> messageStream) async* {
    await for (final message in messageStream) {
      final detection = await _detectionService.detectSpam(message);
      
      if (detection.isSpam) {
        // 스팸으로 표시
        await _messageRepository.markAsSpam(message.id, detection);
        
        // 사용자 설정에 따라 처리
        final settings = await _settingsRepository.getSpamSettings();
        
        if (settings.autoBlock) {
          // 자동 차단
          await _blockContact(message.senderId);
        } else {
          // 스팸 폴더로 이동
          yield* _handleSpam(message, detection);
        }
      } else {
        // 정상 메시지
        yield message;
      }
    }
  }
}
```

### 3.4 사용자 피드백 학습

```dart
class SpamLearningService {
  Future<void> learnFromFeedback({
    required String messageId,
    required bool userMarkedAsSpam,
    required bool wasCorrect,
  }) async {
    final message = await _messageRepository.getMessage(messageId);
    final originalDetection = await _getOriginalDetection(messageId);
    
    if (!wasCorrect) {
      // AI 모델 재학습 데이터 추가
      await _addTrainingData(
        message: message,
        label: userMarkedAsSpam ? 'spam' : 'ham',
        originalPrediction: originalDetection.isSpam,
      );
      
      // 패턴 업데이트
      if (userMarkedAsSpam) {
        await _updatePatterns(message.content);
      }
    }
  }
}
```

---

## 4. 일정 연동 및 관리

### 4.1 일정 자동 추출

```dart
class CalendarIntegrationService {
  final MessageAnalysisService _messageAnalysis;
  final CalendarService _calendarService;
  
  /// 메시지에서 일정 추출
  Future<List<CalendarEvent>> extractEvents(Message message) async {
    final analysis = await _messageAnalysis.analyzeMessage(message);
    
    // 날짜/시간 정보 추출
    final dates = analysis.entities.dates;
    final times = analysis.entities.times;
    
    if (dates.isEmpty) return [];
    
    return dates.map((date) {
      final time = times.isNotEmpty ? times.first : null;
      final location = analysis.entities.locations.isNotEmpty
          ? analysis.entities.locations.first
          : null;
      
      return CalendarEvent(
        id: Uuid().v4(),
        title: _generateEventTitle(message, analysis),
        description: message.content,
        startDate: date,
        startTime: time,
        location: location,
        attendees: analysis.entities.people,
        sourceMessageId: message.id,
        sourceContactId: message.senderId,
        reminderMinutes: [15, 60], // 1시간 전, 15분 전 알림
        createdAt: DateTime.now(),
      );
    }).toList();
  }
  
  String _generateEventTitle(Message message, MessageAnalysis analysis) {
    // AI로 일정 제목 생성
    if (analysis.intent == MessageIntent.appointment) {
      return '${message.senderName}님과의 약속';
    }
    // 기타 로직...
  }
}
```

### 4.2 캘린더 서비스 연동

```dart
abstract class CalendarService {
  Future<void> createEvent(CalendarEvent event);
  Future<List<CalendarEvent>> getUpcomingEvents({int days = 7});
  Future<void> updateEvent(CalendarEvent event);
  Future<void> deleteEvent(String eventId);
}

class GoogleCalendarService implements CalendarService {
  final GoogleCalendarApiClient _client;
  
  @override
  Future<void> createEvent(CalendarEvent event) async {
    final googleEvent = GoogleCalendarEvent(
      summary: event.title,
      description: event.description,
      start: EventDateTime(
        dateTime: _combineDateTime(event.startDate, event.startTime),
        timeZone: 'Asia/Seoul',
      ),
      location: event.location,
      attendees: event.attendees.map((name) => 
        EventAttendee(email: _getEmailByName(name))
      ).toList(),
      reminders: EventReminders(
        useDefault: false,
        overrides: event.reminderMinutes.map((minutes) =>
          EventReminder(method: 'popup', minutes: minutes)
        ).toList(),
      ),
    );
    
    await _client.events.insert(googleEvent, 'primary');
  }
}

class AppleCalendarService implements CalendarService {
  // iOS 캘린더 연동
}

class LocalCalendarService implements CalendarService {
  // 로컬 캘린더 저장
}
```

### 4.3 일정 확인 및 알림

```dart
class CalendarNotificationService {
  final CalendarService _calendarService;
  final NotificationService _notificationService;
  
  /// 다가오는 일정 확인
  Future<void> checkUpcomingEvents() async {
    final upcoming = await _calendarService.getUpcomingEvents(days: 1);
    
    for (final event in upcoming) {
      final timeUntil = event.startDate.difference(DateTime.now());
      
      // 1시간 전 알림
      if (timeUntil.inHours == 1 && !event.notified1Hour) {
        await _notificationService.show(
          title: '일정 알림',
          body: '1시간 후 "${event.title}" 일정이 있습니다.',
          data: {'eventId': event.id},
        );
        await _markNotified1Hour(event.id);
      }
      
      // 15분 전 알림
      if (timeUntil.inMinutes == 15 && !event.notified15Min) {
        await _notificationService.show(
          title: '일정 알림',
          body: '15분 후 "${event.title}" 일정이 있습니다.',
          data: {'eventId': event.id},
        );
        await _markNotified15Min(event.id);
      }
    }
  }
}
```

### 4.4 일정 제안 및 자동 스케줄링

```dart
class SmartSchedulingService {
  final CalendarService _calendarService;
  final AIServiceAdapter _aiService;
  
  /// 자동 일정 제안
  Future<List<DateTime>> suggestTimes({
    required String contactId,
    required Duration duration,
    required DateTime preferredStart,
    int suggestions = 3,
  }) async {
    // 1. 기존 일정 확인
    final existingEvents = await _calendarService.getUpcomingEvents(days: 30);
    
    // 2. 빈 시간대 찾기
    final freeSlots = _findFreeSlots(
      existingEvents: existingEvents,
      duration: duration,
      preferredStart: preferredStart,
    );
    
    // 3. 상대방 프로필 확인 (선호 시간대 등)
    final profile = await _profileRepository.get(contactId);
    final preferredTimes = profile.preferredMeetingTimes;
    
    // 4. AI로 최적 시간 추천
    return await _aiService.suggestOptimalTimes(
      freeSlots: freeSlots,
      preferences: preferredTimes,
      count: suggestions,
    );
  }
}
```

---

## 5. 보안 및 사기 차단

### 5.1 런타임 스캠/사기 차단

```dart
class ScamDetectionService {
  final AIServiceAdapter _aiService;
  final ScamPatternDatabase _scamPatterns;
  
  /// 사기 메시지 감지
  Future<ScamDetectionResult> detectScam(Message message) async {
    // 1. 피싱 패턴 확인
    final phishingResult = _checkPhishingPatterns(message);
    if (phishingResult.isScam) return phishingResult;
    
    // 2. 금전 요청 확인
    final financialResult = _checkFinancialRequests(message);
    if (financialResult.isScam) return financialResult;
    
    // 3. AI 기반 사기 감지
    final aiResult = await _detectScamWithAI(message);
    if (aiResult.isScam) return aiResult;
    
    // 4. URL 안전성 확인
    final urlSafety = await _checkUrlSafety(message);
    if (!urlSafety.isSafe) {
      return ScamDetectionResult(
        isScam: true,
        confidence: urlSafety.riskScore,
        reason: '의심스러운 링크',
        category: ScamCategory.suspiciousLink,
      );
    }
    
    return ScamDetectionResult(isScam: false);
  }
  
  ScamDetectionResult _checkPhishingPatterns(Message message) {
    final phishingPatterns = [
      RegExp(r'비밀번호.*확인'),
      RegExp(r'계좌.*인증'),
      RegExp(r'정보.*업데이트.*필요'),
      RegExp(r'즉시.*클릭'),
      RegExp(r'지금.*안하면.*계정.*정지'),
    ];
    
    for (final pattern in phishingPatterns) {
      if (pattern.hasMatch(message.content)) {
        return ScamDetectionResult(
          isScam: true,
          confidence: 0.8,
          reason: '피싱 패턴 감지',
          category: ScamCategory.phishing,
        );
      }
    }
    
    return ScamDetectionResult(isScam: false);
  }
  
  ScamDetectionResult _checkFinancialRequests(Message message) {
    final financialKeywords = [
      '송금', '이체', '입금', '대출', '투자',
      '보안카드', 'OTP', '인증번호',
    ];
    
    final hasFinancialKeyword = financialKeywords.any(
      (keyword) => message.content.contains(keyword),
    );
    
    if (hasFinancialKeyword) {
      // 금전 관련 메시지 - 추가 검증 필요
      return ScamDetectionResult(
        isScam: false,  // 의심스럽지만 확정 아님
        confidence: 0.5,
        reason: '금전 관련 메시지 - 주의 필요',
        category: ScamCategory.financial,
        requiresWarning: true,
      );
    }
    
    return ScamDetectionResult(isScam: false);
  }
}
```

### 5.2 URL 안전성 검사

```dart
class UrlSafetyChecker {
  final SafeBrowsingApiClient _safeBrowsingClient;
  final UrlReputationDatabase _reputationDb;
  
  Future<UrlSafetyResult> checkUrlSafety(String url) async {
    // 1. 로컬 블랙리스트 확인
    final localCheck = _reputationDb.check(url);
    if (localCheck.isBlacklisted) {
      return UrlSafetyResult(
        isSafe: false,
        riskScore: 1.0,
        reason: '알려진 악성 사이트',
      );
    }
    
    // 2. Google Safe Browsing API
    final safeBrowsingResult = await _safeBrowsingClient.check(url);
    if (!safeBrowsingResult.isSafe) {
      return UrlSafetyResult(
        isSafe: false,
        riskScore: safeBrowsingResult.threatLevel,
        reason: safeBrowsingResult.threatType,
      );
    }
    
    // 3. 도메인 신뢰도 확인
    final domain = _extractDomain(url);
    final domainReputation = await _checkDomainReputation(domain);
    
    return UrlSafetyResult(
      isSafe: domainReputation.score > 0.7,
      riskScore: 1.0 - domainReputation.score,
      reason: domainReputation.reason,
    );
  }
}
```

### 5.3 실시간 경고 시스템

```dart
class SecurityAlertService {
  final ScamDetectionService _scamDetection;
  final NotificationService _notificationService;
  
  Stream<SecurityAlert> monitorMessages(Stream<Message> messages) async* {
    await for (final message in messages) {
      final scamResult = await _scamDetection.detectScam(message);
      
      if (scamResult.isScam || scamResult.requiresWarning) {
        final alert = SecurityAlert(
          id: Uuid().v4(),
          messageId: message.id,
          level: scamResult.isScam 
              ? AlertLevel.critical 
              : AlertLevel.warning,
          category: scamResult.category,
          reason: scamResult.reason,
          timestamp: DateTime.now(),
        );
        
        // 사용자에게 즉시 알림
        await _notificationService.show(
          title: '⚠️ 보안 경고',
          body: _generateAlertMessage(alert, message),
          priority: NotificationPriority.high,
          actions: [
            NotificationAction(
              id: 'block',
              title: '차단',
            ),
            NotificationAction(
              id: 'ignore',
              title: '무시',
            ),
          ],
        );
        
        yield alert;
      }
    }
  }
  
  String _generateAlertMessage(SecurityAlert alert, Message message) {
    switch (alert.category) {
      case ScamCategory.phishing:
        return '피싱 시도가 감지되었습니다. 개인정보를 입력하지 마세요.';
      case ScamCategory.financial:
        return '금전 관련 메시지입니다. 주의가 필요합니다.';
      case ScamCategory.suspiciousLink:
        return '의심스러운 링크가 포함되어 있습니다. 클릭하지 마세요.';
      default:
        return '보안 경고: ${alert.reason}';
    }
  }
}
```

### 5.4 보안 대시보드

```dart
class SecurityDashboard {
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final securityStats = ref.watch(securityStatsProvider);
        final recentAlerts = ref.watch(recentSecurityAlertsProvider);
        
        return ListView(
          children: [
            // 보안 통계 카드
            _SecurityStatsCard(stats: securityStats),
            
            // 최근 경고 목록
            _RecentAlertsList(alerts: recentAlerts),
            
            // 차단된 연락처 목록
            _BlockedContactsList(),
            
            // 보안 설정
            _SecuritySettingsSection(),
          ],
        );
      },
    );
  }
}
```

---

## 6. 사용자 인증 시스템

### 6.1 회원가입 및 로그인

```dart
class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;
  
  /// 이메일 회원가입
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // 1. Firebase Auth로 계정 생성
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // 2. 사용자 정보 업데이트
      await userCredential.user?.updateDisplayName(displayName);
      
      // 3. 사용자 프로필 생성
      await _userRepository.createProfile(
        userId: userCredential.user!.uid,
        email: email,
        displayName: displayName,
      );
      
      return AuthResult.success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(e.message ?? '회원가입 실패');
    }
  }
  
  /// 소셜 로그인
  Future<AuthResult> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      return AuthResult.failure('로그인이 취소되었습니다.');
    }
    
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return AuthResult.success(userCredential.user!);
  }
}
```

### 6.2 프로필 관리

```dart
class UserProfileService {
  final UserRepository _userRepository;
  
  Future<UserProfile> getProfile(String userId) async {
    return await _userRepository.getProfile(userId);
  }
  
  Future<void> updateProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
    Map<String, dynamic>? preferences,
  }) async {
    await _userRepository.updateProfile(
      userId: userId,
      displayName: displayName,
      photoUrl: photoUrl,
      preferences: preferences,
    );
  }
  
  Future<void> deleteAccount(String userId) async {
    // 1. 모든 데이터 삭제
    await _deleteAllUserData(userId);
    
    // 2. Firebase Auth 계정 삭제
    await FirebaseAuth.instance.currentUser?.delete();
    
    // 3. 로그아웃
    await FirebaseAuth.instance.signOut();
  }
}
```

---

## 7. 추가 고급 기능

### 7.1 스마트 알림 관리

```dart
class SmartNotificationService {
  /// 중요도 기반 알림 필터링
  Future<bool> shouldShowNotification(Message message) async {
    final analysis = await _messageAnalysis.analyzeMessage(message);
    
    // 긴급한 메시지는 항상 알림
    if (analysis.urgency == UrgencyLevel.critical) {
      return true;
    }
    
    // 집중 모드 시간 확인
    if (await _isFocusModeActive()) {
      return analysis.requiresResponse;
    }
    
    // 사용자 알림 설정 확인
    final settings = await _notificationSettings.get(message.senderId);
    return settings.enabled;
  }
  
  /// 알림 그룹핑
  Future<List<NotificationGroup>> groupNotifications(
    List<Message> messages,
  ) async {
    // 같은 사람의 여러 메시지를 그룹핑
    final groups = <String, List<Message>>{};
    
    for (final message in messages) {
      final key = message.senderId;
      groups.putIfAbsent(key, () => []).add(message);
    }
    
    return groups.entries.map((entry) {
      return NotificationGroup(
        contactId: entry.key,
        messages: entry.value,
        count: entry.value.length,
      );
    }).toList();
  }
}
```

### 7.2 대화 요약 기능

```dart
class ConversationSummaryService {
  final AIServiceAdapter _aiService;
  
  /// 대화 내용 요약
  Future<ConversationSummary> summarize(Conversation conversation) async {
    final prompt = '''
다음 대화 내용을 요약해주세요:

${conversation.messages.map((m) => 
  '${m.senderName}: ${m.content}'
).join('\n')}

다음 형식으로 요약:
{
  "summary": "전체 요약 (3-5줄)",
  "keyPoints": ["주요 내용 1", "주요 내용 2"],
  "decisions": ["결정 사항"],
  "actionItems": ["해야 할 일"],
  "sentiment": "긍정|중립|부정"
}
''';
    
    final result = await _aiService.analyze(prompt);
    return ConversationSummary.fromJson(result);
  }
}
```

### 7.3 메시지 템플릿 저장

```dart
class MessageTemplateService {
  final TemplateRepository _templateRepository;
  
  /// 자주 사용하는 메시지를 템플릿으로 저장
  Future<void> saveTemplate({
    required String userId,
    required String content,
    required String category,
    List<String>? tags,
  }) async {
    final template = MessageTemplate(
      id: Uuid().v4(),
      userId: userId,
      content: content,
      category: category,
      tags: tags ?? [],
      useCount: 0,
      lastUsedAt: null,
      createdAt: DateTime.now(),
    );
    
    await _templateRepository.save(template);
  }
  
  /// 컨텍스트에 맞는 템플릿 추천
  Future<List<MessageTemplate>> recommendTemplates({
    required String contactId,
    required MessageContext context,
  }) async {
    final templates = await _templateRepository.getByUser(userId);
    
    // AI로 컨텍스트에 맞는 템플릿 필터링
    return await _aiService.filterTemplates(
      templates: templates,
      context: context,
      contactId: contactId,
    );
  }
}
```

### 7.4 메시지 번역 기능

```dart
class TranslationService {
  final GoogleTranslateApiClient _translateClient;
  
  /// 메시지 자동 번역
  Future<TranslatedMessage> translate({
    required Message message,
    required String targetLanguage,
  }) async {
    final translation = await _translateClient.translate(
      text: message.content,
      target: targetLanguage,
      source: message.detectedLanguage,
    );
    
    return TranslatedMessage(
      original: message.content,
      translated: translation.text,
      sourceLanguage: translation.sourceLanguage,
      targetLanguage: targetLanguage,
      confidence: translation.confidence,
    );
  }
  
  /// 실시간 대화 번역
  Stream<TranslatedMessage> translateStream({
    required Stream<Message> messages,
    required String targetLanguage,
  }) async* {
    await for (final message in messages) {
      yield await translate(
        message: message,
        targetLanguage: targetLanguage,
      );
    }
  }
}
```

### 7.5 메시지 검색 및 필터

```dart
class MessageSearchService {
  final MessageRepository _messageRepository;
  
  /// 고급 검색
  Future<List<Message>> search({
    String? query,
    String? senderId,
    DateTime? fromDate,
    DateTime? toDate,
    List<String>? platforms,
    MessageIntent? intent,
    bool? hasAttachment,
  }) async {
    return await _messageRepository.search(
      query: query,
      senderId: senderId,
      fromDate: fromDate,
      toDate: toDate,
      platforms: platforms,
      intent: intent,
      hasAttachment: hasAttachment,
    );
  }
  
  /// 의미 기반 검색 (AI)
  Future<List<Message>> semanticSearch(String query) async {
    // AI로 쿼리 의미 분석
    final queryEmbedding = await _aiService.embedText(query);
    
    // 유사한 의미의 메시지 찾기
    return await _messageRepository.findSimilar(
      embedding: queryEmbedding,
      threshold: 0.7,
    );
  }
}
```

---

## 구현 우선순위

### Phase 1: 핵심 기능 (MVP)
1. ✅ 기본 메시지 수신/전송
2. ✅ AI 메시지 추천
3. ✅ 기본 프로필 관리

### Phase 2: 스마트 기능
4. ✅ 컨텍스트 인식 (공적/사적 구분)
5. ✅ 메시지 분석 (의도, 긴급도)
6. ✅ 스팸/광고 차단
7. ✅ 기본 일정 추출

### Phase 3: 보안 강화
8. ✅ 사기/스캠 차단
9. ✅ URL 안전성 검사
10. ✅ 보안 경고 시스템

### Phase 4: 고급 기능
11. ✅ 완전한 일정 연동
12. ✅ 사용자 인증 시스템
13. ✅ 대화 요약
14. ✅ 템플릿 관리

### Phase 5: 최적화
15. ✅ 스마트 알림
16. ✅ 메시지 번역
17. ✅ 고급 검색

---

## 데이터 모델 확장

필요한 추가 모델들을 데이터베이스 스키마에 반영해야 합니다.

---

## 다음 단계

1. 각 기능별 상세 설계 문서 작성
2. 데이터 모델 확장
3. API 설계
4. UI/UX 와이어프레임


