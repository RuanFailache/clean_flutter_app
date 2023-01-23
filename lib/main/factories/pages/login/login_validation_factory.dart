import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/validators/validators.dart';

Validation makeLoginValidation() {
  return ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
}
