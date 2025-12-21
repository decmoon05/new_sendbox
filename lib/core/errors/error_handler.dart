import 'exceptions.dart';
import 'failures.dart';

/// 에러 핸들러 - 예외를 실패로 변환
class ErrorHandler {
  /// 예외를 Failure로 변환
  static Failure handleException(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is AuthenticationException) {
      return AuthenticationFailure(exception.message);
    } else if (exception is PermissionException) {
      return PermissionFailure(exception.message);
    } else if (exception is ValidationException) {
      return ValidationFailure(
        exception.message,
        errors: exception.errors,
      );
    } else if (exception is EncryptionException) {
      return EncryptionFailure(exception.message);
    } else if (exception is PlatformIntegrationException) {
      return PlatformIntegrationFailure(
        exception.message,
        platform: exception.platform,
      );
    } else {
      return ServerFailure('알 수 없는 오류가 발생했습니다: ${exception.toString()}');
    }
  }
  
  /// 에러 메시지 추출
  static String getErrorMessage(Failure failure) {
    return failure.message;
  }
  
  /// 사용자 친화적인 에러 메시지 변환
  static String getUserFriendlyMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return '인터넷 연결을 확인하고 다시 시도해주세요.';
    } else if (failure is AuthenticationFailure) {
      return '로그인이 필요합니다.';
    } else if (failure is PermissionFailure) {
      return '이 기능을 사용하려면 권한이 필요합니다.';
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else {
      return failure.message;
    }
  }
}

