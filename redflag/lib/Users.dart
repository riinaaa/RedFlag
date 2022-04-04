import 'package:flutter/material.dart';
import './EmergencyContacts.dart';

class Users {
  //const User({ Key? key }) : super(key: key);
  var uid;
  var userFirstName;
  var userLastName;
  var email;
  var keyword;
  var pin;
  List<EmergencyContacts> emergencyContacts = [];

  Users(
      {this.userFirstName,
      this.userLastName,
      this.uid,
      this.email,
      this.keyword,
      this.pin,
      List<EmergencyContacts>? emergencyContacts}) {
    userFirstName = this.userLastName;
    userLastName = this.userLastName;
    uid = this.uid;
    email = this.email;
    keyword = this.keyword;
    pin = this.pin;
    emergencyContacts = emergencyContacts ?? [];
  }

  get getUserFirstName => this.userFirstName;

  set setUserFirstName(userFirstName) => this.userFirstName = userFirstName;

  get getUserLastName => this.userLastName;

  set setUserLastName(userLastName) => this.userLastName = userLastName;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getKeyword => this.keyword;

  set setKeyword(keyword) => this.keyword = keyword;

  get getPin => this.pin;

  set setPin(pin) => this.pin = pin;

  get getEmergencyContacts => this.emergencyContacts;

  set setEmergencyContacts(emergencyContacts) =>
      this.emergencyContacts = emergencyContacts;

  Users.empty();

  // receiving data from server
  factory Users.fromMap(map) {
    return Users(
      uid: map['uid'],
      email: map['email'],
      userFirstName: map['userFirstName'],
      userLastName: map['userLastName'],
      keyword: map['keyword'],
      pin: map['pin'],
      // emergencyContacts: map['emergencyContacts'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'keyword': keyword,
      'pin': pin,
    };
  }
}
