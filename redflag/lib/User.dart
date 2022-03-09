import 'package:flutter/material.dart';
import './EmergencyContacts.dart';

class User extends StatelessWidget {
  //const User({ Key? key }) : super(key: key);

  var userFullName;
  var password;
  var email;
  var keyword;
  var pin;
  var usePhoneNumber;
  var emergencyContacts = <EmergencyContacts>{}; //Not sure!!

  User.empty();

  User(this.email, this.userFullName, this.usePhoneNumber, this.password,
      this.keyword, this.pin, this.emergencyContacts) {
    userFullName = this.userFullName;
    usePhoneNumber = this.usePhoneNumber;
    email = this.email;
    password = this.password;
    keyword = this.keyword;
    pin = this.pin;
    emergencyContacts = this.emergencyContacts;
  }

//var emergencyContacts = new EmergencyContacts();
  get getUserFullName => this.userFullName;

  set setUserFullName(var userFullName) => this.userFullName = userFullName;

  get getPassword => this.password;

  set setPassword(var password) => this.password = password;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getUsePhoneNumber => this.usePhoneNumber;

  set setUsePhoneNumber(usePhoneNumber) => this.usePhoneNumber = usePhoneNumber;

  get getEmergencyContacts => this.emergencyContacts;

  set setEmergencyContacts(emergencyContacts) =>
      this.emergencyContacts = emergencyContacts; // unordered collection

  //----------- UI -----------
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
