import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/datasources/cache/cache.dart';
import 'package:for_dev/data/usecases/usecases.dart';

import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/entities/entities.dart';

import 'local_save_current_account_test.mocks.dart';

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

  test(
    'Should throw UnexpectedError if SaveSecureCacheStorage throws',
    () async {
      when(
        cacheStorage.saveSecure(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenThrow(Exception());

      final future = sut.save(account);

      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
