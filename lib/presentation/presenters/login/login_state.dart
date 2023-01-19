class LoginState {
  String email = '';

  String password = '';

  String? emailError;

  String? passwordError;

  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      email.isNotEmpty &&
      passwordError == null &&
      password.isNotEmpty;
}
