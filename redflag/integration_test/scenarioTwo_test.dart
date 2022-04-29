import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
//1
//Imports main.dart to get access to MyApp().
import 'package:redflag/main.dart';
//2
//Imports material.dart to access Flutter widgets.
import 'package:flutter/material.dart';

import 'package:redflag/nav_pages_UI/add_ec.dart';
import 'package:redflag/nav_pages_UI/mapPage.dart';
import 'package:redflag/nav_pages_UI/profilePage.dart';
import 'package:redflag/nav_pages_UI/reports/emergencyCasesList.dart';

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

void main() {
  //ensureInitialized() verifies the integration test driver’s initialization.
  //It also reinitializes the driver if it isn’t initialized.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  group('Integration test', () {
    // final email = 'maha@gmail.com';
    // final password = '123456';

    // //------------ Sign Up Testing ------------
    // testWidgets('Sign Up Testing', (WidgetTester tester) async {

    //   //--------------Run the app-----------------
    //   //add Firebase Initialization Here
    //   await Firebase
    //       .initializeApp(); //This code ensures your app is ready to use Firebase services.
    //   await tester.pumpWidget(MyApp());
    //   await tester.pumpAndSettle();

    //   //--------------Open the Sign up screen-----------------
    //   expect(find.byKey(const Key('homeSignUpButton')), findsOneWidget);
    //   await addDelay(3000); //5 seconds.
    //   await tester.pumpAndSettle(); //waits for all the animations to complete.
    //   await tester.tap(find.byKey(const ValueKey('homeSignUpButton')));
    //   await tester.pumpAndSettle();

    //   //--------------Enter in the TextFields (Frame 1)-----------------
    //   expect(find.byKey(const Key('firstNameTextField_registPage')),
    //       findsOneWidget);
    //   expect(find.byKey(const Key('secondNameTextField_registPage')),
    //       findsOneWidget);
    //   expect(find.byKey(const Key('userEmailTextField_registPage')),
    //       findsOneWidget);
    //   expect(find.byKey(const Key('passwordTextField_registPage')),
    //       findsOneWidget);
    //   expect(find.byKey(const Key('confirmPasswordTextField_registPage')),
    //       findsOneWidget);
    //   expect(find.byKey(const Key('registerdPinTextField_registPage')),
    //       findsOneWidget);
    //   // expect(find.byKey(const Key('nextButton_registPage')), findsOneWidget);

    //   await addDelay(3000); //5 seconds.
    //   await tester.pumpAndSettle(); //waits for all the animations to complete.

    //   await tester.enterText(
    //       find.byKey(const ValueKey('firstNameTextField_registPage')), 'Nora');

    //   await tester.enterText(
    //       find.byKey(const ValueKey('secondNameTextField_registPage')),
    //       'Alghamdi');

    //   await tester.enterText(
    //       find.byKey(const ValueKey('userEmailTextField_registPage')),
    //       'nora@gmail.com');

    //   await tester.enterText(
    //       find.byKey(const ValueKey('passwordTextField_registPage')), '123456');

    //   await tester.enterText(
    //       find.byKey(const ValueKey('confirmPasswordTextField_registPage')),
    //       '123456');

    //   await tester.enterText(
    //       find.byKey(const ValueKey('registerdPinTextField_registPage')),
    //       '1234');

    //   await addDelay(3000); //3 seconds.
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('Next'));
    //   await addDelay(5000); //5 seconds.
    //   await tester.pumpAndSettle();

    //   //--------------Enter in the TextFields (Frame 2)-----------------

    //   await tester.enterText(
    //       find.byKey(const ValueKey('keywordTextField_registPage')), 'No');

    //   await tester.enterText(
    //       find.byKey(const ValueKey('confirmKeywordTextField_registPage')),
    //       'No');

    //   await addDelay(3000); //3 seconds.
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.text('Next'));
    //   await addDelay(5000); //5 seconds.
    //   await tester.pumpAndSettle();

    //   //--------------Enter in the TextFields (Frame 3)-----------------

    //   await tester.enterText(
    //       find.byKey(const ValueKey('ecNameTextField_registPage')), 'Rina');

    //   await tester.enterText(
    //       find.byKey(const ValueKey('ecEmailTextField_registPage')),
    //       'RinaAlfarsi@gmail.com');

    //   await addDelay(3000); //3 seconds.
    //   await tester.pumpAndSettle();
    //   await tester.tap(find.byKey(const ValueKey('RegisterButton_registPage')));
    //   await addDelay(5000); //5 seconds.
    //   await tester.pumpAndSettle();

    //   //--------------Check again if the Activation button in the current screen-----------------
    //   expect(find.byKey(const Key('ActivationButton')), findsOneWidget);
    //   await addDelay(5000); //5 seconds.
    //   await tester.pumpAndSettle(); //waits for all the animations to complete.
    // });

    final email = 'futoon@gmail.com';
    final password = '123456';

    //------------ Login + Activation Testing ------------
    testWidgets('Login + Activation Testing', (WidgetTester tester) async {
      //--------------Run the app-----------------
      //add Firebase Initialization Here
      await Firebase
          .initializeApp(); //This code ensures your app is ready to use Firebase services.
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      //--------------Open the login screen-----------------
      expect(find.byKey(const Key('homeLoginButton')), findsOneWidget);
      await addDelay(5000); //5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.
      await tester.tap(find.byKey(const ValueKey('homeLoginButton')));
      await tester.pumpAndSettle();

      //--------------Enter the email and password in the TextFields-----------------
      await tester.enterText(
          find.byKey(const ValueKey('emailField_login')), email);
      await tester.enterText(
          find.byKey(const ValueKey('passwordField_login')), password);

      //--------------Open the Activation Screen-----------------
      await tester.tap(find.byKey(const ValueKey('signInButton')));
      await addDelay(5000); //5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      //--------------Check if the activation button in the current screen-----------------
      expect(find.byKey(const Key('ActivationButton')), findsOneWidget);

      //--------------Open the Pin Screen-----------------
      await tester.tap(find.byKey(const ValueKey('ActivationButton')));
      await addDelay(5000); //5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      //--------------Check if the verify pin button in the current screen-----------------
      expect(find.byKey(const Key('verifyPinButton_pinPage')), findsOneWidget);
      await addDelay(3000); //3 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.enterText(
          find.byKey(const ValueKey('pinTextField_pinPage')), '1234');
      await addDelay(5000); //5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      //--------------return to the Activation Screen-----------------
      await tester.tap(find.byKey(const ValueKey('verifyPinButton_pinPage')));
      await addDelay(3000); // 3 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      //--------------Check again if the Activation button in the current screen-----------------
      expect(find.byKey(const Key('ActivationButton')), findsOneWidget);
      await addDelay(5000); //5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.
    });

    // //------------ Profile Page Testing------------
    testWidgets('Profile Page Testing', (WidgetTester tester) async {
      //add Firebase Initialization Here
      await Firebase
          .initializeApp(); //This code ensures your app is ready to use Firebase services.
      await tester.pumpWidget(MaterialApp(home: profilePage()));
      await tester.pumpAndSettle();

      // Since the retriving of data from Firebase is slow, we will wait 10 sec before starting checking the widgets
      await addDelay(10000); //10 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      //--------------Check if the Current Emergency Contacts List in the current screen-----------------
      expect(find.byKey(const Key('currentEmergencyContactsList_profilePage')),
          findsOneWidget);
      await addDelay(3000); //3 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.tap(find.byKey(const ValueKey('deleteButton')));
      await addDelay(3000); //3 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      expect(find.byKey(const Key('currentEmergencyContactsList_profilePage')),
          findsNothing);
    });

    //------------ Report Page Testing------------

    testWidgets('Report Page Testing', (WidgetTester tester) async {
      //add Firebase Initialization Here
      await Firebase
          .initializeApp(); //This code ensures your app is ready to use Firebase services.
      await tester.pumpWidget(MaterialApp(home: cemrgencyCases()));
      await tester.pumpAndSettle();

      // Since the retriving of data from Firebase is slow, we will wait 10 sec before starting displaying the widgets
      await addDelay(10000); //10 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      expect(find.byKey(const Key('caseNumberButton_emergencyCasesPage')),
          findsNothing);
      await addDelay(3000); //3 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      //--------------Logout-----------------
      expect(find.byKey(const Key('logoutButton')), findsOneWidget);
      await addDelay(5000); //5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.
      await tester.tap(find.byKey(const ValueKey('logoutButton')));
      await addDelay(10000); //10 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      //--------------Check if the login button is in the current screenn-----------------
      expect(find.byKey(const Key('signInButton')), findsOneWidget);
    });
  });
}
