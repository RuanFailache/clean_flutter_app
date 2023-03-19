import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/ui/pages/login/login.dart';
import 'package:get/get.dart';

class GetLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  String _email = '';
  String _password = '';

  final RxnString _formError = RxnString();
  final RxnString _emailError = RxnString();
  final RxnString _passwordError = RxnString();

  final RxBool _isLoading = false.obs;
  final RxBool _isFormValid = false.obs;

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email.isNotEmpty &&
        _password.isNotEmpty;
  }

  @override
  Stream<String?> get emailErrorStream => _emailError.stream;

  @override
  Stream<String?> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<String?> get formErrorStream => _formError.stream;

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<bool> get isFormValidStream => _isFormValid.stream;

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(
      field: 'email',
      value: email,
    );
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate(
      field: 'password',
      value: password,
    );
    _validateForm();
  }

  @override
  Future<void> auth() async {
    _isLoading.value = true;
    try {
      final account = await authentication.auth(
        AuthenticationParams(
          email: _email,
          secret: _password,
        ),
      );
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      _formError.value = error.description;
    }
    _isLoading.value = false;
  }

  @override
  void dispose() {
    _formError.close();
    _emailError.close();
    _passwordError.close();
    _isLoading.close();
    _isFormValid.close();
  }
}
