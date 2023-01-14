import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_dev/ui/pages/login/login_page.dart';

void main() {
  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginPage(),
        ),
      );

      final emailTextFormFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      /*
       * When a TextFormField has only one child, means it has no errors,
       * since one of the children is always the label text.
       */
      expect(emailTextFormFieldChildren, findsOneWidget);

      final passwordTextFormFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(passwordTextFormFieldChildren, findsOneWidget);

      final submitFormButton = tester.widget<ElevatedButton>(
        find.byType(
          ElevatedButton,
        ),
      );

      expect(submitFormButton.onPressed, null);
    },
  );
}
