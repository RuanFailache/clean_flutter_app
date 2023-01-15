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
  late StreamController<String> passwordErrorController;

  Finder getTextFormFieldChildrenByIcon(IconData icon) {
    return find.descendant(
      of: find.ancestor(
        of: find.byIcon(icon),
        matching: find.byType(TextFormField),
      ),
      matching: find.byType(Text),
    );
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockLoginPresenter();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();

    when(presenter.emailErrorStream).thenAnswer(
      (realInvocation) => emailErrorController.stream,
    );

    when(presenter.passwordErrorStream).thenAnswer(
      (realInvocation) => passwordErrorController.stream,
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

      expect(
        getTextFormFieldChildrenByIcon(Icons.email),
        findsOneWidget,
        reason: '''
          When a TextFormField has only one child, means it has no errors,
          since one of the children is always the label text.
        ''',
      );

      expect(
        getTextFormFieldChildrenByIcon(Icons.lock),
        findsOneWidget,
      );

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

  testWidgets(
    'Should present no error if email is valid',
    (tester) async {
      await loadPage(tester);

      emailErrorController.add('');
      await tester.pump();

      expect(
        getTextFormFieldChildrenByIcon(Icons.email),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Should present error if password is invalid',
    (tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'Should present no error if password is valid',
    (tester) async {
      await loadPage(tester);

      emailErrorController.add('');
      await tester.pump();

      expect(
        getTextFormFieldChildrenByIcon(Icons.lock),
        findsOneWidget,
      );
    },
  );
}
