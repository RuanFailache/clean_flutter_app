abstract class HttpClient {
  Future<Map?> request({
    Map? body,
    required String method,
    required String url,
  });
}
