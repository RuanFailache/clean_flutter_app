import 'package:for_dev/validation/protocols/field_validation.dart';
import 'package:for_dev/validation/validators/email_validation.dart';
import 'package:for_dev/validation/validators/required_field_validation.dart';

class ValidationBuilder {
  ValidationBuilder._();

  late String _fieldName;

  final List<FieldValidation> _validations = [];

  static ValidationBuilder field(String fieldName) {
    final instance = ValidationBuilder._();
    instance._fieldName = fieldName;
    return instance;
  }

  ValidationBuilder required() {
    final validation = RequiredFieldValidation(_fieldName);
    _validations.add(validation);
    return this;
  }

  ValidationBuilder email() {
    final validation = EmailValidation(_fieldName);
    _validations.add(validation);
    return this;
  }

  List<FieldValidation> build() => _validations;
}
