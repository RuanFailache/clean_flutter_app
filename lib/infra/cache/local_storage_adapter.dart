import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/datasources/datasources.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  const LocalStorageAdapter({required this.secureStorage});

  @override
  Future<void> saveSecure({
    required String key,
    required String value,
  }) async {
    await secureStorage.write(key: key, value: value);
  }
}
