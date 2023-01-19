import 'dart:async';

import '../../dependencies/dependencies.dart';
import 'login_state.dart';

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  final _controller = StreamController<LoginState>.broadcast();

  final LoginState _state = LoginState();

  Stream<String?> get emailErrorStream {
    return _controller.stream.map((state) => state.emailError).distinct();
  }

  Stream<String?> get passwordErrorStream {
    return _controller.stream.map((state) => state.passwordError).distinct();
  }

  Stream<bool> get isFormValidStream {
    return _controller.stream.map((state) => state.isFormValid).distinct();
  }

  void validateEmail(String email) {
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );
    _controller.add(_state);
  }

  void validatePassword(String password) {
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
    );
    _controller.add(_state);
  }
}
