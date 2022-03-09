import 'package:flutter/material.dart';
import 'package:redflag/User.dart';
import './User.dart';
import './AccessStatus.dart';

class Emergency extends StatelessWidget {
  //const ({ Key? key }) : super(key: key);

  AccessStatus access = new AccessStatus.empty();
  User user = new User.empty();
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
