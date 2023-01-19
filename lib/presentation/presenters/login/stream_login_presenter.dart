import 'dart:async';

import '../../dependencies/dependencies.dart';
import 'login_state.dart';

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  final _controller = StreamController<LoginState>();

  final LoginState _state = LoginState();

  Stream<String?> get emailErrorStream {
    return _controller.stream.map((state) => state.emailError).distinct();
  }

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controller.add(_state);
  }
}
