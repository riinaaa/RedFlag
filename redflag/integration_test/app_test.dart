import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
//1
//Imports main.dart to get access to MyApp().
import 'package:redflag/main.dart';
//2
//Imports material.dart to access Flutter widgets.
import 'package:flutter/material.dart';

import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:redflag/nav_pages_UI/add_ec.dart';
import 'package:redflag/nav_pages_UI/mapPage.dart';
import 'package:redflag/nav_pages_UI/nav.dart';
import 'package:redflag/nav_pages_UI/profilePage.dart';
import 'package:redflag/nav_pages_UI/reports/emergencyCasesList.dart';
import 'package:redflag/nav_pages_UI/reportsPage.dart';
import 'package:redflag/registration_pages/landing_screen.dart';

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

  group('end-to-end test', () {
    //TODO: add random email var here
    // final timeBasedEmail =
    //     DateTime.now().microsecondsSinceEpoch.toString() + '@test.com';
    final email = 'maha@gmail.com';
    final password = '123456';

    //------------ Login + Activation Testing ------------
    testWidgets('Login + Activation Testing', (WidgetTester tester) async {
      //TODO: add Firebase Initialization Here
      await Firebase
          .initializeApp(); //This code ensures your app is ready to use Firebase services.
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      //TODO: Add here
      await tester.tap(find.byKey(const ValueKey('homeLoginButton')));
      //TODO: Add code here
      //1
      tester.printToConsole('SignUp screen opens');
      //2
      await tester.pumpAndSettle();
      //3
      await tester.enterText(
          find.byKey(const ValueKey('emailField_login')), email);

      //1
      await tester.enterText(
          find.byKey(const ValueKey('passwordField_login')), password);

      //2
      await tester.tap(find.byKey(const ValueKey('signInButton')));
      //TODO: add addDelay() statement here
      await addDelay(5000); //adds a delay of 24 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      expect(find.byKey(const Key('ActivationButton')), findsOneWidget);

      // await tester.tap(find.byKey(const ValueKey('ActivationButton')));
      // await addDelay(5000); //adds a delay of 10 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

      // expect(find.byKey(const Key('verifyPinButton_pinPage')), findsOneWidget);
      // await addDelay(35000); //adds a delay of 35 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

      // expect(find.byKey(const Key('TerminationButton')), findsOneWidget);
      // await addDelay(65000); //adds a delay of 65 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

      // await tester.tap(find.byKey(const ValueKey('TerminationButton')));
      // await addDelay(5000); //adds a delay of 5 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

      // expect(
      //     find.byKey(const ValueKey('pinTextField_pinPage')), findsOneWidget);
      // await addDelay(5000); //adds a delay of 5 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

      // await tester.enterText(
      //     find.byKey(const ValueKey('pinTextField_pinPage')), '1234');
      // await addDelay(5000); //adds a delay of 5 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

      // await tester.tap(find.byKey(const ValueKey('verifyPinButton_pinPage')));
      // await addDelay(5000); //adds a delay of 5 seconds.
      // await tester.pumpAndSettle(); //waits for all the animations to complete.

      // expect(find.byKey(const Key('ActivationButton')), findsOneWidget);
      await addDelay(5000); //adds a delay of 5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.
    });

    //------------ Profile Page Testing------------
    testWidgets('Profile Page Testing', (WidgetTester tester) async {
      //TODO: add Firebase Initialization Here
      await Firebase
          .initializeApp(); //This code ensures your app is ready to use Firebase services.
      await tester.pumpWidget(MaterialApp(home: profilePage()));
      await tester.pumpAndSettle();

      await addDelay(20000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      expect(find.byKey(const Key('currentEmergencyContactsList_profilePage')),
          findsOneWidget);
      await addDelay(5000); //adds a delay of 5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.
    });

    //------------ Add Page Testing------------

    testWidgets('Add Page Testing', (WidgetTester tester) async {
      //TODO: add Firebase Initialization Here
      await Firebase
          .initializeApp(); //This code ensures your app is ready to use Firebase services.
      await tester.pumpWidget(MaterialApp(home: add()));
      await tester.pumpAndSettle();

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.enterText(
          find.byKey(const ValueKey('nameField_addPage')), 'Rina');

      await tester.enterText(find.byKey(const ValueKey('emailField_addPage')),
          'rinaAlfarsi@gmail.com');

      await tester.tap(find.byKey(const ValueKey('addButton_addPage')));

      await addDelay(5000); //adds a delay of 5 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.
    });

    //------------ Map Page Testing------------

    // testWidgets('Map Page Testing', (WidgetTester tester) async {
    //   //TODO: add Firebase Initialization Here
    //   await Firebase
    //       .initializeApp(); //This code ensures your app is ready to use Firebase services.
    //   await tester.pumpWidget(MaterialApp(home: mapPage()));
    //   await tester.pumpAndSettle();

    //   await addDelay(10000); //adds a delay of 20 seconds.
    //   await tester.pumpAndSettle(); //waits for all the animations to complete.

    //   expect(find.byKey(const Key('GoogleMap_mapPage')), findsOneWidget);

    //   await addDelay(5000); //adds a delay of 5 seconds.
    //   await tester.pumpAndSettle(); //waits for all the animations to complete.
    // });

    //------------ Report Page Testing------------

    testWidgets('Report Page Testing', (WidgetTester tester) async {
      //TODO: add Firebase Initialization Here
      await Firebase
          .initializeApp(); //This code ensures your app is ready to use Firebase services.
      await tester.pumpWidget(MaterialApp(home: cemrgencyCases()));
      await tester.pumpAndSettle();

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.tap(
          find.byKey(const ValueKey('caseNumberButton_emergencyCasesPage')));

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester
          .tap(find.byKey(const ValueKey('copyLocationLinkButton_reportPage')));

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.tap(
          find.byKey(const ValueKey('playAudioButton_Page'))); // to Play it

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.tap(
          find.byKey(const ValueKey('playAudioButton_Page'))); // to pause it

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.tap(find.byKey(const ValueKey('returnButton_reportPage')));

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      await tester.tap(find.byKey(const ValueKey('logoutButton')));

      await addDelay(10000); //adds a delay of 20 seconds.
      await tester.pumpAndSettle(); //waits for all the animations to complete.

      expect(find.byKey(const Key('signInButton')), findsOneWidget);
    });
  });
}
