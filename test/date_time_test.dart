import 'package:flutter_test/flutter_test.dart';
import 'package:alfi_gest/helpers/date_time.dart';

void main() {
  group('DateTimeHelper', () {
    test('isAdult should return true if birth date is before 18 years ago', () {
      // Arrange
      DateTime birthDate = DateTime(2000, 1, 1);

      // Act
      bool result = DateHelper.isAdult(birthDate);

      // Assert
      expect(result, true);
    });

    test('isAdult should return false if birth date is after 18 years ago', () {
      // Arrange
      DateTime birthDate = DateTime(2010, 1, 1);

      // Act
      bool result = DateHelper.isAdult(birthDate);

      // Assert
      expect(result, false);
    });

    test('isAdult should return false if birth date is exactly 18 years ago',
        () {
      // Arrange
      DateTime birthDate = DateTime.now().subtract(Duration(days: 18 * 365));

      // Act
      bool result = DateHelper.isAdult(birthDate);

      // Assert
      expect(result, false);
    });
  });
}
