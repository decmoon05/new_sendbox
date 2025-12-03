# 확장성 및 유연성 개발 원칙

> SendBox 프로젝트의 확장 가능하고 유연한 코드 작성 가이드

## 🎯 핵심 원칙

**"하드코딩 금지, 확장성 우선"**

- 오랜 시간이 걸려도 하드코딩 지양
- 미래의 변경사항에 대비한 확장 가능한 설계
- 기능 추가나 서버 변경에 유연하게 대응

---

## 📋 목차

1. [일반 원칙](#일반-원칙)
2. [설정 관리](#설정-관리)
3. [서버/API 아키텍처](#서버api-아키텍처)
4. [기능 확장 전략](#기능-확장-전략)
5. [디자인 패턴 활용](#디자인-패턴-활용)
6. [코드 예시](#코드-예시)
7. [체크리스트](#체크리스트)

---

## 1. 일반 원칙

### 1.1 하드코딩 금지

#### ❌ 나쁜 예시 (하드코딩)

```dart
// 하드코딩된 API 엔드포인트
final response = await http.get('https://api.sendbox.app/v1/messages');

// 하드코딩된 설정값
if (messageCount > 50) {
  // ...
}

// 하드코딩된 플랫폼 목록
final platforms = ['sms', 'kakao', 'discord'];
```

#### ✅ 좋은 예시 (확장 가능)

```dart
// 설정 파일에서 읽기
final baseUrl = AppConfig.apiBaseUrl;
final response = await http.get('$baseUrl/messages');

// 상수 파일에서 관리
if (messageCount > AppConstants.maxMessageCount) {
  // ...
}

// 동적으로 가져오기
final platforms = PlatformRegistry.getAvailablePlatforms();
```

### 1.2 추상화 원칙

#### 계층화된 추상화

```
구체적 구현 (Implementation)
    ↑
추상 인터페이스 (Interface)
    ↑
비즈니스 로직 (Business Logic)
```

**예시:**

```dart
// ❌ 나쁜 예시: 직접 구현에 의존
class MessageService {
  Future<List<Message>> getMessages() async {
    return await FirebaseFirestore.instance
        .collection('messages')
        .get()
        .then((snapshot) => ...);
  }
}

// ✅ 좋은 예시: 추상화된 인터페이스 사용
abstract class MessageRepository {
  Future<List<Message>> getMessages();
}

class FirestoreMessageRepository implements MessageRepository {
  @override
  Future<List<Message>> getMessages() async {
    // Firebase 구현
  }
}

class ApiMessageRepository implements MessageRepository {
  @override
  Future<List<Message>> getMessages() async {
    // API 구현
  }
}
```

### 1.3 설정 기반 개발

**모든 설정값은 외부에서 관리:**

```dart
// ✅ 좋은 예시: 설정 클래스
class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.sendbox.app',
  );
  
  static const int maxRetryAttempts = int.fromEnvironment(
    'MAX_RETRY_ATTEMPTS',
    defaultValue: 3,
  );
  
  static const Duration requestTimeout = Duration(
    seconds: int.fromEnvironment(
      'REQUEST_TIMEOUT_SECONDS',
      defaultValue: 30,
    ),
  );
}

// 사용
final response = await http.get(
  '${AppConfig.apiBaseUrl}/messages',
).timeout(AppConfig.requestTimeout);
```

---

## 2. 설정 관리

### 2.1 환경 변수 사용

```dart
class EnvironmentConfig {
  // API 설정
  static String get apiBaseUrl => 
    _getEnv('API_BASE_URL', 'https://api.sendbox.app');
  
  static String get apiKey => 
    _getEnv('API_KEY', '');
  
  // 서버 설정
  static String get serverType => 
    _getEnv('SERVER_TYPE', 'firebase'); // firebase, custom, hybrid
  
  // 기능 플래그
  static bool get enableAdvancedFeatures => 
    _getEnvBool('ENABLE_ADVANCED_FEATURES', false);
  
  static bool get enableOfflineMode => 
    _getEnvBool('ENABLE_OFFLINE_MODE', true);
  
  // 헬퍼 메서드
  static String _getEnv(String key, String defaultValue) {
    return String.fromEnvironment(key, defaultValue: defaultValue);
  }
  
  static bool _getEnvBool(String key, bool defaultValue) {
    final value = String.fromEnvironment(key, defaultValue: '');
    if (value.isEmpty) return defaultValue;
    return value.toLowerCase() == 'true';
  }
}
```

### 2.2 설정 파일 사용

**`lib/core/config/app_config.yaml`:**

```yaml
api:
  base_url: "https://api.sendbox.app"
  timeout_seconds: 30
  retry_attempts: 3

server:
  type: "firebase"  # firebase, custom, hybrid
  endpoints:
    firebase:
      auth: "https://identitytoolkit.googleapis.com"
      firestore: "https://firestore.googleapis.com"
    custom:
      base_url: "https://api.sendbox.app"
      auth: "/auth"
      messages: "/messages"

features:
  advanced_ai: false
  offline_mode: true
  call_recording: true

limits:
  max_messages_per_batch: 100
  max_conversation_history: 1000
```

**설정 로더:**

```dart
class ConfigLoader {
  static Future<AppConfig> load() async {
    // YAML 파일 로드
    final configFile = await rootBundle.loadString('config/app_config.yaml');
    final config = loadYaml(configFile);
    
    // 환경 변수로 오버라이드
    return AppConfig.fromYaml(config).overrideWithEnv();
  }
}
```

### 2.3 런타임 설정 변경

```dart
abstract class ConfigService {
  Future<void> updateConfig(Map<String, dynamic> updates);
  T get<T>(String key, T defaultValue);
  Stream<T> watch<T>(String key);
}

class DynamicConfigService implements ConfigService {
  final Map<String, dynamic> _config = {};
  
  @override
  Future<void> updateConfig(Map<String, dynamic> updates) async {
    _config.addAll(updates);
    await _saveToStorage();
    _notifyListeners();
  }
  
  @override
  T get<T>(String key, T defaultValue) {
    return _config[key] as T? ?? defaultValue;
  }
}
```

---

## 3. 서버/API 아키텍처

### 3.1 서버 추상화 레이어

**문제 상황:**
- 현재는 Firebase 사용
- 미래에 자체 서버로 변경 가능
- 하이브리드 방식 필요할 수 있음

**해결: 서버 추상화**

```dart
// 서버 타입 열거
enum ServerType {
  firebase,
  custom,
  hybrid,
}

// 서버 인터페이스
abstract class ServerAdapter {
  Future<AuthResult> authenticate(Credentials credentials);
  Future<List<Message>> fetchMessages({required String userId});
  Future<void> sendMessage(Message message);
  Future<void> syncData(SyncData data);
}

// Firebase 구현
class FirebaseServerAdapter implements ServerAdapter {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  
  @override
  Future<AuthResult> authenticate(Credentials credentials) async {
    // Firebase 인증 구현
  }
  
  @override
  Future<List<Message>> fetchMessages({required String userId}) async {
    // Firestore 구현
  }
}

// 자체 서버 구현
class CustomServerAdapter implements ServerAdapter {
  final ApiClient _apiClient;
  
  @override
  Future<AuthResult> authenticate(Credentials credentials) async {
    // REST API 구현
  }
  
  @override
  Future<List<Message>> fetchMessages({required String userId}) async {
    // REST API 구현
  }
}

// 하이브리드 구현
class HybridServerAdapter implements ServerAdapter {
  final FirebaseServerAdapter _firebase;
  final CustomServerAdapter _custom;
  final ConfigService _config;
  
  @override
  Future<AuthResult> authenticate(Credentials credentials) async {
    final serverType = _config.get<ServerType>('auth_server', ServerType.firebase);
    
    return serverType == ServerType.firebase
        ? await _firebase.authenticate(credentials)
        : await _custom.authenticate(credentials);
  }
}
```

### 3.2 서버 팩토리 패턴

```dart
class ServerAdapterFactory {
  static ServerAdapter create(ServerType type, ConfigService config) {
    switch (type) {
      case ServerType.firebase:
        return FirebaseServerAdapter();
      
      case ServerType.custom:
        return CustomServerAdapter(
          apiClient: ApiClient(
            baseUrl: config.get<String>('custom_server_url'),
          ),
        );
      
      case ServerType.hybrid:
        return HybridServerAdapter(
          firebase: FirebaseServerAdapter(),
          custom: CustomServerAdapter(
            apiClient: ApiClient(
              baseUrl: config.get<String>('custom_server_url'),
            ),
          ),
          config: config,
        );
    }
  }
  
  // 설정에서 자동 생성
  static ServerAdapter fromConfig(ConfigService config) {
    final serverType = ServerType.values.firstWhere(
      (type) => type.name == config.get<String>('server_type', 'firebase'),
      orElse: () => ServerType.firebase,
    );
    
    return create(serverType, config);
  }
}
```

### 3.3 동적 서버 전환

```dart
class ServerManager {
  ServerAdapter? _currentAdapter;
  final ConfigService _config;
  
  ServerManager(this._config);
  
  Future<void> initialize() async {
    _currentAdapter = ServerAdapterFactory.fromConfig(_config);
    
    // 설정 변경 감지
    _config.watch<ServerType>('server_type').listen((newType) {
      _switchServer(newType);
    });
  }
  
  Future<void> _switchServer(ServerType newType) async {
    // 기존 연결 정리
    await _currentAdapter?.dispose();
    
    // 새 서버 연결
    _currentAdapter = ServerAdapterFactory.create(newType, _config);
    await _currentAdapter?.initialize();
  }
  
  ServerAdapter get adapter {
    if (_currentAdapter == null) {
      throw StateError('Server not initialized');
    }
    return _currentAdapter!;
  }
}
```

---

## 4. 기능 확장 전략

### 4.1 플러그인 아키텍처

**문제:** 새로운 메신저 플랫폼이나 기능 추가

**해결: 플러그인 시스템**

```dart
// 플러그인 인터페이스
abstract class MessagingPlugin {
  String get pluginId;
  String get pluginName;
  Future<bool> isAvailable();
  Future<void> initialize();
  Future<List<Message>> getMessages();
  Future<void> sendMessage(Message message);
  Stream<Message> listenToMessages();
}

// 플러그인 레지스트리
class PluginRegistry {
  final Map<String, MessagingPlugin> _plugins = {};
  final ConfigService _config;
  
  Future<void> loadPlugins() async {
    // 설정에서 활성화된 플러그인 목록 가져오기
    final enabledPlugins = _config.get<List<String>>(
      'enabled_plugins',
      ['sms', 'kakao', 'discord'],
    );
    
    // 각 플러그인 로드
    for (final pluginId in enabledPlugins) {
      final plugin = await _createPlugin(pluginId);
      if (await plugin.isAvailable()) {
        await plugin.initialize();
        _plugins[pluginId] = plugin;
      }
    }
  }
  
  Future<MessagingPlugin> _createPlugin(String pluginId) async {
    // 동적으로 플러그인 생성
    switch (pluginId) {
      case 'sms':
        return SmsPlugin();
      case 'kakao':
        return KakaoPlugin();
      case 'discord':
        return DiscordPlugin();
      // 새로운 플러그인 추가 시 여기만 수정
      default:
        throw ArgumentError('Unknown plugin: $pluginId');
    }
  }
  
  List<MessagingPlugin> get activePlugins => _plugins.values.toList();
}
```

### 4.2 기능 플래그 시스템

```dart
class FeatureFlagService {
  final ConfigService _config;
  final Map<String, bool> _flags = {};
  
  Future<void> initialize() async {
    // 서버에서 기능 플래그 가져오기
    final flags = await _fetchFeatureFlags();
    _flags.addAll(flags);
    
    // 로컬 설정 오버라이드
    _flags.addAll(_loadLocalFlags());
    
    // 실시간 업데이트 구독
    _subscribeToFlagUpdates();
  }
  
  bool isEnabled(String flagName, {bool defaultValue = false}) {
    return _flags[flagName] ?? defaultValue;
  }
  
  Stream<bool> watchFlag(String flagName) {
    return _config.watch<bool>(flagName);
  }
  
  Future<Map<String, bool>> _fetchFeatureFlags() async {
    // 서버에서 가져오기 (또는 로컬)
    return {
      'advanced_ai': false,
      'call_recording': true,
      'multi_device_sync': false,
    };
  }
}

// 사용 예시
class AIRecommendationService {
  final FeatureFlagService _featureFlags;
  
  Future<List<Recommendation>> recommend(Message message) async {
    if (_featureFlags.isEnabled('advanced_ai')) {
      return await _advancedAIRecommend(message);
    } else {
      return await _basicAIRecommend(message);
    }
  }
}
```

### 4.3 확장 가능한 메시지 처리 파이프라인

```dart
// 처리 단계 인터페이스
abstract class MessageProcessor {
  Future<Message> process(Message message);
  int get priority; // 처리 순서
}

// 처리 파이프라인
class MessageProcessingPipeline {
  final List<MessageProcessor> _processors = [];
  
  void addProcessor(MessageProcessor processor) {
    _processors.add(processor);
    _processors.sort((a, b) => a.priority.compareTo(b.priority));
  }
  
  Future<Message> process(Message message) async {
    var processedMessage = message;
    
    for (final processor in _processors) {
      processedMessage = await processor.process(processedMessage);
    }
    
    return processedMessage;
  }
}

// 사용 예시
class MessageService {
  final MessageProcessingPipeline _pipeline;
  
  MessageService() : _pipeline = MessageProcessingPipeline() {
    // 기본 프로세서들
    _pipeline.addProcessor(SpamDetectionProcessor(priority: 1));
    _pipeline.addProcessor(TranslationProcessor(priority: 2));
    _pipeline.addProcessor(AIAnalysisProcessor(priority: 3));
    
    // 동적으로 추가 가능
    if (FeatureFlagService().isEnabled('encryption')) {
      _pipeline.addProcessor(EncryptionProcessor(priority: 0));
    }
  }
  
  Future<Message> handleIncomingMessage(Message message) async {
    return await _pipeline.process(message);
  }
}
```

---

## 5. 디자인 패턴 활용

### 5.1 전략 패턴 (Strategy Pattern)

```dart
// AI 서비스 전략
abstract class AIStrategy {
  Future<List<Recommendation>> recommend(Message message);
}

class GeminiStrategy implements AIStrategy {
  @override
  Future<List<Recommendation>> recommend(Message message) async {
    // Gemini API 사용
  }
}

class OpenAIStrategy implements AIStrategy {
  @override
  Future<List<Recommendation>> recommend(Message message) async {
    // OpenAI API 사용
  }
}

class TensorFlowStrategy implements AIStrategy {
  @override
  Future<List<Recommendation>> recommend(Message message) async {
    // TensorFlow Lite 사용
  }
}

// 전략 선택기
class AIStrategySelector {
  final ConfigService _config;
  
  AIStrategy selectStrategy() {
    final strategyType = _config.get<String>('ai_strategy', 'gemini');
    
    switch (strategyType) {
      case 'gemini':
        return GeminiStrategy();
      case 'openai':
        return OpenAIStrategy();
      case 'tensorflow':
        return TensorFlowStrategy();
      default:
        return GeminiStrategy();
    }
  }
}
```

### 5.2 팩토리 패턴 (Factory Pattern)

```dart
// 플랫폼 어댑터 팩토리
abstract class PlatformAdapterFactory {
  static MessagingPlatformAdapter create(String platformId) {
    // 설정에서 플랫폼 정보 가져오기
    final platformConfig = ConfigService().get<Map<String, dynamic>>(
      'platforms.$platformId',
      {},
    );
    
    final adapterType = platformConfig['adapter'] ?? platformId;
    
    switch (adapterType) {
      case 'sms':
        return SmsAdapter();
      case 'kakao':
        return KakaoAdapter();
      // 동적으로 추가 가능
      default:
        throw ArgumentError('Unknown platform: $platformId');
    }
  }
}
```

### 5.3 옵저버 패턴 (Observer Pattern)

```dart
// 이벤트 시스템
abstract class AppEvent {}

class ConfigChangedEvent extends AppEvent {
  final String key;
  final dynamic newValue;
  
  ConfigChangedEvent(this.key, this.newValue);
}

class EventBus {
  final Map<Type, List<Function>> _listeners = {};
  
  void subscribe<T extends AppEvent>(Function(T) listener) {
    _listeners.putIfAbsent(T, () => []).add(listener);
  }
  
  void emit<T extends AppEvent>(T event) {
    _listeners[T]?.forEach((listener) => listener(event));
  }
}

// 사용: 설정 변경 시 자동 업데이트
class ServerManager {
  ServerManager(this._eventBus) {
    _eventBus.subscribe<ConfigChangedEvent>((event) {
      if (event.key == 'server_type') {
        _switchServer(event.newValue);
      }
    });
  }
}
```

---

## 6. 코드 예시

### 6.1 확장 가능한 설정 관리

```dart
// lib/core/config/app_config.dart
class AppConfig {
  // 싱글톤
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._();
  
  AppConfig._();
  
  // 설정 값들 (모두 외부에서 주입 가능)
  late final String apiBaseUrl;
  late final ServerType serverType;
  late final Map<String, dynamic> featureFlags;
  late final Map<String, PlatformConfig> platformConfigs;
  
  Future<void> initialize() async {
    // 1. 기본값 로드
    await _loadDefaults();
    
    // 2. 환경 변수 오버라이드
    _overrideWithEnv();
    
    // 3. 서버에서 설정 가져오기 (선택)
    await _loadFromServer();
    
    // 4. 로컬 사용자 설정 오버라이드
    _overrideWithUserSettings();
  }
  
  Future<void> _loadDefaults() async {
    // 기본 설정 파일 로드
    final configFile = await rootBundle.loadString('config/default.yaml');
    // 파싱 및 설정
  }
  
  void _overrideWithEnv() {
    apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: apiBaseUrl,
    );
  }
  
  Future<void> _loadFromServer() async {
    // 서버에서 최신 설정 가져오기
    // (기능 플래그 등)
  }
}
```

### 6.2 확장 가능한 리포지토리 패턴

```dart
// Repository 인터페이스
abstract class Repository<T, ID> {
  Future<T?> getById(ID id);
  Future<List<T>> getAll();
  Future<void> save(T entity);
  Future<void> delete(ID id);
}

// 구현체는 여러 개 가능
class FirestoreRepository<T, ID> implements Repository<T, ID> {
  // Firebase 구현
}

class ApiRepository<T, ID> implements Repository<T, ID> {
  // REST API 구현
}

class LocalRepository<T, ID> implements Repository<T, ID> {
  // 로컬 DB 구현
}

// Repository Factory
class RepositoryFactory {
  static Repository<T, ID> create<T, ID>({
    required RepositoryType type,
    required String collectionName,
  }) {
    switch (type) {
      case RepositoryType.firestore:
        return FirestoreRepository<T, ID>(collectionName);
      case RepositoryType.api:
        return ApiRepository<T, ID>(collectionName);
      case RepositoryType.local:
        return LocalRepository<T, ID>(collectionName);
    }
  }
}
```

---

## 7. 체크리스트

### 코드 작성 전

- [ ] 하드코딩된 값이 없는가?
- [ ] 설정 파일로 분리할 수 있는가?
- [ ] 추상 인터페이스를 사용하는가?
- [ ] 새로운 구현체 추가가 쉬운가?

### 기능 추가 시

- [ ] 기존 코드를 수정하지 않고 추가할 수 있는가?
- [ ] 플러그인/어댑터 패턴을 사용하는가?
- [ ] 기능 플래그로 제어 가능한가?
- [ ] 설정으로 활성화/비활성화할 수 있는가?

### 서버/API 변경 시

- [ ] 서버 타입을 설정으로 변경할 수 있는가?
- [ ] 새로운 서버 어댑터를 쉽게 추가할 수 있는가?
- [ ] 하이브리드 방식 지원이 가능한가?
- [ ] 서버 변경 시 코드 수정이 최소화되는가?

---

## 🎯 핵심 규칙

1. **하드코딩 금지**: 모든 값은 설정에서 관리
2. **추상화 우선**: 구체적 구현보다 인터페이스
3. **설정 기반**: 환경 변수, 설정 파일 활용
4. **플러그인 아키텍처**: 기능 추가 시 코드 수정 최소화
5. **팩토리 패턴**: 동적 생성 및 선택
6. **기능 플래그**: 런타임 기능 제어

---

## 📚 참고 자료

- [Clean Architecture](ARCHITECTURE_DESIGN.md)
- [플랫폼 통합 전략](PLATFORM_INTEGRATION.md)
- [개발 로드맵](DEVELOPMENT_ROADMAP.md)

---

**확장 가능하고 유연한 코드로 미래의 변화에 대비하세요!** 🚀

