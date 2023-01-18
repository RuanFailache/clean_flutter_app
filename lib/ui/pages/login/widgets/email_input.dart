import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login.dart';
import 'package:provider/provider.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validateEmail,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: const Icon(Icons.email),
            errorText: snapshot.data?.isNotEmpty == true ? snapshot.data : null,
          ),
        );
      },
    );
  }
}
