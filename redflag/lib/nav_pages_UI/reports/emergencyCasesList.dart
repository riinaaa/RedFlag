import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                                  return Text("Loading");
                                }
                                // -------------- The UI of the Listview --------------

                                return ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return Container(
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
                                          Icons.insert_drive_file_rounded,
                                          color: Color.fromARGB(
                                              255, 240, 240, 240),
                                        ),
                                        trailing: IconButton(
                                          key: Key(
                                              'caseNumberButton_emergencyCasesPage'),
                                          icon: Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                          ),
                                          onPressed: () {
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
}

// the logout function
Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}
