import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redflag/Emergency.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/registration_pages/login_screen.dart';
import 'package:redflag/EmergencyContacts.dart';

class add extends StatefulWidget {
  const add({Key? key}) : super(key: key);

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  // Controllers for the TextFileds to get the user input
  final emergencyContactNameEditingController = new TextEditingController();
  final emergencyContactEmailEditingController = new TextEditingController();
  String? name;
  String? email;
  final _formKey = GlobalKey<FormState>(); //for the validate

  // Firebase Auth
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();

  @override
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

  // --------------------- In submitData() the data will be sent to the firestore. ---------------------

  submitData() async {
    if (_formKey.currentState!.validate()) {
      EmergencyContacts emergencyContactModel = EmergencyContacts();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      //emergency contact
      emergencyContactModel.eFullName =
          emergencyContactNameEditingController.text;
      emergencyContactModel.ecEmail =
          emergencyContactEmailEditingController.text;

      //--------------------- add to the emergencycontact array in the user object ---------------------
      loggedInUser.emergencyContacts.add(emergencyContactModel);

      name = emergencyContactNameEditingController.text;
      email = emergencyContactEmailEditingController.text;

      if (name != "" || email != "") {
        //firestore add emergency contact information
        await firebaseFirestore
            .collection("emergencyContacts")
            .doc()
            .set(emergencyContactModel.toMap(user!.uid));

        //3) display message to user
        // // Message
        final snackBar = SnackBar(
          content: Text("Emergency contact added successfully."),
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

      //****************************
      // ---------------------Send an email to the emergency contact---------------------
      Emergency mail = new Emergency();
      String subject =
          'You have been added as an Emergency Contact ::🟡:: Redflag Team';
      String ecName = emergencyContactNameEditingController.text;
      String userFirstName = loggedInUser.getUserFirstName;
      String userLastName = loggedInUser.getUserLastName;
      // String recipients = emergencyContactEmailEditingController.text;
      final recipients = <dynamic>[email];

      String msg =
          '<h1>Hello, $ecName </h1>\n<p><strong>$userFirstName $userLastName </strong>has added you as an emergency contact.\n</p><p>If there is an emergency, the Redflag team will send you the location of <strong>$userFirstName</strong>.</p>\n<br>\<br>\n<br>\n<br>\n<br>\n<hr>\n<p style="color:#6c63ff; font-family:Arial, Helvetica, sans-serif; font-size:18px;";><strong>Atheer Alghamdi</strong></p>\<p style="font-family:Arial, Helvetica, sans-serif; font-size:15px;"><strong>Redflag Developer | IT Department </strong></p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Email: redflagapp.8@gmail.com</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Adress: King Abdulaziz University | FCIT</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Websit: <a href="https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php">https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php</a></p>\n<br>\n<br>';
      mail.sendMail(recipients, subject, msg);

      //----------------------------------------
      clearData();
    }
  }

  // ---------------------In clearData() the textfields will be cleared.---------------------

  clearData() {
    emergencyContactNameEditingController.clear();
    emergencyContactEmailEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    //--------------------- emergency contact name field ---------------------
    final emergencyContactNameField = TextFormField(
        key: Key('nameField_addPage'),
        autofocus: true,
        controller: emergencyContactNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Emergency Contact Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          emergencyContactNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //---------------------emergency contact email field---------------------
    final emergencyContactEmailField = TextFormField(
        key: Key('emailField_addPage'),
        autofocus: false,
        controller: emergencyContactEmailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emergencyContactEmailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    // --------------------- Add page UI ---------------------
    return Container(
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(children: [
        //------------------------------------ App Bar ----------------------------------------

        Container(
          height: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
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

//------------------------------------ The body ----------------------------------------

        Column(
          children: [
            SizedBox(
              height: 300,
            ),
            // ------------------------- The header -------------------------
            Align(
              // to force it to stay in the left then will control it with th margin, if i remove it, it will go the center and the margin can't move it
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 35),
                child: Text('Add Emergency \nContacts ',
                    style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFF4E4EF7),
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // ------------------------- Text Fields -------------------------
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    emergencyContactNameField,
                    SizedBox(height: 25),
                    emergencyContactEmailField,
                    SizedBox(height: 40),

//-----------------------------------  Buttons ---------------------------------------

                    Container(
                      alignment: FractionalOffset.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // space between the buttons
                        children: [
                          //------------------------- Add Button -------------------------

                          ElevatedButton(
                            key: Key('addButton_addPage'),
                            onPressed: submitData,
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF4E4EF7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 15, bottom: 15),
                              child: Text('Add',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255))),
                            ),
                          ),

                          //------------------------- Clear Button -------------------------
                          ElevatedButton(
                            onPressed: clearData,
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 167, 167, 167),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 15, bottom: 15),
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]),
    ));
  }

//-----------------------------------  Logout function ---------------------------------------
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
