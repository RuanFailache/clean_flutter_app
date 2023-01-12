import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import './http_adapter_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late HttpAdapter sut;
  late MockClient client;
  late String url;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    PostExpectation mockPostRequest() => when(
          client.post(
            any,
            body: anyNamed('body'),
            headers: anyNamed('headers'),
          ),
        );

    test(
      'Should call post with body',
      () async {
        final uri = HttpAdapter.convertUrlToHttpUri(url);

        mockPostRequest().thenAnswer((_) async => Response('{}', 201));

        await sut.request(
          url: url,
          method: 'post',
          body: {'any_key': 'anY_value'},
        );

        verify(
          client.post(
            uri,
            body: '{"any_key":"anY_value"}',
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'Should call post without body',
      () async {
        final uri = HttpAdapter.convertUrlToHttpUri(url);

        mockPostRequest().thenAnswer((_) async => Response('{}', 201));

        await sut.request(url: url, method: 'post');

        verify(
          client.post(
            uri,
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ),
        );
      },
    );
  });
}

class HttpAdapter {
  final Client client;

  HttpAdapter(
    this.client,
  );

  static Uri convertUrlToHttpUri(String url) {
    final urlWithoutHttp = url.replaceFirst('http://', '');
    final urlAuthority = urlWithoutHttp.split('/')[0];
    final urlPaths = '/${urlWithoutHttp.split('/').sublist(1).join('/')}';
    return Uri.http(urlAuthority, urlPaths);
  }

  Future<void> request({
    Map? body,
    required String method,
    required String url,
  }) async {
    const Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final encodedBody = body != null ? jsonEncode(body) : null;

    await client.post(
      convertUrlToHttpUri(url),
      headers: headers,
      body: encodedBody,
    );
  }
}
