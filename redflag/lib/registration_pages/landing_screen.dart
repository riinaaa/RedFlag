import 'package:flutter/material.dart';
import 'package:redflag/registration_pages/registration_screen.dart';
import 'package:redflag/registration_pages/login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //SignUp Button
    final signUpPageButton = Material(
      key: Key('homeSignUpButton'),
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      color: Color.fromARGB(255, 108, 82, 255),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()));
          },
          child: Text(
            "Create New Account",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //LOGIN Button
    final loginPageButton = Material(
      key: Key('homeLoginButton'),
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          child: Text(
            "Log In",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 108, 82, 255),
                fontWeight: FontWeight.bold),
          )),
    );

////
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 45),
                  SizedBox(
                      height: 200,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      )),
                  SizedBox(height: 35),
                  Text(
                    "Let's Get Started",
                    style: TextStyle(
                        color: Color.fromARGB(255, 108, 82, 255), fontSize: 30),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Never a better time to start thinking about\n"
                    " yours and your loved ones safety",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 108, 82, 255), fontSize: 13),
                  ),
                  SizedBox(height: 100),
                  signUpPageButton,
                  SizedBox(height: 15),
                  loginPageButton,
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
