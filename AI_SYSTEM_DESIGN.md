# SendBox AI 시스템 설계

## 🤖 AI 아키텍처 개요

### 하이브리드 AI 시스템

```
┌─────────────────────────────────────┐
│      온라인 모드 (우선순위 1)        │
│   Google Gemini API                 │
│   - 고품질 추천                       │
│   - 최신 컨텍스트 분석                 │
│   - 스트리밍 응답                      │
└─────────────────────────────────────┘
              ↕ Fallback
┌─────────────────────────────────────┐
│     오프라인 모드 (우선순위 2)       │
│   TensorFlow Lite                   │
│   - 로컬 추론                          │
│   - 빠른 응답                          │
│   - 제한적 기능                        │
└─────────────────────────────────────┘
```

---

## 🔌 AI 어댑터 패턴

### 인터페이스 정의

```dart
abstract class AIServiceAdapter {
  /// 메시지 추천 생성
  Future<List<MessageRecommendation>> recommendMessages({
    required Conversation conversation,
    required ContactProfile profile,
    required Map<String, dynamic> context,
  });
  
  /// 인물 프로필 분석
  Future<ProfileAnalysis> analyzeProfile({
    required List<Conversation> conversations,
    required ContactProfile profile,
  });
  
  /// 아이템 추천 (물건, 여행지 등)
  Future<List<ItemRecommendation>> recommendItems({
    required Conversation conversation,
    required String itemType,
  });
  
  /// 대화 톤 분석
  Future<ConversationTone> analyzeTone({
    required Conversation conversation,
  });
  
  /// 사용 가능 여부 (온라인 상태 등)
  Future<bool> isAvailable();
  
  /// 모델 정보
  AIModelInfo getModelInfo();
}
```

### 구현체

1. **GeminiServiceAdapter** - 온라인 Gemini API
2. **TensorFlowLiteAdapter** - 오프라인 로컬 모델
3. **HybridAdapter** - 자동 전환 로직 포함

---

## 🌐 온라인 AI: Google Gemini API

### API 통합 구조

```dart
class GeminiService implements AIServiceAdapter {
  final GeminiApiClient _client;
  final PromptBuilder _promptBuilder;
  final ContextManager _contextManager;
  
  // 메시지 추천
  @override
  Future<List<MessageRecommendation>> recommendMessages({
    required Conversation conversation,
    required ContactProfile profile,
    required Map<String, dynamic> context,
  }) async {
    final prompt = _promptBuilder.buildMessageRecommendationPrompt(
      conversation: conversation,
      profile: profile,
      context: context,
    );
    
    final response = await _client.generateContent(
      prompt: prompt,
      stream: false,
      temperature: 0.7,
    );
    
    return _parseRecommendations(response);
  }
  
  // 스트리밍 응답
  Stream<String> streamRecommendation({
    required Conversation conversation,
    required ContactProfile profile,
  }) async* {
    final prompt = _promptBuilder.buildMessageRecommendationPrompt(
      conversation: conversation,
      profile: profile,
    );
    
    await for (final chunk in _client.streamGenerateContent(prompt)) {
      yield chunk.text;
    }
  }
}
```

### 프롬프트 엔지니어링

#### 1. 시스템 프롬프트

```dart
const systemPrompt = '''
당신은 SendBox의 AI 어시스턴트입니다.
사용자의 대화 내역과 연락처 프로필을 분석하여 
적절한 메시지 추천을 제공합니다.

원칙:
1. 대화 맥락을 정확히 파악
2. 상대방의 선호하는 대화 톤 존중
3. 간결하고 명확한 메시지
4. 문화적 맥락 고려
''';
```

#### 2. 메시지 추천 프롬프트

```dart
String buildMessageRecommendationPrompt({
  required Conversation conversation,
  required ContactProfile profile,
  required Map<String, dynamic> context,
}) {
  return '''
$systemPrompt

## 연락처 정보
- 이름: ${profile.displayName}
- 관계: ${profile.relationshipLevel}
- 선호 톤: ${profile.preferredTone}
- 관심사: ${profile.interests.join(', ')}

## 최근 대화 내역
${conversation.messages.takeLast(10).map((m) => 
  '${m.type == MessageType.sent ? "나" : profile.displayName}: ${m.content}'
).join('\n')}

## 현재 상황
- 받은 메시지: ${context['receivedMessage']}
- 시간: ${DateTime.now()}
- 플랫폼: ${context['platform']}

위 정보를 바탕으로 적절한 답변을 3개 추천해주세요.
각 추천은 다음 형식으로:
1. [톤: 정중함/친근함/비격식] [추천 메시지]
2. ...
3. ...
''';
}
```

#### 3. 프로필 분석 프롬프트

