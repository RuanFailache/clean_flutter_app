import 'package:flutter/material.dart';
import 'package:for_dev/ui/pages/login/login_presenter.dart';

class LoginPageHeader extends StatelessWidget {
  const LoginPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 64,
        top: 64 + MediaQuery.of(context).viewPadding.top,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
        ),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
          end: Alignment.bottomLeft,
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset.zero,
            spreadRadius: 0,
            blurRadius: 4,
            color: Colors.black,
          )
        ],
      ),
      child: Center(
        child: Image.asset('lib/ui/assets/logo.png'),
      ),
    );
  }
}
