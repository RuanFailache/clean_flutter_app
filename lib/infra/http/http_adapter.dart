import 'dart:convert';

import 'package:flutter/material.dart';
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
    late Response clientResponse;

    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      if (method == 'post') {
        clientResponse = await client.post(
          convertUrlToHttpUri(url),
          body: encodedBody,
          headers: headers,
        );
      } else {
        throw HttpError.invalidMethodError;
      }
    } catch (err) {
      if (err is HttpError) rethrow;
      throw HttpError.unknown;
    }

    return handleClientResponse(clientResponse);
  }

  @protected
  Map? handleClientResponse(Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.statusCode == 204 || response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    }

    if (response.statusCode == 400) {
      throw HttpError.badRequest;
    }

    if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    }

    if (response.statusCode == 403) {
      throw HttpError.forbidden;
    }

    if (response.statusCode == 404) {
      throw HttpError.notFound;
    }

    throw HttpError.serverError;
  }
}
