import 'package:flutter_test/flutter_test.dart';
import 'package:sendbox/core/extensions/datetime_extensions.dart';

void main() {
  group('DateTimeExtensions', () {
    final now = DateTime(2024, 1, 15, 12, 0, 0);

    group('isToday', () {
      test('should return true for today', () {
        expect(now.isToday, true);
      });

      test('should return false for yesterday', () {
        final yesterday = now.subtract(const Duration(days: 1));
        expect(yesterday.isToday, false);
      });
    });

    group('isYesterday', () {
      test('should return true for yesterday', () {
        final yesterday = now.subtract(const Duration(days: 1));
        expect(yesterday.isYesterday, true);
      });

      test('should return false for today', () {
        expect(now.isYesterday, false);
      });
    });

    group('isSameDay', () {
      test('should return true for same day', () {
        final sameDay = DateTime(2024, 1, 15, 10, 0, 0);
        expect(now.isSameDay(sameDay), true);
      });

      test('should return false for different days', () {
        final differentDay = DateTime(2024, 1, 16, 12, 0, 0);
        expect(now.isSameDay(differentDay), false);
      });
    });

    group('startOfMonth', () {
      test('should return first day of month', () {
        final date = DateTime(2024, 1, 15);
        final start = date.startOfMonth;
        expect(start.year, 2024);
        expect(start.month, 1);
        expect(start.day, 1);
      });
    });

    group('endOfMonth', () {
      test('should return last day of month', () {
        final date = DateTime(2024, 1, 15);
        final end = date.endOfMonth;
        expect(end.year, 2024);
        expect(end.month, 1);
        expect(end.day, 31); // 1월은 31일까지
      });
    });
  });
}