```dart
String buildProfileAnalysisPrompt({
  required List<Conversation> conversations,
  required ContactProfile profile,
}) {
  final recentMessages = conversations
      .expand((c) => c.messages)
      .takeLast(50)
      .map((m) => m.content)
      .join('\n');
  
  return '''
$systemPrompt

## 분석 대상
이름: ${profile.displayName}
전화번호: ${profile.phoneNumbers.first}

## 대화 내역 샘플
$recentMessages

위 대화 내역을 분석하여 다음 정보를 JSON 형식으로 제공해주세요:
{
  "summary": "이 사람에 대한 간단한 요약",
  "traits": {
    "친근함": 0.8,
    "정중함": 0.9,
    "활발함": 0.6
  },
  "topics": ["주요 대화 주제 리스트"],
  "preferredTone": "정중함/친근함/비격식",
  "relationshipLevel": "친구/가족/직장동료/지인"
}
''';
}
```

#### 4. 아이템 추천 프롬프트

```dart
String buildItemRecommendationPrompt({
  required Conversation conversation,
  required String itemType, // 물건, 여행지, 레스토랑 등
}) {
  return '''
$systemPrompt

## 대화 맥락
${conversation.messages.takeLast(20).join('\n')}

위 대화에서 언급된 내용을 바탕으로 
$itemType 추천을 5개 해주세요.

형식:
1. [이름] - [간단한 설명]
2. ...
''';
}
```

---

## 📱 오프라인 AI: TensorFlow Lite

### 로컬 모델 구조

#### 1. 모델 선정

- **경량 언어 모델**: MobileBERT 또는 DistilBERT 기반
- **모델 크기**: 50-100MB 이내
- **추론 속도**: < 500ms

#### 2. 모델 통합

```dart
class TensorFlowLiteService implements AIServiceAdapter {
  late Interpreter _interpreter;
  late List<String> _vocabulary;
  
  Future<void> initialize() async {
    // 모델 로드
    final modelPath = await _getModelPath();
    _interpreter = Interpreter.fromFile(modelPath);
    
    // 어휘 사전 로드
    _vocabulary = await _loadVocabulary();
  }
  
  @override
  Future<List<MessageRecommendation>> recommendMessages({
    required Conversation conversation,
    required ContactProfile profile,
    required Map<String, dynamic> context,
  }) async {
    // 텍스트 전처리
    final input = _preprocessInput(
      conversation: conversation,
      profile: profile,
    );
    
    // 토크나이징
    final tokens = _tokenize(input);
    
    // 모델 추론
    final output = _interpreter.run(tokens);
    
    // 후처리 및 추천 생성
    return _postprocessOutput(output);
  }
}
```

#### 3. 모델 학습 데이터

- 사용자의 과거 추천 피드백
- 수정된 메시지 학습
- 선호도 패턴 학습

---

## 🔄 AI 전환 로직

### 자동 전환 전략

```dart
class HybridAIService {
  final GeminiService _geminiService;
  final TensorFlowLiteService _tfliteService;
  final NetworkInfo _networkInfo;
  
  Future<List<MessageRecommendation>> recommendMessages({
    required Conversation conversation,
    required ContactProfile profile,
    required Map<String, dynamic> context,
  }) async {
    // 1. 온라인 상태 확인
    if (await _networkInfo.isConnected) {
      try {
        // 2. Gemini API 시도
        final recommendations = await _geminiService.recommendMessages(
          conversation: conversation,
          profile: profile,
          context: context,
        ).timeout(Duration(seconds: 5));
        
        return recommendations;
      } catch (e) {
        // 3. 실패 시 오프라인 모델로 fallback
        _logError('Gemini failed, falling back to TFLite', e);
      }
    }
    
    // 4. 오프라인 모델 사용
    return await _tfliteService.recommendMessages(
      conversation: conversation,
      profile: profile,
      context: context,
    );
  }
}
```

### 사용자 선택

```dart
enum AIPreference {
  auto,        // 자동 전환
  online,      // 온라인만
  offline,     // 오프라인만
}
```

---

## 🎯 AI 기능 상세 설계

### 1. 메시지 추천

#### 입력
- 대화 내역 (최근 N개 메시지)
- 연락처 프로필
- 현재 받은 메시지
- 시간/플랫폼 컨텍스트

#### 출력
- 추천 메시지 목록 (3-5개)
- 각 추천의 특징 (톤, 이유)
- 신뢰도 점수

#### 처리 흐름
```
메시지 수신
  ↓
컨텍스트 수집
  ↓
프롬프트 생성
  ↓
AI 호출 (Gemini/TFLite)
  ↓
응답 파싱
  ↓
추천 후보 생성
  ↓
필터링 및 순위 조정
  ↓
UI 표시
```

### 2. 인물 프로필 분석

#### 분석 항목
- **기본 정보**: 이름, 연락처, 플랫폼
- **관계 수준**: 친구, 가족, 직장동료, 지인
- **대화 패턴**: 주로 언급하는 주제
- **선호 톤**: 정중함, 친근함, 비격식
- **관심사**: 자주 언급하는 관심사
- **특성**: 친근함, 정중함, 활발함 등 점수화

#### 분석 주기
- 초기 분석: 대화 내역 10개 이상
- 업데이트: 새로운 대화 20개마다
- 수동 갱신: 사용자 요청 시

