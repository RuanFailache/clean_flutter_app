import 'dart:async';

import 'package:faker/faker.dart';
import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'stream_login_presenter_test.mocks.dart';

class LoginState {
  String? emailError;
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  final _controller = StreamController<LoginState>();

  final LoginState _state = LoginState();

  Stream<String?> get emailErrorStream {
    return _controller.stream.map((state) => state.emailError);
  }

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}

@GenerateMocks([Validation])
void main() {
  late MockValidation validation;
  late StreamLoginPresenter sut;
  late String email;

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
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
    'Should emit email error if validation fails',
    () {
      mockValidation(field: 'email', value: 'error');
      expectLater(sut.emailErrorStream, emits('error'));
      sut.validateEmail(email);
    },
  );
}
