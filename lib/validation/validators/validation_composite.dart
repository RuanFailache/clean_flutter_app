import 'package:for_dev/presentation/dependencies/dependencies.dart';

import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({
    required String field,
    required String value,
  }) {
    final validations = this.validations.where((v) => v.field == field);

    for (final validation in validations) {
      final error = validation.validate(value);
      if (error?.isEmpty != true) {
        return error;
      }
    }

    return null;
  }
}
