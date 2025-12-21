# 테스트 전략

> SendBox 프로젝트 테스트 계획 및 전략

## 📋 목차

1. [테스트 목표](#테스트-목표)
2. [테스트 피라미드](#테스트-피라미드)
3. [단위 테스트](#단위-테스트)
4. [통합 테스트](#통합-테스트)
5. [위젯 테스트](#위젯-테스트)
6. [E2E 테스트](#e2e-테스트)
7. [테스트 커버리지](#테스트-커버리지)
8. [CI/CD 통합](#cicd-통합)

---

## 테스트 목표

### 핵심 목표
- 코드 품질 보장
- 리팩토링 안전성 확보
- 버그 조기 발견
- 문서화 효과

### 커버리지 목표
- **단위 테스트**: 80% 이상
- **통합 테스트**: 핵심 기능 100%
- **위젯 테스트**: 주요 UI 컴포넌트 70% 이상

---

## 테스트 피라미드

```
        ┌─────────────┐
        │  E2E Tests  │  (적음)
        │   (5-10%)   │
        ├─────────────┤
        │  Widget     │
        │   Tests     │  (중간)
        │  (20-30%)   │
        ├─────────────┤
        │ Integration │
        │   Tests     │  (중간)
        │  (20-30%)   │
        ├─────────────┤
        │   Unit      │
        │   Tests     │  (많음)
        │  (60-70%)   │
        └─────────────┘
```

---

## 단위 테스트

### 테스트 대상

#### Domain Layer

**UseCases 테스트:**

```dart
// test/domain/usecases/conversation/get_conversations_test.dart

void main() {
  late GetConversations usecase;
  late MockConversationRepository mockRepository;

  setUp(() {
    mockRepository = MockConversationRepository();
    usecase = GetConversations(mockRepository);
  });

  group('GetConversations', () {
    final tConversations = [
      Conversation(id: '1', ...),
      Conversation(id: '2', ...),
    ];

    test('should get conversations from repository', () async {
      // Arrange
      when(mockRepository.getConversations())
          .thenAnswer((_) async => Right(tConversations));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Right(tConversations));
      verify(mockRepository.getConversations()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(mockRepository.getConversations())
          .thenAnswer((_) async => Left(ServerFailure()));

      // Act
      final result = await usecase();

      // Assert
      expect(result, Left(ServerFailure()));
    });
  });
}
```

**Entities 테스트:**

```dart
// test/domain/entities/message_test.dart

void main() {
  group('Message', () {
    test('should create message with valid data', () {
      // Arrange
      const message = Message(
        id: '1',
        conversationId: 'conv_1',
        senderId: 'user_1',
        content: 'Hello',
        type: MessageType.sent,
        timestamp: DateTime(2024, 1, 1),
        isRead: false,
      );

      // Assert
      expect(message.id, '1');
      expect(message.content, 'Hello');
      expect(message.type, MessageType.sent);
    });

    test('should validate message content', () {
      // Test validation logic
    });
  });
}
```

#### Data Layer

**Repository 구현 테스트:**

```dart
// test/data/repositories/conversation_repository_impl_test.dart

void main() {
  late ConversationRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ConversationRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConversations', () {
    test('should return local data when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getConversations())
          .thenAnswer((_) async => tConversations);

      // Act
      final result = await repository.getConversations();

      // Assert
      verifyNever(mockRemoteDataSource.getConversations());
      verify(mockLocalDataSource.getConversations()).called(1);
      expect(result, Right(tConversations));
    });

    test('should return remote data and cache when online', () async {
      // Test online scenario
    });
  });
}
```

**Service 테스트:**

```dart
// test/data/services/ai/gemini_service_test.dart

void main() {
  late GeminiService service;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    service = GeminiService(dio: mockDio);
  });

  group('recommendMessages', () {
    test('should return recommendations on success', () async {
      // Arrange
      final response = Response(
        data: {
          'candidates': [
            {
              'content': {
                'parts': [
                  {'text': '{"recommendations": [...]}'}
                ]
              }
            }
          ]
        },
        statusCode: 200,
      );
      when(mockDio.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => response);

      // Act
      final result = await service.recommendMessages(
        conversation: tConversation,
        profile: tProfile,
      );

      // Assert
      expect(result, isA<List<MessageRecommendation>>());
    });
  });
}
```

---

## 통합 테스트

### Repository 통합 테스트

```dart
// test/integration/repository/conversation_repository_test.dart

void main() {
  late Isar database;
  late ConversationRepository repository;

  setUpAll(() async {
    database = await Isar.open(
      [ConversationModelSchema, MessageModelSchema],
      directory: Directory.systemTemp.path,
    );
  });

  tearDownAll(() async {
    await database.close();
  });

  setUp(() {
    repository = ConversationRepositoryImpl(
      localDataSource: ConversationLocalDataSource(database),
      remoteDataSource: ConversationRemoteDataSource(),
      networkInfo: NetworkInfoImpl(),
    );
  });

  test('should save and retrieve conversation', () async {
    // Arrange
    final conversation = Conversation(...);

    // Act
    await repository.saveConversation(conversation);
    final result = await repository.getConversation(conversation.id);

    // Assert
    expect(result, Right(conversation));
  });
}
```

---

## 위젯 테스트

### 위젯 테스트 예시

```dart
// test/presentation/widgets/message_bubble_test.dart

void main() {
  testWidgets('MessageBubble should display message content', (tester) async {
    // Arrange
    const message = Message(
      id: '1',
      content: 'Hello, World!',
      type: MessageType.sent,
      timestamp: DateTime(2024, 1, 1),
      isRead: false,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageBubble(message: message),
        ),
      ),
    );

    // Assert
    expect(find.text('Hello, World!'), findsOneWidget);
  });

  testWidgets('MessageBubble should show sent style for sent messages', (tester) async {
    // Test UI styling
  });
}
```

### Riverpod Provider 테스트

```dart
// test/presentation/providers/chat_provider_test.dart

void main() {
  testWidgets('ChatProvider should load conversations', (tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        conversationRepositoryProvider.overrideWithValue(
          MockConversationRepository(),
        ),
      ],
    );

    // Act
    final conversations = container.read(chatProvider);

    // Assert
    expect(conversations, isA<AsyncValue<List<Conversation>>>());
  });
}
```

---

## E2E 테스트

### Integration Test

```dart
// integration_test/app_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Complete message recommendation flow', (tester) async {
      // 1. Launch app
      await tester.pumpWidget(const SendBoxApp());
      await tester.pumpAndSettle();

      // 2. Navigate to chat
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      // 3. Select conversation
      await tester.tap(find.text('John Doe'));
      await tester.pumpAndSettle();

      // 4. Request AI recommendation
      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pumpAndSettle();

      // 5. Verify recommendation appears
      expect(find.text('AI 추천'), findsOneWidget);
      expect(find.byType(MessageOptionCard), findsWidgets);

      // 6. Select recommendation
      await tester.tap(find.byType(MessageOptionCard).first);
      await tester.pumpAndSettle();

      // 7. Verify message is prepared
      expect(find.text('Send'), findsOneWidget);
    });
  });
}
```

---

## 테스트 커버리지

### 커버리지 측정

```bash
# 커버리지 리포트 생성
flutter test --coverage

# HTML 리포트 보기
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 커버리지 목표

| 레이어 | 목표 커버리지 |
|--------|--------------|
| Domain (UseCases) | 90% |
| Domain (Entities) | 100% |
| Data (Repositories) | 80% |
| Data (Services) | 70% |
| Presentation (Widgets) | 60% |
| Presentation (Providers) | 80% |

---

## CI/CD 통합

### GitHub Actions 워크플로우

```yaml
# .github/workflows/test.yml

name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run tests
      run: flutter test --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage/lcov.info
```

---

## 테스트 도구

### 사용할 패키지

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Mocking
  mockito: ^5.4.4
  mocktail: ^1.0.1
  
  # Integration testing
  integration_test:
    sdk: flutter
  
  # Golden tests
  golden_toolkit: ^0.15.0
  
  # Test utilities
  bloc_test: ^9.1.5
```

---

## 테스트 베스트 프랙티스

### 1. AAA 패턴

```dart
test('should do something', () {
  // Arrange - 준비
  final service = MockService();
  
  // Act - 실행
  final result = service.doSomething();
  
  // Assert - 검증
  expect(result, expected);
});
```

### 2. 테스트 격리

- 각 테스트는 독립적이어야 함
- 공유 상태 피하기
- `setUp`과 `tearDown` 사용

### 3. 의미 있는 테스트 이름

```dart
// ❌ 나쁜 예
test('test1', () {...});

// ✅ 좋은 예
test('should return error when network is unavailable', () {...});
```

### 4. 한 번에 하나만 테스트

```dart
// ❌ 나쁜 예
test('should validate and save', () {...});

// ✅ 좋은 예
test('should validate input', () {...});
test('should save when valid', () {...});
```

---

## 성능 테스트

### 메모리 누수 테스트

```dart
test('should not leak memory', () async {
  final service = MemoryLeakTestService();
  
  for (int i = 0; i < 1000; i++) {
    await service.processData(data);
  }
  
  // 메모리 사용량 확인
  expect(getMemoryUsage(), lessThan(maxMemory));
});
```

---

**테스트 전략은 개발 진행에 따라 지속적으로 개선됩니다.**


