import 'package:flutter_test/flutter_test.dart';
import 'package:sendbox/core/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    group('capitalize', () {
      test('should capitalize first letter', () {
        expect('hello'.capitalize, 'Hello');
        expect('HELLO'.capitalize, 'HELLO'); // 첫 글자만 변경
      });

      test('should handle empty strings', () {
        expect(''.capitalize, '');
      });
    });

    group('capitalizeWords', () {
      test('should capitalize all words', () {
        expect('hello world'.capitalizeWords, 'Hello World');
        expect('test string'.capitalizeWords, 'Test String');
      });
    });

    group('toIntOrNull', () {
      test('should return int for valid numbers', () {
        expect('123'.toIntOrNull(), 123);
        expect('0'.toIntOrNull(), 0);
      });

      test('should return null for invalid numbers', () {
        expect('abc'.toIntOrNull(), isNull);
        expect('12.34'.toIntOrNull(), isNull);
      });
    });

    group('truncate', () {
      test('should truncate long strings', () {
        expect('hello world'.truncate(5), 'hello...');
        expect('short'.truncate(10), 'short'); // 짧으면 그대로
      });
    });
  });
}

