import 'package:intl/intl.dart';

/// 데이터 포맷터 유틸리티
class Formatters {
  Formatters._();

  /// 날짜 시간 포맷 (yyyy-MM-dd HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  /// 날짜 포맷 (yyyy-MM-dd)
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 시간 포맷 (HH:mm)
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// 상대 시간 포맷 (방금 전, 5분 전, 1시간 전 등)
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks주 전';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months개월 전';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years년 전';
    }
  }

  /// 전화번호 포맷 (010-1234-5678)
  static String formatPhoneNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[\s\-]'), '');
    
    if (cleaned.length == 11) {
      // 휴대폰 번호: 010-1234-5678
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 7)}-${cleaned.substring(7)}';
    } else if (cleaned.length == 10) {
      // 서울 등 지역번호: 02-1234-5678
      if (cleaned.startsWith('02')) {
        return '${cleaned.substring(0, 2)}-${cleaned.substring(2, 6)}-${cleaned.substring(6)}';
      } else {
        // 기타 지역: 031-123-4567
        return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
      }
    }
    
    return phoneNumber; // 포맷할 수 없으면 원본 반환
  }

  /// 파일 크기 포맷 (KB, MB, GB)
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// 숫자 포맷 (쉼표 추가: 1,234,567)
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  /// 통화 포맷 (₩1,234,567)
  static String formatCurrency(int amount) {
    return '₩${formatNumber(amount)}';
  }
}

