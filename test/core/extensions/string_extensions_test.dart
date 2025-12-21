import 'package:flutter_test/flutter_test.dart';
import 'package:new_sendbox/core/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    group('capitalizeFirst', () {
      test('should capitalize first letter', () {
        expect('hello'.capitalizeFirst(), 'Hello');
        expect('HELLO'.capitalizeFirst(), 'HELLO'); // 첫 글자만 변경
      });

      test('should handle empty strings', () {
        expect(''.capitalizeFirst(), '');
      });
    });

    group('isNumeric', () {
      test('should return true for numeric strings', () {
        expect('123'.isNumeric, true);
        expect('0'.isNumeric, true);
        expect('999'.isNumeric, true);
      });

      test('should return false for non-numeric strings', () {
        expect('abc'.isNumeric, false);
        expect('12.34'.isNumeric, false);
        expect('12a'.isNumeric, false);
      });
    });

    group('isValidEmail', () {
      test('should return true for valid emails', () {
        expect('test@example.com'.isValidEmail, true);
        expect('user.name@domain.co.uk'.isValidEmail, true);
      });

      test('should return false for invalid emails', () {
        expect('invalid-email'.isValidEmail, false);
        expect('test@'.isValidEmail, false);
        expect(''.isValidEmail, false);
      });
    });
  });
}

