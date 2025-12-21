import 'package:equatable/equatable.dart';

/// 실패 타입 추상 클래스 (Either의 Left 타입으로 사용)
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
  
  @override
  String toString() => message;
}

/// 서버 실패
class ServerFailure extends Failure {
  const ServerFailure([super.message = '서버 오류가 발생했습니다.']);
}

/// 네트워크 실패
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요.']);
}

/// 캐시 실패
class CacheFailure extends Failure {
  const CacheFailure([super.message = '데이터를 불러올 수 없습니다.']);
}

/// 인증 실패
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([super.message = '인증에 실패했습니다.']);
}

/// 권한 실패
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = '권한이 필요합니다.']);
}

/// 검증 실패
class ValidationFailure extends Failure {
  final Map<String, String>? errors;
  
  const ValidationFailure(super.message, {this.errors});
  
  @override
  List<Object> get props => [message, errors ?? {}];
}

/// 암호화 실패
class EncryptionFailure extends Failure {
  const EncryptionFailure([super.message = '암호화 처리 중 오류가 발생했습니다.']);
}

/// 플랫폼 통합 실패
class PlatformIntegrationFailure extends Failure {
  final String platform;
  
  const PlatformIntegrationFailure(
    super.message, {
    required this.platform,
  });
  
  @override
  List<Object> get props => [message, platform];
}

