import 'package:flutter/material.dart';
import 'package:redflag/Users.dart';
import 'Users.dart';
import './AccessStatus.dart';

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

  void sendSMS() {}
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
