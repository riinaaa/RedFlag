import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:redflag/EmergencyContacts.dart';
import '/nav_pages_UI/nav.dart';
import 'package:redflag/Users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

var phoneNumberFull;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //Firebase Auth
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;
  //steper steps
  int currentStep = 0;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  final confirmPinEditingController = new TextEditingController();
  final keywordEditingController = new TextEditingController();
  final confirmKeywordEditingController = new TextEditingController();
  final emergencyContactNameEditingController = new TextEditingController();
  final emergencyContactNumberEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Last Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
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
          emailEditingController.text = value!;
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

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //PIN field
    final pinField = TextFormField(
        maxLength: 4,
        maxLengthEnforced: true,
        autofocus: false,
        controller: confirmPinEditingController,
        validator: (value) {
          RegExp regex = new RegExp(r'^[0-9]{4}$');
          if (value!.isEmpty) {
            return ("PIN is required");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid PIN(Numbers Only)");
          }
        },
        onSaved: (value) {
          confirmPinEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "PIN (required to use in activation)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //keyword field
    final keywordField = TextFormField(
        autofocus: false,
        controller: keywordEditingController,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("keyword is required to register");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid keyword(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          keywordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Keyword",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm keyword field
    final confirmKeywordField = TextFormField(
        autofocus: false,
        controller: confirmKeywordEditingController,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Keywords don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmKeywordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Keyword",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //emergency contact name field
    final emergencyContactNameField = TextFormField(
        autofocus: false,
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
          hintText: "Emergency Contact Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //phone number field
    final emergencyContactNumberField = IntlPhoneField(
      controller: emergencyContactNumberEditingController,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        border: OutlineInputBorder(
          // contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      initialCountryCode: 'SA',
      onSaved: (phone) {
        emergencyContactNumberEditingController.text = phone!.completeNumber;
      },
      textInputAction: TextInputAction.done,
    );

    //signup button
    final signUpButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 108, 82, 255), // background
          onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
        ),
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
        ));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Color.fromARGB(255, 108, 82, 255)),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
                height: 150,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.contain,
                )),
            SizedBox(height: 45),
            Text(
              'Registeration',
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            ),
            Stepper(
                steps: [
                  //STEP INFO
                  Step(
                    title: new Text('Personal Info'),
                    content: Form(
                      key: formKeys[0],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 1),
                          firstNameField,
                          SizedBox(height: 20),
                          secondNameField,
                          SizedBox(height: 20),
                          emailField,
                          SizedBox(height: 20),
                          passwordField,
                          SizedBox(height: 20),
                          confirmPasswordField,
                          SizedBox(height: 20),
                          pinField,
                          SizedBox(height: 20),
                          //
                        ],
                      ),
                    ),
                    isActive: currentStep >= 1,
                    state: currentStep == 1
                        ? StepState.editing
                        : currentStep < 1
                            ? StepState.disabled
                            : StepState.complete,
                  ),

                  //STEP KEYWORD
                  Step(
                    title: new Text('Keyword'),
                    content: Form(
                      key: formKeys[1],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 1),
                          keywordField,
                          SizedBox(height: 20),
                          confirmKeywordField,

                          //
                        ],
                      ),
                    ),
                    isActive: currentStep >= 1,
                    state: currentStep == 1
                        ? StepState.editing
                        : currentStep < 1
                            ? StepState.disabled
                            : StepState.complete,
                  ),

                  Step(
                    title: new Text("Emergency Contact"),
                    content: Form(
                      key: formKeys[2],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(),
                          Text(
                            'PS: A confirmation message will be sent to give them a heads up',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          SizedBox(height: 15),
                          emergencyContactNameField,

                          SizedBox(height: 20),
                          emergencyContactNumberField,
                          // signUpButton,
                          // SizedBox(height: 15),
                          //
                        ],
                      ),
                    ),
                    isActive: currentStep >= 1,
                    state: currentStep == 1
                        ? StepState.editing
                        : currentStep < 1
                            ? StepState.disabled
                            : StepState.complete,
                  ),
                ],
                type: StepperType.vertical,
                physics: ScrollPhysics(),
                currentStep: currentStep,
                onStepTapped: (int step) {
                  setState(() {
                    currentStep = step;
                  });
                },
                onStepCancel: () {
                  currentStep > 0 ? setState(() => currentStep -= 1) : null;
                },
                onStepContinue: () {
                  if (formKeys[currentStep].currentState!.validate()) {
                    currentStep < 2 ? setState(() => currentStep += 1) : null;
                  }
                },

                //-----CONTROL THE STEPPER BUTTONS------
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(children: [
                      if (currentStep < 2)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                Color.fromARGB(255, 108, 82, 255), // background
                            onPrimary: Color.fromARGB(
                                255, 255, 255, 255), // foreground
                          ),
                          onPressed: controls.onStepContinue,
                          child: const Text('Next'),
                        ),
                      if (currentStep == 2) signUpButton,
                      if (currentStep != 0)
                        TextButton(
                          onPressed: controls.onStepCancel,
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: Color.fromARGB(255, 108, 82, 255),
                            ),
                          ),
                        ),
                    ]),
                  );
                }),
          ]),
        ));
  }

  void signUp(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? currentUser = _auth.currentUser;

    Users userModel = Users();
    EmergencyContacts emergencyContactModel = EmergencyContacts();

    // writing all the values
    //user
    userModel.email = currentUser!.email;
    userModel.uid = currentUser.uid;
    userModel.userFirstName = firstNameEditingController.text;
    userModel.userLastName = secondNameEditingController.text;
    userModel.keyword = keywordEditingController.text;
    userModel.pin = confirmPinEditingController.text;

    //emergency contact
    emergencyContactModel.eFullName =
        emergencyContactNameEditingController.text;
    emergencyContactModel.phoneNumber =
        emergencyContactNumberEditingController.text;

    //add to the emergencycontact array in the user object
    userModel.emergencyContacts.add(emergencyContactModel);

//firestore add user information
    await firebaseFirestore
        .collection("users")
        .doc(currentUser.uid)
        .set(userModel.toMap());

//firestore add emergency contact information
    await firebaseFirestore
        .collection("emergencyContatcs")
        .doc()
        .set(emergencyContactModel.toMap(currentUser.uid));

    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => NavScreen()), (route) => false);
  }
}
