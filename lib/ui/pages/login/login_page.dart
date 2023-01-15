import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login_presenter.dart';
import 'package:for_dev/ui/pages/login/widgets/widgets.dart';

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

          widget.presenter.isLoadingController.listen((event) {
            if (event) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SimpleDialog(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Aguarde...', textAlign: TextAlign.center),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              final navigator = Navigator.of(context);
              if (navigator.canPop()) {
                navigator.pop();
              }
            }
          });

          widget.presenter.loginErrorController.listen((event) {
            if (event.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[900],
                  content: Text(event),
                ),
              );
            }
          });

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: pageMaxHeight),
              child: Column(
                children: [
                  const LoginPageHeader(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login'.toUpperCase(),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            const SizedBox(height: 32),
                            StreamBuilder(
                              stream: widget.presenter.emailErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  onChanged: widget.presenter.validateEmail,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    icon: const Icon(Icons.email),
                                    errorText: snapshot.data?.isNotEmpty == true
                                        ? snapshot.data
                                        : null,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            StreamBuilder(
                              stream: widget.presenter.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  onChanged: widget.presenter.validatePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    icon: const Icon(Icons.lock),
                                    errorText: snapshot.data?.isNotEmpty == true
                                        ? snapshot.data
                                        : null,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: StreamBuilder<bool>(
                                stream: widget.presenter.isFormValidController,
                                builder: (context, snapshot) {
                                  return ElevatedButton(
                                    onPressed: snapshot.data == true
                                        ? widget.presenter.auth
                                        : null,
                                    child: const Text('Entrar'),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {},
                              child: Wrap(
                                spacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
