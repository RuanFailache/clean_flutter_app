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
