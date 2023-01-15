import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login.dart';
import 'package:for_dev/ui/theme/theme.dart';

class ForDevApp extends StatelessWidget {
  const ForDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ForDev',
      theme: theme,
      home: LoginPage(
        presenter: BlocLoginPresenter(),
      ),
    );
  }
}

class BlocLoginPresenter implements LoginPresenter {
  @override
  void validateEmail(String email) {
    // TODO: implement validateEmail
  }

  @override
  void validatePassword(String password) {
    // TODO: implement validatePassword
  }

  @override
  // TODO: implement emailErrorStream
  Stream<String> get emailErrorStream => throw UnimplementedError();

  @override
  // TODO: implement emailErrorStream
  Stream<String> get passwordErrorStream => throw UnimplementedError();

  @override
  // TODO: implement isFormValidController
  Stream<bool> get isFormValidController => throw UnimplementedError();

  @override
  void auth() {
    // TODO: implement auth
  }

  @override
  // TODO: implement isLoadingController
  Stream<bool> get isLoadingController => throw UnimplementedError();

  @override
  // TODO: implement loginErrorController
  Stream<String> get loginErrorController => throw UnimplementedError();
}
