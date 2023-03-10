import '../../../domain/entities/account_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

import '../../datasources/datasources.dart';
import '../../models/models.dart';

class RemoteAuthentication extends Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final httpClientResponse = await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );

      if (httpClientResponse == null) {
        throw HttpError.serverError;
      }

      return RemoteAccountModel.fromJson(httpClientResponse).toEntity();
    } on HttpError catch (err) {
      throw err == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(
    AuthenticationParams params,
  ) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.secret,
      );

  Map toJson() => {'email': email, 'password': password};
}
