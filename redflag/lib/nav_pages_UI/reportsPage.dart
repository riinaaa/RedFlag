import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:redflag/Emergency.dart';
import 'package:redflag/EmergencyContacts.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/nav_pages_UI/reports/emergencyCasesList.dart';
import 'package:redflag/registration_pages/login_screen.dart';

class reportsPage extends StatefulWidget {
  final String caseNumb;
  const reportsPage({Key? key, required this.caseNumb}) : super(key: key);

  @override
  State<reportsPage> createState() => _reportsPageState();
}

class _reportsPageState extends State<reportsPage> {
  User? user = FirebaseAuth.instance.currentUser;

  Users loggedInUser = Users();
  Emergency caseInfo = Emergency();

  // String msg =
  //     '<h1>Hello, $ecName </h1>\n<p><strong>$userFirstName $userLastName </strong>has added you as an emergency contact.\n</p><p>If there is an emergency, the Redflag team will send you the location of <strong>$userFirstName</strong>.</p>\n<br>\<br>\n<br>\n<br>\n<br>\n<hr>\n<p style="color:#6c63ff; font-family:Arial, Helvetica, sans-serif; font-size:18px;";><strong>Atheer Alghamdi</strong></p>\<p style="font-family:Arial, Helvetica, sans-serif; font-size:15px;"><strong>Redflag Developer | IT Department </strong></p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Email: redflagapp.8@gmail.com</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Adress: King Abdulaziz University | FCIT</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Websit: <a href="https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php">https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php</a></p>\n<br>\n<br>';
  // EmergencyContacts loggedInEmergencyContacts = EmergencyContacts();

  @override
  void initState() {
    super.initState();

    // FirebaseFirestore.instance
    //     .collection("emergencyCase")
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   this.caseInfo = Emergency.fromMap(value.data());
    //   setState(() {});
    // });

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

              //------------------------------------Return to the case numbers list------------------------------------

              Container(
                margin: EdgeInsets.only(top: 80, left: 15),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const cemrgencyCases()),
                    );
                  },
                ),
              ),
              //------------------------------------Logout------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 300),
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

              //------------------------------------Test------------------------------------
              // Container(
              //   margin: EdgeInsets.only(top: 300, left: 15),
              //   child: ElevatedButton(
              //       onPressed: () {
              //         print(caseInfo.caseNumber);
              //         print(loggedInUser.userFirstName);
              //       },
              //       child: Text('print case numer')),
              // ),

              // StreamBuilder<QuerySnapshot>(
              //     stream: FirebaseFirestore.instance
              //         .collection('emergencyCase')
              //         .where('user', isEqualTo: user!.uid)
              //         .snapshots(),
              //     builder: (BuildContext context,
              //         AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return new Text("Loading");
              //       }

              //       var userDocument = snapshot.data;
              //       return Text(userDocument['caseNumber']);
              //     }),

              Container(
                margin: EdgeInsets.only(top: 170),
                // color: Colors.red,

// ----------------------------------------- Retrive the case details based on the case number -----------------------------------------

                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('emergencyCase')
                      .where('caseNumber', isEqualTo: widget.caseNumb)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

// ----------------------------------------- dispaly termination time -----------------------------------------
                        return Row(
                          children: [
                            Flexible(
                              child: Container(
                                // margin: EdgeInsets.only(left: 25, right: 260),
                                // padding: EdgeInsets.only(top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(170, 226, 223, 223)
                                          .withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text('Case ID\n',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6666FF))),
                                  // leading: Icon(Icons.access_time_filled_sharp),
                                  subtitle: Text(data['caseNumber']),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                // margin: EdgeInsets.only(left: 25, right: 260),
                                // padding: EdgeInsets.only(top: 20, bottom: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(170, 226, 223, 223)
                                          .withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text('EndTime\n',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6666FF))),
                                  // leading: Icon(Icons.access_time_filled_sharp),
                                  subtitle: Text(data['endTime']),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              //--------------------------------------------------

              // Column(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.only(
              //           left: 30, right: 30, top: 22, bottom: 22),
              //       margin: EdgeInsets.only(top: 220, left: 90),
              //       decoration: BoxDecoration(
              //         color: Color.fromRGBO(255, 255, 255, 1),
              //         // boxShadow: shadowList,
              //         borderRadius: BorderRadius.circular(10),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Color.fromARGB(170, 188, 188, 188)
              //                 .withOpacity(0.5),
              //             spreadRadius: 5,
              //             blurRadius: 7,
              //             offset: Offset(0, 0), // changes position of shadow
              //           ),
              //         ],
              //       ),
              //       child: Text('${caseInfo.getCaseNumber}',
              //           style: TextStyle(
              //               fontSize: 30,
              //               fontWeight: FontWeight.bold,
              //               color: Color(0xFF6666FF))),
              //     ),
              //     SizedBox(
              //       height: 15,
              //     ),
              //     Text('Emergency \nContacts.',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //             fontSize: 12,
              //             color: Colors.black,
              //             fontWeight: FontWeight.w500)),
              //   ],
              // ),
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
