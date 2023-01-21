import 'package:flutter_test/flutter_test.dart';
import 'package:for_dev/validation/protocols/protocols.dart';

class EmailValidation extends FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String value) {
    return null;
  }
}

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('');
  });

  test(
    'Should return null if email is empty',
    () async {
      final error = sut.validate('');

      expect(error, null);
    },
  );
}
