import 'package:flutter/material.dart';

import 'package:for_dev/ui/pages/pages.dart';

import '../../factories.dart';

Widget makeLoginPage() {
  return LoginPage(
    presenter: makeLoginPresenter(),
  );
}
