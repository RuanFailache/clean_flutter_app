abstract class LoginPresenter {
  Stream<String> get emailErrorStream;

  Stream<String> get passwordErrorStream;

  Stream<String> get loginErrorController;

  Stream<bool> get isFormValidController;

  Stream<bool> get isLoadingController;

  void validateEmail(String email);

  void validatePassword(String password);

  void auth();
}
