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
    final email = 'rinaalfarsi@gmail.com';
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
      // expect(find.byKey(const Key('verifyPinButton_pinPage')), findsOneWidget);
      // await addDelay(3000); //3 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

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

      await tester
          .tap(find.byKey(const ValueKey('PopupDeleteButton_profilePage')));
      await addDelay(3000); //3 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.
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

      expect(find.byKey(const Key('openReport_emergencyCasesPage')),
          findsOneWidget);
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
