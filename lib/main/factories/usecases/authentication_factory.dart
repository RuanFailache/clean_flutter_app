import 'package:for_dev/domain/usecases/authentication.dart';
import 'package:for_dev/data/usecases/remote_authentication.dart';

import '../factories.dart';

Authentication makeAuthentication() {
  return RemoteAuthentication(
    url: makeApiUrl('login'),
    httpClient: makeHttpClient(),
  );
}
