import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login_presenter.dart';
import 'package:for_dev/ui/pages/login/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double contentMaxHeight = 650;

          final double pageMaxHeight = constraints.maxHeight > contentMaxHeight
              ? constraints.maxHeight
              : contentMaxHeight;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: pageMaxHeight),
              child: Column(
                children: [
                  const LoginPageHeader(),
                  Expanded(
                    child: LoginPageForm(
                      presenter: presenter,
                    ),
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
