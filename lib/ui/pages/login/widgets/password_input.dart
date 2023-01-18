import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validatePassword,
          decoration: InputDecoration(
            labelText: 'Senha',
            icon: const Icon(Icons.lock),
            errorText: snapshot.data?.isNotEmpty == true ? snapshot.data : null,
          ),
        );
      },
    );
  }
}
