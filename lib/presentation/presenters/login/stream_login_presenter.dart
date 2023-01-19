import 'dart:async';

import 'package:for_dev/ui/pages/login/login.dart';

import '../../dependencies/dependencies.dart';
import 'login_state.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  final LoginState _state = LoginState();

  final _controller = StreamController<LoginState>.broadcast();

  void _update() => _controller.add(_state);

  Stream<State> _getStreamByState<State>(State Function(LoginState) state) {
    return _controller.stream.map(state).distinct();
  }

  @override
  Stream<String?> get emailErrorStream {
    return _getStreamByState((state) => state.emailError);
  }

  @override
  Stream<String?> get passwordErrorStream {
    return _getStreamByState((state) => state.passwordError);
  }

  @override
  // TODO: implement loginErrorStream
  Stream<String?> get loginErrorStream => throw UnimplementedError();

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  Stream<bool> get isFormValidStream {
    return _getStreamByState((state) => state.isFormValid);
  }

  @override
  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(
      field: 'email',
      value: email,
    );
    _update();
  }

  @override
  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(
      field: 'password',
      value: password,
    );
    _update();
  }

  @override
  Future<void> auth() {
    // TODO: implement auth
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
