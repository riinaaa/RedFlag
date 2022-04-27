import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:redflag/main.dart';
import 'package:redflag/registration_pages/login_screen.dart';

void main() {
  testWidgets('login', (WidgetTester tester) async {
    await tester.pumpWidget(LoginScreen());

    // var textField = find.byKey(const ValueKey('emailField_login'));
    // expect(textField, findsOneWidget);
    var emailField = find.byKey(Key("emailField_login"));

    expect(emailField, findsOneWidget);

    // await tester.enterText(textField, 'Hello');
    // expect(find.text('Hello'), findsOneWidget);

    // var button = find.text("Reverse");
    // expect(button, findsOneWidget);

    // await tester.tap(button);
    // await tester.pump();
    // expect(find.text("olleH"), findsOneWidget);
  });
}
