import 'package:flutter/services.dart';
import 'sms_service_platform_interface.dart';

/// SMS 서비스
/// Android의 SMS 기능을 사용하기 위한 플랫폼 채널 서비스
class SmsService {
  static const MethodChannel _channel = MethodChannel('com.sendbox.app/sms');

  /// SMS 전송
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('sendSms', {
        'phoneNumber': phoneNumber,
        'message': message,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('SMS 전송 실패: ${e.message}');
    }
  }

  /// SMS 수신 대기 시작
  Future<void> startListening() async {
    try {
      await _channel.invokeMethod('startListening');
    } on PlatformException catch (e) {
      throw Exception('SMS 수신 대기 시작 실패: ${e.message}');
    }
  }

  /// SMS 수신 대기 중지
  Future<void> stopListening() async {
    try {
      await _channel.invokeMethod('stopListening');
    } on PlatformException catch (e) {
      throw Exception('SMS 수신 대기 중지 실패: ${e.message}');
    }
  }

  /// 기존 SMS 메시지 가져오기
  Future<List<Map<String, dynamic>>> getSmsMessages({
    String? phoneNumber,
    int? limit,
  }) async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('getSmsMessages', {
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (limit != null) 'limit': limit,
      });
      return result?.cast<Map<String, dynamic>>() ?? [];
    } on PlatformException catch (e) {
      throw Exception('SMS 메시지 가져오기 실패: ${e.message}');
    }
  }
}

/// SMS 서비스 플랫폼 인터페이스 (확장성 고려)
abstract class SmsServicePlatformInterface {
  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  });
  
  Future<void> startListening();
  Future<void> stopListening();
  Future<List<Map<String, dynamic>>> getSmsMessages({
    String? phoneNumber,
    int? limit,
  });
}

