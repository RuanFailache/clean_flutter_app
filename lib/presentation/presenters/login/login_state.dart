class LoginState {
  String? emailError;

  String? passwordError;

  bool get isFormValid => emailError == null && passwordError == null;
}
