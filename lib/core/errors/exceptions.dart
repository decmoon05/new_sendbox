/// 앱 커스텀 예외 클래스

/// 서버 예외
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ServerException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ServerException: $message';
}

/// 네트워크 예외
class NetworkException implements Exception {
  final String message;
  final dynamic originalError;

  NetworkException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// 캐시 예외
class CacheException implements Exception {
  final String message;
  final dynamic originalError;

  CacheException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// 인증 예외
class AuthenticationException implements Exception {
  final String message;
  final dynamic originalError;

  AuthenticationException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// 권한 예외
class PermissionException implements Exception {
  final String message;
  final String? permission;

  PermissionException({
    required this.message,
    this.permission,
  });

  @override
  String toString() => 'PermissionException: $message';
}

/// 검증 예외
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// 암호화 예외
class EncryptionException implements Exception {
  final String message;
  final dynamic originalError;

  EncryptionException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'EncryptionException: $message';
}

/// 플랫폼 통합 예외
class PlatformIntegrationException implements Exception {
  final String message;
  final String platform;
  final dynamic originalError;

  PlatformIntegrationException({
    required this.message,
    required this.platform,
    this.originalError,
  });

  @override
  String toString() => 'PlatformIntegrationException ($platform): $message';
}

