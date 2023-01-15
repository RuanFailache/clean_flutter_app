import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login_presenter.dart';

class LoginPageForm extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPageForm({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              stream: presenter.emailErrorStream,
              builder: (context, snapshot) {
                final hasErrorText = snapshot.data?.isNotEmpty == true;
                return TextFormField(
                  onChanged: presenter.validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: hasErrorText ? snapshot.data : null,
                    icon: const Icon(Icons.email),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            StreamBuilder(
              stream: presenter.passwordErrorStream,
              builder: (context, snapshot) {
                final hasErrorText = snapshot.data?.isNotEmpty == true;
                return TextFormField(
                  onChanged: presenter.validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    errorText: hasErrorText ? snapshot.data : null,
                    icon: const Icon(Icons.lock),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: StreamBuilder<bool>(
                stream: presenter.isFormValidController,
                builder: (context, snapshot) {
                  return ElevatedButton(
                    onPressed: snapshot.data == true ? presenter.auth : null,
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
    );
  }
}
