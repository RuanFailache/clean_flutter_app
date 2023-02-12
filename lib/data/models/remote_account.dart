import 'package:for_dev/data/datasources/http/http.dart';
import 'package:for_dev/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (json.containsKey('accessToken')) {
      return RemoteAccountModel(json['accessToken']);
    }
    throw HttpError.invalidData;
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
