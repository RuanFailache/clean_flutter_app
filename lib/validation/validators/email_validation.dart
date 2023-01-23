import 'package:flutter/cupertino.dart';

import '../protocols/protocols.dart';

class EmailValidation extends FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String value) {
    debugPrint('teste');
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isValid = value.isEmpty ? true : regex.hasMatch(value);
    return isValid ? null : 'Email inválido';
  }
}
