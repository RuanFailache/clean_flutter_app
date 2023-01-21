import '../protocols/protocols.dart';

class EmailValidation extends FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String value) {
    final regex = RegExp(r'^/w+@/w+./w+$');
    final isValid = value.isEmpty ? null : regex.hasMatch(value);
    return isValid == true ? null : 'Email inválido';
  }
}
