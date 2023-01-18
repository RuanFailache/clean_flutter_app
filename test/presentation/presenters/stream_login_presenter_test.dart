import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Validation {
  void validate({
    required String field,
    required String value,
  });
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

class MockValidation extends Mock implements Validation {}

void main() {
  late Validation validation;
  late StreamLoginPresenter sut;
  late String email;

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test(
    'Should call Validation with correct email',
    () async {
      sut.validateEmail(email);

      verify(
        validation.validate(
          field: 'email',
          value: email,
        ),
      ).called(1);
    },
  );
}
