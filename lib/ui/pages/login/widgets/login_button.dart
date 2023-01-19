import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return SizedBox(
      width: double.infinity,
      child: StreamBuilder<bool>(
        stream: presenter.isFormValidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true ? presenter.auth : null,
            child: const Text('Entrar'),
          );
        },
      ),
    );
  }
}
