import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/ui/pages/login/login.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginPresenter])
void main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockLoginPresenter();
    emailErrorController = StreamController<String>();

    when(presenter.emailErrorStream).thenAnswer(
      (realInvocation) => emailErrorController.stream,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(
          presenter: presenter,
        ),
      ),
    );
  }

  tearDown(() {
    emailErrorController.close();
  });

  testWidgets(
    'Should load with correct initial state',
    (WidgetTester tester) async {
      await loadPage(tester);

      final emailTextFormFieldChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(
        emailTextFormFieldChildren,
        findsOneWidget,
        reason: '''
          When a TextFormField has only one child, means it has no errors,
          since one of the children is always the label text.
        ''',
      );

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

  testWidgets(
    'Should call validate with correct values',
    (tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(presenter.validatePassword(password));
    },
  );

  testWidgets(
    'Should present error if email is invalid',
    (tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );
}
