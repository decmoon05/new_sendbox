import 'package:flutter_test/flutter_test.dart';
import 'package:sendbox/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('isValidEmail', () {
      test('should return true for valid email addresses', () {
        expect(Validators.isValidEmail('test@example.com'), true);
        expect(Validators.isValidEmail('user.name@domain.co.uk'), true);
        expect(Validators.isValidEmail('test123@test-domain.com'), true);
      });

      test('should return false for invalid email addresses', () {
        expect(Validators.isValidEmail('invalid-email'), false);
        expect(Validators.isValidEmail('test@'), false);
        expect(Validators.isValidEmail('@example.com'), false);
        expect(Validators.isValidEmail('test @example.com'), false);
        expect(Validators.isValidEmail(''), false);
      });
    });

    group('validatePassword', () {
      test('should return valid result for valid passwords', () {
        final result1 = Validators.validatePassword('Password123');
        expect(result1.isValid, true);
        expect(result1.error, isNull);

        final result2 = Validators.validatePassword('SecurePass!1');
        expect(result2.isValid, true);
        expect(result2.error, isNull);
      });

      test('should return invalid result for short passwords', () {
        final result = Validators.validatePassword('short');
        expect(result.isValid, false);
        expect(result.error, contains('8자 이상'));
      });

      test('should return invalid result for empty passwords', () {
        final result = Validators.validatePassword('');
        expect(result.isValid, false);
        expect(result.error, contains('8자 이상'));
      });

      test('should return invalid result for passwords without uppercase', () {
        final result = Validators.validatePassword('password123');
        expect(result.isValid, false);
        expect(result.error, contains('대문자'));
      });

      test('should return invalid result for passwords without lowercase', () {
        final result = Validators.validatePassword('PASSWORD123');
        expect(result.isValid, false);
        expect(result.error, contains('소문자'));
      });

      test('should return invalid result for passwords without digit', () {
        final result = Validators.validatePassword('Password');
        expect(result.isValid, false);
        expect(result.error, contains('숫자'));
      });
    });
  });
}

