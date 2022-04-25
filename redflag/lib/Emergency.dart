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
  var caseNumber;
  var endTime;
  var userLocation;
  var audioRecording;

  get getCaseNumber => this.caseNumber;

  set setCaseNumber(caseNumber) => this.caseNumber = caseNumber;

  get getEndTime => this.endTime;

  set setEndTime(endTime) => this.endTime = endTime;

  get getUserLocation => this.userLocation;

  set setUserLocation(userLocation) => this.userLocation = userLocation;

  get getAudioRecording => this.audioRecording;

  set setAudioRecording(audioRecording) => this.audioRecording = audioRecording;

  Emergency({
    this.caseNumber,
    this.endTime,
    this.userLocation,
    this.audioRecording,
  }) {
    caseNumber = this.caseNumber;
    endTime = this.endTime;
    userLocation = this.userLocation;
    audioRecording = this.audioRecording;
  }

  // receiving data from server
  factory Emergency.fromMap(map) {
    return Emergency(
      caseNumber: map['caseNumber'],
      endTime: map['endTime'],
      userLocation: map['userLocation'],
      audioRecording: map['audioRecording'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap(String uid) {
    return {
      'caseNumber': caseNumber,
      'endTime': endTime,
      'userLocation': userLocation,
      'audioRecording': audioRecording,
      'user': uid,
    };
  }

  // void autoMute(bool mute) {}
  // void autoVideoRecording() {}
  // String locateUser() {
  //   return '';
  // }

  // String nearestPoliceStations() {
  //   return '';
  // }

  sendMail(List<dynamic> recipients, String subject, String msg) async {
    String username = 'redflagapp.8@gmail.com';
    String password = 'Redflag123';

    String f = recipients.join(', ');
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..ccRecipients.addAll(recipients)
      ..subject = '$subject :::: ${DateTime.now()}'
      ..html = '$msg';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      print(recipients);
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
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
