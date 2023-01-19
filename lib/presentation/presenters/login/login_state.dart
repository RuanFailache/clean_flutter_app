class LoginState {
  String email = '';

  String password = '';

  String? emailError;

  String? passwordError;

  bool get isFormValid =>
      emailError == null &&
      email.isNotEmpty &&
      passwordError == null &&
      password.isNotEmpty;
}
