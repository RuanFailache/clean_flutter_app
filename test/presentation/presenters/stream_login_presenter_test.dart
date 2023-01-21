import 'package:faker/faker.dart';
import 'package:for_dev/domain/entities/account_entity.dart';
import 'package:for_dev/domain/helpers/domain_error.dart';
import 'package:for_dev/domain/usecases/authentication.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

import 'stream_login_presenter_test.mocks.dart';

@GenerateMocks([Validation, Authentication])
void main() {
  late MockValidation validation;
  late MockAuthentication authentication;
  late StreamLoginPresenter sut;
  late String email, password;

  PostExpectation mockValidationCall([String? field]) => when(
        validation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  PostExpectation mockAuthenticationCall() {
    return when(authentication.auth(any));
  }

  void mockValidation({
    String? field,
    String? value,
  }) {
    mockValidationCall(field).thenReturn(value);
  }

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer(
      (_) async => AccountEntity(
        faker.guid.guid(),
      ),
    );
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    email = faker.internet.email();
    password = faker.internet.password();

    validation = MockValidation();
    authentication = MockAuthentication();

    sut = StreamLoginPresenter(
      validation: validation,
      authentication: authentication,
    );

    mockValidation();
    mockAuthentication();
  });

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
      mockValidation(field: 'email', value: 'error');

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
      mockValidation(field: 'password', value: 'error');

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
      mockValidation(field: 'password', value: 'error');

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
    'Should emit isFormValid as false when email is valid and password is invalid',
    () {
      mockValidation(field: 'password', value: 'error');

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validateEmail(email);
      sut.validatePassword(password);
    },
  );

  test(
    'Should emit isFormValid as false when email is invalid and password is valid',
    () {
      mockValidation(field: 'email', value: 'error');

      sut.isFormValidStream.listen(
        expectAsync1(
          (isValid) => expect(isValid, false),
        ),
      );

      sut.validateEmail(email);
      sut.validatePassword(password);
    },
  );

  test(
    'Should emit isFormValid as true when both email and password are valid',
    () async {
      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
    },
  );

  test(
    'Should call Authentication with correct values',
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(
        authentication.auth(
          AuthenticationParams(
            email: email,
            secret: password,
          ),
        ),
      ).called(1);
    },
  );

  test(
    'Should emit correct events on Authentication success',
    () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.auth();
    },
  );

  test(
    'Should emit correct events on InvalidCredentialsError',
    () async {
      mockAuthenticationError(DomainError.invalidCredentials);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emits(false));

      sut.authErrorStream.listen(
        expectAsync1(
          (error) => expect(
            error,
            DomainError.invalidCredentials.description,
          ),
        ),
      );

      await sut.auth();
    },
  );

  test(
    'Should emit correct events on UnexpectedError',
    () async {
      mockAuthenticationError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emits(false));

      sut.authErrorStream.listen(
        expectAsync1(
          (error) => expect(
            error,
            DomainError.unexpected.description,
          ),
        ),
      );

      await sut.auth();
    },
  );
}
