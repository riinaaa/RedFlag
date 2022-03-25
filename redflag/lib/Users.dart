import 'package:flutter/material.dart';
import './EmergencyContacts.dart';

class Users extends StatelessWidget {
  //const User({ Key? key }) : super(key: key);

  var userFirstName;
  var userLastName;
  var uid;
  var password;
  var email;
  var keyword;
  var pin;
  var emergencyContacts = <EmergencyContacts>{}; //Not sure!!

  Users(this.userFirstName, this.userLastName, this.uid, this.password,
      this.email, this.keyword, this.pin, this.emergencyContacts) {
    userFirstName = this.userLastName;
    userLastName = this.userLastName;
    uid = this.uid;
    email = this.email;
    password = this.password;
    keyword = this.keyword;
    pin = this.pin;
    emergencyContacts = this.emergencyContacts;
  }

  get getUserFirstName => this.userFirstName;

  set setUserFirstName(userFirstName) => this.userFirstName = userFirstName;

  get getUserLastName => this.userLastName;

  set setUserLastName(userLastName) => this.userLastName = userLastName;

  get getPassword => this.password;

  set setPassword(password) => this.password = password;

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

  //----------- UI -----------
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
