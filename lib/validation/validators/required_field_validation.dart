import '../protocols/protocols.dart';

class RequiredFieldValidation extends FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String value) {
    return value.isEmpty ? 'Campo obrigatório' : null;
  }
}
