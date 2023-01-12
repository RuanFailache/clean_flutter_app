import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

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

    if (clientResponse.statusCode == 204) {
      return null;
    }

    if (clientResponse.statusCode >= 200 && clientResponse.statusCode < 300) {
      return clientResponse.body.isNotEmpty
          ? jsonDecode(clientResponse.body)
          : null;
    }

    if (clientResponse.statusCode == 400) {
      throw HttpError.badRequest;
    }

    if (clientResponse.statusCode == 401) {
      throw HttpError.unauthorized;
    }

    throw HttpError.serverError;
  }
}
