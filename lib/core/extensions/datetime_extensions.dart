import '../utils/date_utils.dart';
import '../utils/formatters.dart';

/// DateTime 확장 메서드
extension DateTimeExtensions on DateTime {
  /// 오늘인지 확인
  bool get isToday => DateUtils.isToday(this);

  /// 어제인지 확인
  bool get isYesterday => DateUtils.isYesterday(this);

  /// 이번 주인지 확인
  bool get isThisWeek => DateUtils.isThisWeek(this);

  /// 이번 달인지 확인
  bool get isThisMonth => DateUtils.isThisMonth(this);

  /// 상대 시간 포맷 (방금 전, 5분 전 등)
  String get relativeTime => Formatters.formatRelativeTime(this);

  /// 날짜 시간 포맷 (yyyy-MM-dd HH:mm)
  String get formattedDateTime => Formatters.formatDateTime(this);

  /// 날짜 포맷 (yyyy-MM-dd)
  String get formattedDate => Formatters.formatDate(this);

  /// 시간 포맷 (HH:mm)
  String get formattedTime => Formatters.formatTime(this);

  /// 해당 월의 첫 번째 날
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// 해당 월의 마지막 날
  DateTime get endOfMonth => DateTime(year, month + 1, 0);

  /// 해당 주의 시작일 (월요일)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday));
  }

  /// 해당 주의 마지막 날 (일요일)
  DateTime get endOfWeek {
    final daysUntilSunday = 7 - weekday;
    return add(Duration(days: daysUntilSunday));
  }

  /// 날짜만 비교 (시간 제외)
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

