import 'package:for_dev/ui/pages/pages.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

import '../../factories.dart';

LoginPresenter makeLoginPresenter() {
  return GetLoginPresenter(
    validation: makeLoginValidation(),
    authentication: makeAuthentication(),
    saveCurrentAccount: makeLocalSaveCurrentAccount(),
  );
}
