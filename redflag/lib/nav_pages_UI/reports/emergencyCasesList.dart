import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redflag/Emergency.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/nav_pages_UI/reportsPage.dart';
import 'package:redflag/registration_pages/login_screen.dart';

class cemrgencyCases extends StatefulWidget {
  const cemrgencyCases({Key? key}) : super(key: key);

  @override
  State<cemrgencyCases> createState() => _cemrgencyCasesState();
}

class _cemrgencyCasesState extends State<cemrgencyCases> {
  // Firebase Auth
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();
  Emergency mail = new Emergency();

  late String caseNumber;
  late String audioRecording;
  late String userLocation;
  late String endTime;

  void initState() {
    super.initState();
    // -------------- to retrive the name and email of the user.--------------
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
    // // set up the buttons
    // Widget cancelButton = TextButton(
    //   child: Text("Cancel"),
    //   onPressed: () {
    //     Navigator.of(context, rootNavigator: true)
    //         .pop(false); // dismisses only the dialog and returns false
    //   },
    // );
    // Widget deleteButton = ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       primary: Color.fromARGB(255, 255, 82, 82), // background
    //       onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
    //     ),
    //     onPressed: () async {
    //       deleteandSendEmergencyCase(
    //           caseNumber, audioRecording, userLocation, endTime);
    //       Navigator.of(context, rootNavigator: true)
    //           .pop(true); // dismisses only the dialog and returns true
    //     },
    //     child: Text(
    //       "Delete",
    //       textAlign: TextAlign.center,
    //     ));

    // // set up the AlertDialog
    // AlertDialog alert = AlertDialog(
    //   title: Text("Wait", textAlign: TextAlign.center),
    //   content: Text(
    //       "Are you sure that you want to delete $caseNumber emergency case?"),
    //   actions: [
    //     deleteButton,
    //     cancelButton,
    //   ],
    // );

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
                      backgroundImage: NetworkImage(
                          "https://hostpapasupport.com/knowledgebase/wp-content/uploads/2018/04/1-13.png"),
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
                padding: EdgeInsets.only(top: 80, left: 300),
                child: TextButton(
                  key: Key('logoutButton'),
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

//------------------------------------ The Body----------------------------------------

              SizedBox(
                height: 50,
              ),

              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 210,
                    ),

                    SizedBox(
                      height: 100,
                    ),

//------------------------------------ Current Emergency Cases List ----------------------------------------
                    // The header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 35),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Repository ',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Color(0xFF4E4EF7),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    // View all emergency Cases in a listView
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 300.0,
                            // --------------- Retriving Emergency Cases ---------------
                            //StreamBuilder<QuerySnapshot> => we used it to retrive it as Listview
                            // and to be apply to retrive multiple documents from the Firestore
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('emergencyCase')
                                  .where('user', isEqualTo: user!.uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                // -------------- The UI of the Listview --------------

                                return ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    // setState(() {
                                    //   caseNumber = data['caseNumber'];
                                    //   audioRecording = data['audioRecording'];
                                    //   userLocation = data['userLocation'];
                                    //   endTime = data['endTime'];
                                    // });
                                    return Container(
                                      key: Key('openReport_emergencyCasesPage'),
                                      margin: EdgeInsets.only(
                                          top: 5, left: 30, right: 30),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF6666FF),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                    170, 201, 198, 198)
                                                .withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text('Case Number ',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 236, 236, 238))),
                                        subtitle: Text(data['caseNumber'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 236, 236, 238))),
                                        leading: Icon(
                                          Icons.remove_red_eye,
                                          color: Color.fromARGB(
                                              255, 240, 240, 240),
                                        ),
                                        trailing: IconButton(
                                          key: Key(
                                              'caseNumberButton_emergencyCasesPage'),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              caseNumber = data['caseNumber'];
                                            });
                                            // set up the buttons
                                            final cancelButton = TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop(
                                                        false); // dismisses only the dialog and returns false
                                              },
                                            );
                                            final deleteButton = ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255,
                                                      255,
                                                      82,
                                                      82), // background
                                                  onPrimary: Color.fromARGB(
                                                      255,
                                                      255,
                                                      255,
                                                      255), // foreground
                                                ),
                                                onPressed: () async {
                                                  deleteandSendEmergencyCase(
                                                      data['caseNumber'],
                                                      data['audioRecording'],
                                                      data['userLocation'],
                                                      data['endTime']);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop(
                                                          true); // dismisses only the dialog and returns true
                                                },
                                                child: Text(
                                                  "Delete",
                                                  textAlign: TextAlign.center,
                                                ));

                                            // set up the AlertDialog
                                            AlertDialog alert = AlertDialog(
                                              title: Text("Wait",
                                                  textAlign: TextAlign.center),
                                              content: Text(
                                                  "Are you sure that you want to delete data $caseNumber emergency case?"),
                                              actions: [
                                                deleteButton,
                                                cancelButton,
                                              ],
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    reportsPage(
                                                      caseNumb:
                                                          data['caseNumber'],
                                                    )),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  //---------------------------delete and send emergency case-------------------
// deleteandSendEmergencyCase(String caseNunmber, String audioLink,
// String locLink, String incidentDate)  => will:
//1) send a the user the detailes
//2) then delete the emergency case
  Future<void> deleteandSendEmergencyCase(String caseNunmber, String audioLink,
      String locLink, String incidentDate) async {
    //1) Send detailes via email
    String subject = 'Case $caseNunmber has been deleted ::✖️:: Redflag Team';
    String userFirstName = loggedInUser.getUserFirstName;
    String userLastName = loggedInUser.getUserLastName;
    final recipients = <dynamic>[loggedInUser.getEmail];
    String msg =
        '<h1>Hello, $userFirstName $userLastName </h1>\n<p><strong>Case $caseNunmber has been deleted </strong>\n</p><p>Here a copy of it content</p>\n<p>The incident date: $incidentDate </p>\n<p>The audio recurding: $audioLink</p>\n <p>The location link: $locLink </p><br>\n<br>\n<br>\n<br>\n<br>\n<hr>\n<p style="color:#6c63ff; font-family:Arial, Helvetica, sans-serif; font-size:18px;";><strong>Atheer Alghamdi</strong></p>\<p style="font-family:Arial, Helvetica, sans-serif; font-size:15px;"><strong>Redflag Developer | IT Department </strong></p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Email: redflagapp.8@gmail.com</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Adress: King Abdulaziz University | FCIT</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Websit: <a href="https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php">https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php</a></p>\n<br>\n<br>';
    mail.sendMail(recipients, subject, msg);

    // 2) Delete
    var collection = FirebaseFirestore.instance.collection('emergencyCase');
    var snapshot = await collection
        .where('caseNumber', isEqualTo: caseNunmber)
        .where('user', isEqualTo: user!.uid)
        .get();
    await snapshot.docs.first.reference.delete();

    //3) display message to user
    // // Message
    final snackBar = SnackBar(
      content: Text("The $caseNunmber Case is deleted successfully."),
      backgroundColor: Colors.teal,
      // Inner padding for SnackBar content.
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        left: 30,
      ),
      margin: EdgeInsets.only(left: 40, right: 40),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

// the logout function
Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}
