import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redflag/nav_pages_UI/activatePage.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:redflag/registration_pages/landing_screen.dart' as app;
import 'package:redflag/registration_pages/landing_screen.dart';
// import 'package:integration_tests_in_the_cloud/screens/menu.dart';
import './mock.dart';

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  // WidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    "----------------------login test----------------------",
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LandingScreen()));

      // app.LandingScreen;
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final homeLoginButton = find.byKey(const Key('homeLoginButton'));
      expect(homeLoginButton, findsOneWidget);

      await tester.tap(homeLoginButton);
      await tester.pumpAndSettle();

      Finder emailField = find.byKey(const Key('emailField_login'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, 'lana@gmail.com');

      Finder passwordField = find.byKey(const Key('passwordField_login'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, '123456');

      Finder loginField = find.byKey(const Key('signInButton'));
      expect(loginField, findsOneWidget);

      await tester.tap(find.byKey(const Key('signInButton')));

      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 20));

      // expect(find.byType(activationPage), findsNothing);
      expect(find.byKey(const Key('ActivationButton')), findsOneWidget);
    },
  );

  // testWidgets(
  //   "----------------------Activation page widget test----------------------",
  //   (WidgetTester tester) async {
  //     await tester.pumpWidget(MaterialApp(home: activationPage()));

  //     // app.LandingScreen;
  //     await tester.pump();
  //     await tester.pumpAndSettle(const Duration(seconds: 2));

  //     final homeLoginButton = find.byKey(const Key('homeLoginButton'));
  //     expect(homeLoginButton, findsOneWidget);

  //     await tester.tap(homeLoginButton);
  //     await tester.pumpAndSettle();

  //     Finder emailField = find.byKey(const Key('emailField_login'));
  //     expect(emailField, findsOneWidget);
  //     // await tester.enterText(emailField, 'lana@gmail.com');

  //     Finder passwordField = find.byKey(const Key('passwordField_login'));
  //     expect(passwordField, findsOneWidget);
  //     // await tester.enterText(passwordField, '123456');

  //     Finder loginField = find.byKey(const Key('signInButton'));
  //     expect(loginField, findsOneWidget);

  //     // await tester.tap(find.byKey(const Key('signInButton')));

  //     // await tester.pump();
  //     // await tester.pumpAndSettle(const Duration(seconds: 20));

  //     // expect(find.byKey(SnackBar), findsNothing);
  //     // expect(find.byKey(const Key('ActivationButton')), findsOneWidget);
  //   },
  // );
}
