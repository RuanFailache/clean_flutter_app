import 'package:flutter/material.dart';

class SpinnerDialog extends StatelessWidget {
  const SpinnerDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const SpinnerDialog(),
    );
  }

  static void hide(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
    );
  }
}
