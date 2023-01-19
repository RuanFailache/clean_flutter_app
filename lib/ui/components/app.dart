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
  Stream<String?> get emailErrorStream => throw UnimplementedError();

  @override
  // TODO: implement emailErrorStream
  Stream<String?> get passwordErrorStream => throw UnimplementedError();

  @override
  // TODO: implement isFormValidStream
  Stream<bool> get isFormValidStream => throw UnimplementedError();

  @override
  Future<void> auth() async {
    // TODO: implement auth
  }

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  // TODO: implement loginErrorStream
  Stream<String> get loginErrorStream => throw UnimplementedError();

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
