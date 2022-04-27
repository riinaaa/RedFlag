import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:test/test.dart';

// SmtpServer? correctSmtpServer;
String username = 'redflagapp.8@gmail.com';
String password = 'Redflag123';
SmtpServer incorrectCredentials = gmail('fff@gmai.com', '44444');
SmtpServer correctCredentials = gmail(username, password);

void main() async {
// ----------------------- Incorrect email and password -----------------------
/**
 * If the email and pass are incorrect its throw an exeption, so the test will PASS
 */
  test('Incorrect email and password', () async {
    expect(
        checkCredentials(incorrectCredentials,
            timeout: const Duration(seconds: 5)),
        throwsA(TypeMatcher<SmtpClientAuthenticationException>()));
  });

// ----------------------- correct email and password -----------------------
/**
 * If the email and pass are correct its will not throw an exeption, so the test will FAILL
 */
  test('Correct email and password', () async {
    expect(
        checkCredentials(correctCredentials,
            timeout: const Duration(seconds: 5)),
        throwsA(TypeMatcher<SmtpClientAuthenticationException>()));
  });

  // ----------------------- correct recipients -----------------------
/**
 * If the recipients are correct its will send an email, so the test will Pass
 */

  Message createMessage() {
    return Message()
      ..from = Address(username)
      ..recipients.add(['a.atheer.141919@gmail.com', 'rina@gmail.com'])
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.';
  }

  test('The recipients is correct', () async {
    Message m = createMessage();
    List<dynamic> fakeRecipients = [
      ['a.atheer.141919@gmail.com', 'rina@gmail.com']
    ];

    expect(m.recipients, fakeRecipients);
  });
}
