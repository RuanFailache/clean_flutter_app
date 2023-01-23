class LoginState {
  static get initialState => LoginState();

  String email = '';

  String password = '';

  String? emailError;

  String? passwordError;

  String? authError;

  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      email.isNotEmpty &&
      passwordError == null &&
      password.isNotEmpty;
}
