import 'package:flutter/material.dart';
import './EmergencyContacts.dart';

class EmergencyContacts extends StatelessWidget {
  //const EmergencyContacts({ Key? key }) : super(key: key);

  String fullName = '';
  int phoneNumber = 0;

  EmergencyContacts(this.fullName, this.phoneNumber) {
    fullName = this.fullName;
    phoneNumber = this.phoneNumber;
  }

  String get getFullName => this.fullName;

  set setFullName(String fullName) => this.fullName = fullName;

  get getPhoneNumber => this.phoneNumber;

  set setPhoneNumber(phoneNumber) => this.phoneNumber = phoneNumber;

  //----------- UI -----------

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
