import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/protocols/protocols.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'validation_composite_test.mocks.dart';

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

@GenerateMocks([FieldValidation])
void main() {
  late ValidationComposite sut;

  late MockFieldValidation field1;
  late MockFieldValidation field2;
  late MockFieldValidation field3;

  void mockFieldValidation1({
    String? field,
    String? error,
  }) {
    when(field1.field).thenReturn(field ?? 'any_field');
    when(field1.validate(any)).thenReturn(error);
  }

  void mockFieldValidation2({
    String? field,
    String? error,
  }) {
    when(field2.field).thenReturn(field ?? 'any_field');
    when(field2.validate(any)).thenReturn(error);
  }

  void mockFieldValidation3({
    String? field,
    String? error,
  }) {
    when(field3.field).thenReturn(field ?? 'any_field');
    when(field3.validate(any)).thenReturn(error);
  }

  setUp(() {
    field1 = MockFieldValidation();
    mockFieldValidation1();

    field2 = MockFieldValidation();
    when(field2.field).thenReturn('any_field');
    mockFieldValidation2();

    field3 = MockFieldValidation();
    when(field3.field).thenReturn('any_field');
    mockFieldValidation3();

    sut = ValidationComposite([field1, field2, field3]);
  });

  test(
    'Should return null if all validation return null or empty',
    () {
      mockFieldValidation1(error: '');

      final error = sut.validate(
        field: 'any_field',
        value: 'any_value',
      );

      expect(error, null);
    },
  );

  test(
    'Should return error if at least one field has an error',
    () {
      mockFieldValidation1(error: '');
      mockFieldValidation2(error: 'error');

      final error = sut.validate(
        field: 'any_field',
        value: 'any_value',
      );

      expect(error, 'error');
    },
  );

  test(
    'Should return the first error',
    () {
      mockFieldValidation1(error: 'error 1');
      mockFieldValidation2(error: 'error 2');

      final error = sut.validate(
        field: 'any_field',
        value: 'any_value',
      );

      expect(error, 'error 1');
    },
  );

  test(
    'Should return the error of the correct field',
    () {
      mockFieldValidation1(field: 'field 1', error: 'error 1');
      mockFieldValidation2(field: 'field 2', error: 'error 2');

      final error = sut.validate(
        field: 'field 2',
        value: 'any_value',
      );

      expect(error, 'error 2');
    },
  );
}
