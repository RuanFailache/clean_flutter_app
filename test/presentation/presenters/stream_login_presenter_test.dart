import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

import 'stream_login_presenter_test.mocks.dart';

@GenerateMocks([Validation])
void main() {
  late MockValidation validation;
  late StreamLoginPresenter sut;
  late String email, password;

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
  });

  PostExpectation mockValidationCall([String? field]) => when(
        validation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  void mockValidation({
    String? field,
    String? value,
  }) {
    mockValidationCall(field).thenReturn(value);
  }

  test(
    'Should call Validation with correct email',
    () async {
      mockValidation(field: 'email');

      sut.validateEmail(email);

      verify(
        validation.validate(
          field: 'email',
          value: email,
        ),
      ).called(1);
    },
  );

  test(
    'Should call Validation with correct password',
    () async {
      mockValidation(field: 'password');

      sut.validatePassword(password);

      verify(
        validation.validate(
          field: 'password',
          value: password,
        ),
      ).called(1);
    },
  );

  test(
    'Should emit email error if validation fails',
    () {
      mockValidation(value: 'error');

      sut.emailErrorStream.listen(
        expectAsync1(
          (error) => expect(error, 'error'),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    },
  );

  test(
    'Should emit password error if validation fails',
    () {
      mockValidation(value: 'error');

      sut.passwordErrorStream.listen(
        expectAsync1(
          (error) => expect(error, 'error'),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    },
  );

  test(
    'Should emit password error if validation fails',
    () {
      mockValidation(value: 'error');

      sut.passwordErrorStream.listen(
        expectAsync1(
          (error) => expect(error, 'error'),
        ),
      );

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    },
  );
}
