import 'package:flutter_test/flutter_test.dart';
import 'package:new_sendbox/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    group('formatDate', () {
      test('should format date correctly', () {
        final date = DateTime(2024, 1, 15);
        final formatted = formatDate(date);
        expect(formatted, isNotEmpty);
        expect(formatted.contains('2024'), true);
      });
    });

    group('formatTime', () {
      test('should format time correctly', () {
        final date = DateTime(2024, 1, 15, 14, 30);
        final formatted = formatTime(date);
        expect(formatted, isNotEmpty);
      });
    });

    group('formatDuration', () {
      test('should format duration correctly', () {
        final duration = const Duration(hours: 2, minutes: 30);
        final formatted = formatDuration(duration);
        expect(formatted, isNotEmpty);
      });
    });
  });
}

