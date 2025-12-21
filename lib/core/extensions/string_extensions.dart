/// String 확장 메서드
extension StringExtensions on String {
  /// 문자열이 비어있거나 공백만 있는지 확인
  bool get isBlank => trim().isEmpty;

  /// 문자열이 비어있지 않은지 확인
  bool get isNotBlank => !isBlank;

  /// 첫 글자를 대문자로 변환
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 모든 단어의 첫 글자를 대문자로 변환
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// 문자열을 정수로 변환 (실패 시 null)
  int? toIntOrNull() {
    return int.tryParse(this);
  }

  /// 문자열을 실수로 변환 (실패 시 null)
  double? toDoubleOrNull() {
    return double.tryParse(this);
  }

  /// 문자열을 bool로 변환
  bool toBool() {
    return toLowerCase() == 'true' || this == '1';
  }

  /// 문자열 자르기 (길이 초과 시 ... 추가)
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// 전화번호 형식으로 변환
  String formatPhoneNumber() {
    final cleaned = replaceAll(RegExp(r'[\s\-]'), '');
    if (cleaned.length == 11) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 7)}-${cleaned.substring(7)}';
    } else if (cleaned.length == 10) {
      if (cleaned.startsWith('02')) {
        return '${cleaned.substring(0, 2)}-${cleaned.substring(2, 6)}-${cleaned.substring(6)}';
      } else {
        return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
      }
    }
    return this;
  }
}

