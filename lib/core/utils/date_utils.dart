/// 날짜 유틸리티
class DateUtils {
  DateUtils._();

  /// 오늘 날짜인지 확인
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 어제 날짜인지 확인
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// 이번 주인지 확인
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// 이번 달인지 확인
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// 날짜 범위 생성 (시작일부터 종료일까지)
  static List<DateTime> dateRange(DateTime start, DateTime end) {
    final dates = <DateTime>[];
    var current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (!current.isAfter(endDate)) {
      dates.add(current);
      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  /// 시작 시간과 종료 시간 사이의 시간인지 확인
  static bool isBetween(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start) && date.isBefore(end);
  }

  /// 시간 차이를 Duration으로 반환
  static Duration difference(DateTime start, DateTime end) {
    return end.difference(start);
  }

  /// UTC 시간을 로컬 시간으로 변환
  static DateTime toLocal(DateTime utc) {
    return utc.toLocal();
  }

  /// 로컬 시간을 UTC 시간으로 변환
  static DateTime toUtc(DateTime local) {
    return local.toUtc();
  }
}

