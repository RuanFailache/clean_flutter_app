abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;

  Stream<String?> get passwordErrorStream;

  Stream<String?> get loginErrorStream;

  Stream<bool> get isFormValidStream;

  Stream<bool> get isLoadingStream;

  void validateEmail(String email);

  void validatePassword(String password);

  Future<void> auth();

  void dispose();
}
