// Mocks generated by Mockito 5.3.2 from annotations
// in for_dev/test/data/usecases/authentication/remote_authentication_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:for_dev/data/datasources/http/http_client.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [HttpClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClient extends _i1.Mock implements _i2.HttpClient {
  MockHttpClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<Map<dynamic, dynamic>?> request({
    Map<dynamic, dynamic>? body,
    required String? method,
    required String? url,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #request,
          [],
          {
            #body: body,
            #method: method,
            #url: url,
          },
        ),
        returnValue: _i3.Future<Map<dynamic, dynamic>?>.value(),
      ) as _i3.Future<Map<dynamic, dynamic>?>);
}