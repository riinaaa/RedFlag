import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/EmergencyContacts.dart';
import 'package:redflag/registration_pages/login_screen.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  // To Retrive the user info
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();
  int? ecNum;
  late String ecemail;

  @override
  void initState() {
    super.initState();

// -------------- to retrive the length of emergency contact based on the UID.--------------
    FirebaseFirestore.instance
        .collection('emergencyContacts')
        .where('user', isEqualTo: user!.uid)
        .get()
        .then((value) {
      setState(() {
        ecNum = value.docs.length;
      });
    });

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

// ------------------------------ The profile page UI ------------------------------
  @override
  Widget build(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true)
            .pop(false); // dismisses only the dialog and returns false
      },
    );
    Widget deleteButton = ElevatedButton(
        key: Key('PopupDeleteButton_profilePage'),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 255, 82, 82), // background
          onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
        ),
        onPressed: () async {
          deleteEmergencyContact(ecemail);
          Navigator.of(context, rootNavigator: true)
              .pop(true); // dismisses only the dialog and returns true
        },
        child: Text(
          "Delete",
          textAlign: TextAlign.center,
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Wait", textAlign: TextAlign.center),
      content:
          Text("Are you sure that you want to delete this emergency contact?"),
      actions: [
        deleteButton,
        cancelButton,
      ],
    );

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

// --------------------------------- The Body ----------------------------------
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

//------------------------------------ Dispaly the number of Emergency Contacts for the user ----------------------------------------

                    Container(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 22, bottom: 22),
                      // margin: EdgeInsets.only(left: 100),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        // boxShadow: shadowList,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(170, 188, 188, 188)
                                .withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Text('$ecNum',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6666FF))),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Text('Emergency \nContacts.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),

                    SizedBox(
                      height: 40,
                    ),

//------------------------------------ Current Emergency Contacts List ----------------------------------------

                    // Header
                    Container(
                      padding: EdgeInsets.only(left: 35),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Current Emergency Contacts ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF4E4EF7),
                                fontWeight: FontWeight.bold)),
                      ),
                    ),

                    // View all emergency contacts in a listView
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 300.0,
                            // --------------- Retriving Emergency contacts ---------------
                            //StreamBuilder<QuerySnapshot> => we used it to retrive it as Listview
                            // and to be apply to retrive multiple documents from the Firestore
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('emergencyContacts')
                                  .where('user', isEqualTo: user!.uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text("Loading");
                                }
                                return ListView(
                                  key: Key(
                                      'currentEmergencyContactsList_profilePage'),
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    // -------------- The UI of the Listview --------------

                                    return Container(
                                      margin: EdgeInsets.only(
                                          top: 5, left: 30, right: 30),
                                      // padding: EdgeInsets.only(top: 20, bottom: 20),
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
                                        title: Text(data['eFullName'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 236, 236, 238))),
                                        subtitle: Text(data['ecEmail'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 236, 236, 238))),

                                        // -------------- Delete Button --------------
                                        // deleteEmergencyContact(String email) => will delete the EC from Forestore
                                        trailing: IconButton(
                                          key: Key('deleteButton'),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              ecemail = data['ecEmail'];
                                            });
                                            // show the dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                          },
                                        ),
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

  //-------------------------- the logout function ----------------------
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//---------------------------delete emergency contact-------------------
// deleteEmergencyContact(String email) => will delete the EC from Forestore
  Future<void> deleteEmergencyContact(String email) async {
    var collection = FirebaseFirestore.instance.collection('emergencyContacts');
    var snapshot = await collection
        .where('ecEmail', isEqualTo: email)
        .where('user', isEqualTo: user!.uid)
        .get();
    await snapshot.docs.first.reference.delete();

    //3) display message to user
    // // Message
    final snackBar = SnackBar(
      content: Text("Emergency contact deleted successfully."),
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
