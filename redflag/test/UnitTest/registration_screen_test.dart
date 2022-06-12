import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';

void main() {
  //Email and Password Authentication
  test('The Email address have been authenticated.', () async {
    final email = 'atheer@gmail.com';
    final password = 'AAlghamdi@8991';

    final auth = MockFirebaseAuth();
    final result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    final expectedResult = 'atheer@gmail.com';
    expect(user.email, expectedResult);
  });

  final test_User = MockUser(
    uid: '002',
    email: 'atheer@gmail.com',
  );

  // Login
  test('Login with email and password', () async {
    final auth = MockFirebaseAuth(mockUser: test_User);
    final result = await auth.signInWithEmailAndPassword(
        email: test_User.email!, password: '123456');
    final user = result.user!; //firebase
    expect(user.email, 'atheer@gmail.com');
  });

  // logout
  test('Returns null after sign out', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: test_User);
    await auth.signOut();
    expect(auth.currentUser, isNull);
  });
}

class FakeAuthCredential implements AuthCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
