import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redflag/Users.dart';
import 'Users.dart';
import './AccessStatus.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Emergency extends StatelessWidget {
  //const ({ Key? key }) : super(key: key);

  AccessStatus access = new AccessStatus.empty();
  Users user = new Users.empty();
  var mute;
  var userCoordinate;
  var policeStationCoordinatef = <String>[];
  DateTime startTime = new DateTime.now();
  DateTime endTimo = new DateTime.now();
  var enteredPIN;

  void autoMute(bool mute) {}
  void autoVideoRecording() {}
  String locateUser() {
    return '';
  }

  String nearestPoliceStations() {
    return '';
  }

  sendMail(String recipients, String subject, String msg) async {
    String username = 'redflagapp.8@gmail.com';
    String password = 'Redflag123';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(recipients)
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = '$subject :::: ${DateTime.now()}'
      // ..text = 'heloooooo.\nThis is line 2 of the text part.'
      ..html = '$msg';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      // Toast.show("You have clicked the Button! and email sent", context,
      //     duration: 3, gravity: Toast.CENTER);
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  bool verifyPIN(int enteredPIN) {
    return false;
  }

  bool imSafeButton() {
    return false;
  }

  String genrateReport() {
    return '';
  }
  //----------- UI -----------

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/////////////////////////////////////////////////
