import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/http/http.dart';
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
      when(
        httpClient.request(
          body: anyNamed('body'),
          method: anyNamed('method'),
          url: anyNamed('url'),
        ),
      ).thenThrow(HttpError.badRequest);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 404',
    () async {
      when(
        httpClient.request(
          body: anyNamed('body'),
          method: anyNamed('method'),
          url: anyNamed('url'),
        ),
      ).thenThrow(HttpError.notFound);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw UnexpectedError if HttpClient returns 500',
    () async {
      when(
        httpClient.request(
          body: anyNamed('body'),
          method: anyNamed('method'),
          url: anyNamed('url'),
        ),
      ).thenThrow(HttpError.serverError);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    },
  );

  test(
    'Should throw InvalidCredentialsError if HttpClient returns 401',
    () async {
      when(
        httpClient.request(
          body: anyNamed('body'),
          method: anyNamed('method'),
          url: anyNamed('url'),
        ),
      ).thenThrow(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'Should returns an Account if HttpClient returns 200',
    () async {
      final accessToken = faker.guid.guid();

      when(
        httpClient.request(
          body: anyNamed('body'),
          method: anyNamed('method'),
          url: anyNamed('url'),
        ),
      ).thenAnswer(
        (_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        },
      );

      final account = await sut.auth(params);

      expect(account.token, accessToken);
    },
  );
}
