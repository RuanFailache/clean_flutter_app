import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double contentMaxHeight = 636.5;

          final double pageMaxHeight = constraints.maxHeight > contentMaxHeight
              ? constraints.maxHeight
              : contentMaxHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: pageMaxHeight),
              child: Column(
                children: const [
                  LoginPageHeader(),
                  Expanded(
                    child: LoginPageForm(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
