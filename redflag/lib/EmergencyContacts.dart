import 'package:flutter/material.dart';
import './EmergencyContacts.dart';

class EmergencyContacts {
  //const EmergencyContacts({ Key? key }) : super(key: key);

  var eFullName;
  var phoneNumber;
  String? uid;

  EmergencyContacts({this.uid, this.eFullName, this.phoneNumber}) {
    eFullName = this.eFullName;
    phoneNumber = this.phoneNumber;
    uid = this.uid;
  }

  String get getFullName => this.eFullName;

  set setFullName(String fullName) => this.eFullName = fullName;

  get getPhoneNumber => this.phoneNumber;

  set setPhoneNumber(phoneNumber) => this.phoneNumber = phoneNumber;

  // receiving data from server
  factory EmergencyContacts.fromMap(map) {
    return EmergencyContacts(
      uid: map['uid'],
      phoneNumber: map['phoneNumber'],
      eFullName: map['eFullName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'eFullName': eFullName,
    };
  }
}
