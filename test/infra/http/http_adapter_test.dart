import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:for_dev/data/http/http.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/infra/http/http.dart';

import './http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late HttpAdapter sut;
  late MockClient client;
  late String url;
  late Uri uri;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    uri = HttpAdapter.convertUrlToHttpUri(url);
  });

  group('post', () {
    late Map mockBody;
    late String mockEncodedBody;

    void mockPostRequest(int statusCode, {String? body}) {
      when(
        client.post(
          any,
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => Response(body ?? mockEncodedBody, statusCode),
      );
    }

    setUp(() {
      mockBody = {'any_key': 'anY_value'};
      mockEncodedBody = jsonEncode(mockBody);
      mockPostRequest(200);
    });

    test(
      'Should call post with body',
      () async {
        await sut.request(url: url, method: 'post', body: mockBody);
        verify(client.post(uri, body: mockEncodedBody, headers: sut.headers));
      },
    );

    test(
      'Should call post without body',
      () async {
        await sut.request(url: url, method: 'post');
        verify(client.post(uri, headers: sut.headers));
      },
    );

    test(
      'Should return data if post returns 200',
      () async {
        final response = await sut.request(url: url, method: 'post');
        expect(response, mockBody);
      },
    );

    test(
      'Should return null if post returns 200 with no data',
      () async {
        mockPostRequest(200, body: '');
        final response = await sut.request(url: url, method: 'post');
        expect(response, null);
      },
    );

    test(
      'Should return null if post returns 204',
      () async {
        mockPostRequest(204, body: '');
        final response = await sut.request(url: url, method: 'post');
        expect(response, null);
      },
    );

    test(
      'Should return null if post returns 204',
      () async {
        mockPostRequest(204);
        final response = await sut.request(url: url, method: 'post');
        expect(response, null);
      },
    );

    test(
      'Should throw a BadRequest if post returns 400',
      () async {
        mockPostRequest(400);
        final future = sut.request(url: url, method: 'post');
        expect(future, throwsA(HttpError.badRequest));
      },
    );
  });
}
