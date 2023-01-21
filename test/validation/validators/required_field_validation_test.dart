import 'package:flutter_test/flutter_test.dart';

import 'package:for_dev/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test(
    'Should return null if value is not empty',
    () async {
      final error = sut.validate('any_value');

      expect(error, null);
    },
  );

  test(
    'Should return error if value is empty',
    () async {
      final error = sut.validate('');

      expect(error, 'Campo obrigatório');
    },
  );
}
