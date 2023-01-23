import 'package:for_dev/data/http/http.dart';
import 'package:http/http.dart';

import 'package:for_dev/infra/http/http.dart';

HttpClient makeHttpClient() {
  final client = Client();
  return HttpAdapter(client);
}
