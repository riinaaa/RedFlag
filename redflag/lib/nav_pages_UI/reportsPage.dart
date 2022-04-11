import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:redflag/Emergency.dart';
import 'package:redflag/EmergencyContacts.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/registration_pages/login_screen.dart';

class reportsPage extends StatefulWidget {
  const reportsPage({Key? key}) : super(key: key);

  @override
  State<reportsPage> createState() => _reportsPageState();
}

class _reportsPageState extends State<reportsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();
  EmergencyContacts emergencyContactModel = EmergencyContacts();

  Emergency mail = new Emergency();
  String subject =
      'You have been added as an Emergency Contact :: Redflag Team';
  String ecName = 'Atheer';
  String userFirstName = 'Shimma';
  String userLastName = 'Alghamdi';
  List<dynamic> recipients = <dynamic>[];

  // String msg =
  //     '<h1>Hello, $ecName </h1>\n<p><strong>$userFirstName $userLastName </strong>has added you as an emergency contact.\n</p><p>If there is an emergency, the Redflag team will send you the location of <strong>$userFirstName</strong>.</p>\n<br>\<br>\n<br>\n<br>\n<br>\n<hr>\n<p style="color:#6c63ff; font-family:Arial, Helvetica, sans-serif; font-size:18px;";><strong>Atheer Alghamdi</strong></p>\<p style="font-family:Arial, Helvetica, sans-serif; font-size:15px;"><strong>Redflag Developer | IT Department </strong></p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Email: redflagapp.8@gmail.com</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Adress: King Abdulaziz University | FCIT</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Websit: <a href="https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php">https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php</a></p>\n<br>\n<br>';
  // EmergencyContacts loggedInEmergencyContacts = EmergencyContacts();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('emergencyContacts')
        .where('user', isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //emergency contact
        emergencyContactModel.eFullName = doc['eFullName'];
        emergencyContactModel.ecEmail = doc['ecEmail'];
        // print(emergencyContactModel.ecEmail);

        // for (var i = 0; i < loggedInUser.emergencyContacts.length; i++) {
        //   recipients = [emergencyContactModel.ecEmail];
        // }
        // print('-------------------------');

        // print('rec --> $recipients');
        loggedInUser.emergencyContacts.add(emergencyContactModel);
        // List<dynamic> temp = <dynamic>[];
        int count = 0;
        for (var i = 0; i < 1; i++) {
          print('i--> $i');
          print(loggedInUser.emergencyContacts[i].eFullName);
          print(loggedInUser.emergencyContacts[i].ecEmail);
          print('-------------------------');

          recipients.add(loggedInUser.emergencyContacts[i].ecEmail);
        }
        // for (var i = 0; i < loggedInUser.emergencyContacts.length; i++) {
        //   // print(ecNum);
        //   print(loggedInUser.emergencyContacts[i].eFullName);
        //   print(loggedInUser.emergencyContacts[i].ecEmail);
        //   print('-------------------------');

        //   recipients = [loggedInUser.emergencyContacts[i].ecEmail];
        // }

        // print(recipients.length);
      });
      print(loggedInUser.emergencyContacts.length);
      // recipients = [loggedInUser.getEmergencyContacts];

      print(recipients);
      print(recipients.length);
    });

    // FirebaseFirestore.instance
    //     .collection("emergencyContacts")
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   this.loggedInEmergencyContacts = EmergencyContacts.fromMap(value.data());
    //   setState(() {});
    // });

    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = Users.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Stack(
            children: [
//------------------------------------ App Bar ----------------------------------------

              Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(30)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 122, 122, 243),
                      Color(0xFF4E4EF7)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              ),

//------------------------------------ User info ----------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 120),
                child: Column(
                  children: [
                    //child 1 --> avatar
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    //child 2 --> for space between the avatar and user data
                    SizedBox(
                      height: 20,
                    ),
//----------------//child 3 --> user data
                    Column(
                      children: [
                        Text(
                          '${loggedInUser.getUserFirstName} ${loggedInUser.getUserLastName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          '${loggedInUser.getEmail}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //------------------------------------Logout------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 15),
                child: TextButton(
                  onPressed: () {
                    logout(context);
                  },
                  child: Text('Logout',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 245, 245, 245),
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 400, left: 15),
                child: ElevatedButton(
                    onPressed: () {
                      // for (var i = 0;
                      //     i < loggedInUser.emergencyContacts.length;
                      //     i++) {
                      //   // print(ecNum);
                      //   print(loggedInUser.emergencyContacts[i].getEcEmail);
                      //   // print(loggedInUser.emergencyContacts[i].eFullName);
                      //   // print(loggedInUser.emergencyContacts[i].ecEmail);
                      //   print('-------------------------');
                      //   recipients = [
                      //     loggedInUser.emergencyContacts[i].ecEmail
                      //   ];
                      // }
                      // print(recipients);

                      mail.sendMail(recipients, subject,
                          '<h1>Hello, $ecName </h1>\n<p><strong>$userFirstName $userLastName </strong>has added you as an emergency contact.\n</p><p>If there is an emergency, the Redflag team will send you the location of <strong>$userFirstName</strong>.</p>\n<br>\<br>\n<br>\n<br>\n<br>\n<hr>\n<p style="color:#6c63ff; font-family:Arial, Helvetica, sans-serif; font-size:18px;";><strong>Atheer Alghamdi</strong></p>\<p style="font-family:Arial, Helvetica, sans-serif; font-size:15px;"><strong>Redflag Developer | IT Department </strong></p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Email: redflagapp.8@gmail.com</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Adress: King Abdulaziz University | FCIT</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Websit: <a href="https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php">https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php</a></p>\n<br>\n<br>');
                      // print(loggedInUser.getEmergencyContacts);
                      // print('After clicking the button');
                      // print(recipients);

                      // for (var i = 0;
                      //     i < loggedInUser.emergencyContacts.length;
                      //     i++) {
                      //   // print(ecNum);
                      //   print(loggedInUser.emergencyContacts[i].eFullName);
                      //   print(loggedInUser.emergencyContacts[i].ecEmail);
                      // }
                    },
                    child: Text('Send Email')),
              )
            ],
          )),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}
