import 'package:flutter_test/flutter_test.dart';
import 'package:new_sendbox/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('isValidEmail', () {
      test('should return true for valid email addresses', () {
        expect(isValidEmail('test@example.com'), true);
        expect(isValidEmail('user.name@domain.co.uk'), true);
        expect(isValidEmail('test123@test-domain.com'), true);
      });

      test('should return false for invalid email addresses', () {
        expect(isValidEmail('invalid-email'), false);
        expect(isValidEmail('test@'), false);
        expect(isValidEmail('@example.com'), false);
        expect(isValidEmail('test @example.com'), false);
        expect(isValidEmail(''), false);
      });
    });

    group('isValidPassword', () {
      test('should return true for valid passwords', () {
        expect(isValidPassword('password123'), true);
        expect(isValidPassword('SecurePass!'), true);
        expect(isValidPassword('a'.repeat(8)), true); // 최소 8자
      });

      test('should return false for invalid passwords', () {
        expect(isValidPassword('short'), false); // 8자 미만
        expect(isValidPassword(''), false);
        expect(isValidPassword('1234567'), false); // 7자
      });
    });

    group('isNotNullOrEmpty', () {
      test('should return true for non-null and non-empty strings', () {
        expect(isNotNullOrEmpty('test'), true);
        expect(isNotNullOrEmpty('  test  '), true);
        expect(isNotNullOrEmpty('a'), true);
      });

      test('should return false for null, empty, or whitespace-only strings', () {
        expect(isNotNullOrEmpty(null), false);
        expect(isNotNullOrEmpty(''), false);
        expect(isNotNullOrEmpty('   '), false); // 공백만
        expect(isNotNullOrEmpty('\t\n'), false); // 탭/개행만
      });
    });
  });
}

