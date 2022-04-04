import 'package:flutter/material.dart';
import './EmergencyContacts.dart';

class EmergencyContacts {
  //const EmergencyContacts({ Key? key }) : super(key: key);

  var eFullName;
  var phoneNumber;

  EmergencyContacts({this.eFullName, this.phoneNumber}) {
    eFullName = this.eFullName;
    phoneNumber = this.phoneNumber;
  }

  String get getFullName => this.eFullName;

  set setFullName(String fullName) => this.eFullName = fullName;

  get getPhoneNumber => this.phoneNumber;

  set setPhoneNumber(phoneNumber) => this.phoneNumber = phoneNumber;

  // receiving data from server
  factory EmergencyContacts.fromMap(map) {
    return EmergencyContacts(
      phoneNumber: map['phoneNumber'],
      eFullName: map['eFullName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap(String uid) {
    return {
      'phoneNumber': phoneNumber,
      'eFullName': eFullName,
      'user': 'users/' + uid
    };
  }
}
