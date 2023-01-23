import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:for_dev/ui/components/components.dart';

import 'widgets/widgets.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage({
    super.key,
    required this.presenter,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double contentMaxHeight = 650;

          final double pageMaxHeight = constraints.maxHeight > contentMaxHeight
              ? constraints.maxHeight
              : contentMaxHeight;

          widget.presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              SpinnerDialog.show(context);
            } else {
              SpinnerDialog.hide(context);
            }
          });

          widget.presenter.authErrorStream.listen((error) {
            if (error == null || error.isEmpty) {
              return;
            }
            ErrorSnackBar.show(context, error);
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: pageMaxHeight),
                child: Column(
                  children: [
                    const LoginPageHeader(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Provider(
                          create: (_) => widget.presenter,
                          child: Form(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login'.toUpperCase(),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                const SizedBox(height: 32),
                                const EmailInput(),
                                const SizedBox(height: 16),
                                const PasswordInput(),
                                const SizedBox(height: 24),
                                const LoginButton(),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () {},
                                  child: Wrap(
                                    spacing: 8,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: const [
                                      Icon(Icons.person),
                                      Text('Criar conta'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
