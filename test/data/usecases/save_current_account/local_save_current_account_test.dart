import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

import 'local_save_current_account_test.mocks.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  const LocalSaveCurrentAccount({
    required this.saveSecureCacheStorage,
  });

  @override
  Future<void> save(AccountEntity account) async {
    saveSecureCacheStorage.saveSecure(
      key: 'token',
      value: account.token,
    );
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({required String key, required String value});
}

@GenerateMocks([SaveSecureCacheStorage])
void main() {
  late LocalSaveCurrentAccount sut;
  late MockSaveSecureCacheStorage cacheStorage;
  late AccountEntity account;

  setUp(() {
    account = AccountEntity(faker.guid.guid());
    cacheStorage = MockSaveSecureCacheStorage();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
  });

  test(
    'Should call SaveSecureCacheStorage with correct values',
    () async {
      await sut.save(account);

      verify(
        cacheStorage.saveSecure(
          key: 'token',
          value: account.token,
        ),
      ).called(1);
    },
  );
}
