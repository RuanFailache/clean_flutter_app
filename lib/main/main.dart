import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:for_dev/ui/theme/theme.dart';

import 'factories/factories.dart';

void main() {
  runApp(const ForDevApp());
}

class ForDevApp extends StatelessWidget {
  const ForDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ForDev',
      theme: theme,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: makeLoginPage),
      ],
    );
  }
}
