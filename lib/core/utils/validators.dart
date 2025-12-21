import '../constants/app_constants.dart';

/// 입력 유효성 검사 유틸리티
class Validators {
  Validators._();

  /// 이메일 유효성 검사
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// 전화번호 유효성 검사 (한국 기준)
  static bool isValidPhoneNumber(String phoneNumber) {
    // 공백, 하이픈 제거
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-]'), '');
    
    // 한국 전화번호 형식: 010-1234-5678, 02-123-4567 등
    final phoneRegex = RegExp(r'^(010|011|016|017|018|019|02|031|032|033|041|042|043|044|051|052|053|054|055|061|062|063|064)\d{3,4}\d{4}$');
    return phoneRegex.hasMatch(cleaned);
  }

  /// 메시지 내용 유효성 검사
  static ValidationResult validateMessage(String content) {
    if (content.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        error: '메시지 내용을 입력해주세요.',
      );
    }

    if (content.length > AppConstants.maxMessageLength) {
      return ValidationResult(
        isValid: false,
        error: '메시지는 ${AppConstants.maxMessageLength}자를 초과할 수 없습니다.',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// 프로필 이름 유효성 검사
  static ValidationResult validateProfileName(String name) {
    if (name.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        error: '이름을 입력해주세요.',
      );
    }

    if (name.length > AppConstants.maxProfileNameLength) {
      return ValidationResult(
        isValid: false,
        error: '이름은 ${AppConstants.maxProfileNameLength}자를 초과할 수 없습니다.',
      );
    }

    return ValidationResult(isValid: true);
  }

  /// 비밀번호 유효성 검사
  static ValidationResult validatePassword(String password) {
    if (password.length < 8) {
      return ValidationResult(
        isValid: false,
        error: '비밀번호는 8자 이상이어야 합니다.',
      );
    }

    if (password.length > 128) {
      return ValidationResult(
        isValid: false,
        error: '비밀번호는 128자를 초과할 수 없습니다.',
      );
    }

    // 최소 하나의 대문자, 소문자, 숫자 포함
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      return ValidationResult(
        isValid: false,
        error: '비밀번호는 대문자, 소문자, 숫자를 포함해야 합니다.',
      );
    }

    return ValidationResult(isValid: true);
  }
}

/// 유효성 검사 결과
class ValidationResult {
  final bool isValid;
  final String? error;

  const ValidationResult({
    required this.isValid,
    this.error,
  });
}

