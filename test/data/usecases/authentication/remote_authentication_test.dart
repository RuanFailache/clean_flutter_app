import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/datasources/http/http.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

import 'remote_authentication_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteAuthentication sut;
  late MockHttpClient httpClient;
  late String url;
  late AuthenticationParams params;

  PostExpectation mockRequest() => when(
        httpClient.request(
          body: anyNamed('body'),
          method: anyNamed('method'),
          url: anyNamed('url'),
        ),
      );

  void mockRequestError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  void mockRequestSuccess(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
  });

  test(
    'Should throw UnexpectedError if HttpClient returns 400',
    () async {
      mockRequestError(HttpError.badRequest);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 404',
    () async {
      mockRequestError(HttpError.notFound);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 500',
    () async {
      mockRequestError(HttpError.serverError);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw InvalidCredentialsError if HttpClient returns 401',
    () async {
      mockRequestError(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'Should returns an Account if HttpClient returns 200',
    () async {
      final accessToken = faker.guid.guid();

      mockRequestSuccess({
        'accessToken': accessToken,
        'name': faker.person.name(),
      });

      final account = await sut.auth(params);

      expect(account.token, accessToken);
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      mockRequestSuccess({
        'invalid_key': 'invalid_value',
      });

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
