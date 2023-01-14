import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login_page.dart';
import 'package:for_dev/ui/theme/theme.dart';

class ForDevApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ForDev',
      theme: theme,
      home: LoginPage(),
    );
  }
}
