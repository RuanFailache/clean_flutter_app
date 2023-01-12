import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:for_dev/data/http/http.dart';
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

        mockPostRequest().thenAnswer((_) async => Response('{}', 200));

        const mockBody = {'any_key': 'anY_value'};
        final mockEncodedBody = jsonEncode(mockBody);

        await sut.request(
          url: url,
          method: 'post',
          body: mockBody,
        );

        verify(
          client.post(
            uri,
            body: mockEncodedBody,
            headers: sut.headers,
          ),
        );
      },
    );

    test(
      'Should call post without body',
      () async {
        final uri = HttpAdapter.convertUrlToHttpUri(url);

        mockPostRequest().thenAnswer((_) async => Response('{}', 200));

        await sut.request(url: url, method: 'post');

        verify(
          client.post(
            uri,
            headers: sut.headers,
          ),
        );
      },
    );

    test(
      'Should return data if post returns 200',
      () async {
        const mockResponse = {'any_key': 'anY_value'};
        final mockEncodedResponse = jsonEncode(mockResponse);

        mockPostRequest().thenAnswer(
          (_) async => Response(mockEncodedResponse, 200),
        );

        final response = await sut.request(url: url, method: 'post');

        expect(response, mockResponse);
      },
    );

    test(
      'Should return null if post returns 200 with no data',
      () async {
        mockPostRequest().thenAnswer(
          (_) async => Response('', 200),
        );

        final response = await sut.request(url: url, method: 'post');

        expect(response, null);
      },
    );
  });
}

class HttpAdapter implements HttpClient {
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

  Map<String, String> get headers => {
        'content-type': 'application/json',
        'accept': 'application/json',
      };

  @override
  Future<Map?> request({
    Map? body,
    required String method,
    required String url,
  }) async {
    final encodedBody = body != null ? jsonEncode(body) : null;

    final clientResponse = await client.post(
      convertUrlToHttpUri(url),
      body: encodedBody,
      headers: headers,
    );

    return clientResponse.body.isNotEmpty
        ? jsonDecode(clientResponse.body)
        : null;
  }
}
