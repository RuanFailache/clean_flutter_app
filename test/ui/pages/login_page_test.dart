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
  late StreamController<String> loginErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

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
    loginErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();

    when(presenter.emailErrorStream).thenAnswer(
      (realInvocation) => emailErrorController.stream,
    );

    when(presenter.passwordErrorStream).thenAnswer(
      (realInvocation) => passwordErrorController.stream,
    );

    when(presenter.loginErrorController).thenAnswer(
      (realInvocation) => loginErrorController.stream,
    );

    when(presenter.isFormValidController).thenAnswer(
      (realInvocation) => isFormValidController.stream,
    );

    when(presenter.isLoadingController).thenAnswer(
      (realInvocation) => isLoadingController.stream,
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
    passwordErrorController.close();
    loginErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
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
      expect(find.byType(CircularProgressIndicator), findsNothing);
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

  testWidgets(
    'Should disable button if form is invalid',
    (tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final submitFormButton = tester.widget<ElevatedButton>(
        find.byType(
          ElevatedButton,
        ),
      );

      expect(submitFormButton.onPressed, isNotNull);
    },
  );

  testWidgets(
    'Should enable button if form is valid',
    (tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final submitFormButton = tester.widget<ElevatedButton>(
        find.byType(
          ElevatedButton,
        ),
      );

      expect(submitFormButton.onPressed, null);
    },
  );

  testWidgets(
    'Should call authentication on form submit',
    (tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(presenter.auth()).called(1);
    },
  );

  testWidgets(
    'Should present loading',
    (tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should hide loading',
    (tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();
      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'Should present snack bar if authentication fails',
    (tester) async {
      await loadPage(tester);

      loginErrorController.add('login error');
      await tester.pump();

      expect(find.text('login error'), findsOneWidget);
    },
  );
}
