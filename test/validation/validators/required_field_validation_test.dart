import 'package:flutter_test/flutter_test.dart';

abstract class FieldValidation {
  String get field;

  String? validate(String value);
}

class RequiredFieldValidation extends FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    return null;
  }
}

void main() {
  test(
    'Should return null if value is not empty',
    () async {
      final sut = RequiredFieldValidation('any_field');

      final error = sut.validate('any_value');

      expect(error, null);
    },
  );
}