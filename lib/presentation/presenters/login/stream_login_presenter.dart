import 'dart:async';

import 'package:for_dev/domain/helpers/domain_error.dart';
import 'package:for_dev/domain/usecases/authentication.dart';
import 'package:for_dev/ui/pages/login/login.dart';

import '../../dependencies/dependencies.dart';
import 'login_state.dart';

class StreamLoginPresenter extends StreamPresenter<LoginState>
    implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  }) : super(LoginState.initialState);

  @override
  Stream<String?> get emailErrorStream {
    return getStream((state) => state.emailError);
  }

  @override
  Stream<String?> get passwordErrorStream {
    return getStream((state) => state.passwordError);
  }

  @override
  Stream<String?> get authErrorStream {
    return getStream((state) => state.authError);
  }

  @override
  Stream<bool> get isLoadingStream {
    return getStream((state) => state.isLoading);
  }

  @override
  Stream<bool> get isFormValidStream {
    return getStream((state) => state.isFormValid);
  }

  @override
  void validateEmail(String email) {
    update(() {
      state.email = email;
      state.emailError = validation.validate(
        field: 'email',
        value: email,
      );
    });
  }

  @override
  void validatePassword(String password) {
    update(() {
      state.password = password;
      state.passwordError = validation.validate(
        field: 'password',
        value: password,
      );
    });
  }

  @override
  Future<void> auth() async {
    update(() => state.isLoading = true);
    try {
      await authentication.auth(
        AuthenticationParams(
          email: state.email,
          secret: state.password,
        ),
      );
    } on DomainError catch (error) {
      update(() => state.authError = error.description);
    }

    update(() => state.isLoading = false);
  }

  @override
  void dispose() => controller.close();
}