### 3. 아이템 추천

#### 추천 유형
- **물건**: 선물, 상품
- **여행지**: 장소, 명소
- **레스토랑**: 음식점
- **이벤트**: 행사, 활동

#### 추천 기준
- 대화에서 언급된 키워드
- 연락처의 관심사
- 시기/계절 고려
- 지역 정보

### 4. 통화 분석

#### 분석 항목
- **전사본 요약**: 주요 내용
- **할 일 항목**: 약속, 해야 할 일
- **언급된 물건/장소**: 중요한 정보
- **감정 분석**: 대화 분위기

#### 처리 흐름
```
통화 녹음
  ↓
STT 변환 (Speech-to-Text)
  ↓
텍스트 저장
  ↓
AI 분석 (Gemini/TFLite)
  ↓
요약 및 키 포인트 추출
  ↓
프로필 업데이트 (선택적)
  ↓
알림 생성 (할 일이 있는 경우)
```

---

## 📊 컨텍스트 관리

### 컨텍스트 수집

```dart
class ContextManager {
  Future<ConversationContext> buildContext({
    required Conversation conversation,
    required ContactProfile profile,
  }) async {
    return ConversationContext(
      recentMessages: conversation.messages.takeLast(10),
      profile: profile,
      timeOfDay: DateTime.now().hour,
      dayOfWeek: DateTime.now().weekday,
      previousRecommendations: await _getRecentRecommendations(),
      userPreferences: await _getUserPreferences(),
    );
  }
}
```

### 컨텍스트 제한

- 최대 토큰 수 제한 (Gemini API)
- 오래된 메시지 요약
- 중요한 메시지 우선

---

## 🎓 학습 및 개선

### 피드백 수집

```dart
class AILearningService {
  // 사용자가 추천 메시지를 수정한 경우
  Future<void> learnFromEdit({
    required String originalRecommendation,
    required String userModified,
    required ConversationContext context,
  }) async {
    // 수정 패턴 저장
    await _saveEditPattern(
      original: originalRecommendation,
      modified: userModified,
      context: context,
    );
    
    // 오프라인 모델 재학습 (선택적)
    if (shouldRetrain()) {
      await _retrainLocalModel();
    }
  }
  
  // 사용자가 추천을 선택한 경우
  Future<void> learnFromSelection({
    required String selectedRecommendation,
    required List<String> alternatives,
    required ConversationContext context,
  }) async {
    // 선호도 패턴 저장
    await _savePreference(
      selected: selectedRecommendation,
      context: context,
    );
  }
}
```

### 개인화

- 사용자별 프롬프트 커스터마이징
- 선호 스타일 학습
- 오프라인 모델 개인화

---

## ⚡ 성능 최적화

### 캐싱 전략

```dart
class AICacheService {
  final Map<String, CachedRecommendation> _cache = {};
  
  Future<List<MessageRecommendation>> getCachedOrGenerate({
    required String cacheKey,
    required Future<List<MessageRecommendation>> Function() generate,
  }) async {
    final cached = _cache[cacheKey];
    
    // 캐시가 있고 유효한 경우
    if (cached != null && !cached.isExpired) {
      return cached.recommendations;
    }
    
    // 새로운 추천 생성
    final recommendations = await generate();
    
    // 캐시 저장
    _cache[cacheKey] = CachedRecommendation(
      recommendations: recommendations,
      expiresAt: DateTime.now().add(Duration(minutes: 5)),
    );
    
    return recommendations;
  }
}
```

### 배치 처리

- 여러 대화 동시 분석
- 백그라운드 프로필 업데이트
- 효율적인 API 호출

---

## 🔒 보안 및 프라이버시

### 데이터 보호

- API 호출 시 민감 정보 제거/익명화
- 로컬 모델 데이터 암호화
- 사용자 동의 기반 데이터 사용

### 프라이버시 설정

```dart
class PrivacySettings {
  final bool allowCloudAnalysis;      // 클라우드 분석 허용
  final bool allowLearning;           // 학습 데이터 사용 허용
  final bool shareAnonymousData;      // 익명 데이터 공유
}
```

---

## 📈 모니터링 및 로깅

### AI 사용 통계

- 추천 생성 횟수
- 사용자 선택률
- 응답 시간
- 에러율

### 로깅

```dart
class AILogger {
  void logRecommendationGenerated({
    required String conversationId,
    required AIServiceType serviceType,
    required Duration responseTime,
    required int recommendationCount,
  }) {
    FirebaseAnalytics.logEvent(
      name: 'ai_recommendation_generated',
      parameters: {
        'service_type': serviceType.toString(),
        'response_time_ms': responseTime.inMilliseconds,
        'recommendation_count': recommendationCount,
      },
    );
  }
}
```

---

## ✅ 다음 단계

1. Gemini API 키 관리 시스템 구축
2. TensorFlow Lite 모델 선택 및 통합
3. 프롬프트 엔지니어링 최적화
4. 캐싱 시스템 구현
5. 성능 테스트 및 최적화

