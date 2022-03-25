import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:redflag/main.dart';
import 'package:redflag/nav_pages_UI/nav.dart';

import '../nav_pages_UI/termination/termenationPage.dart';

class Verificatoin extends StatefulWidget {
  final String status;
  const Verificatoin({Key? key, required this.status}) : super(key: key);

  @override
  _VerificatoinState createState() => _VerificatoinState();
}

class _VerificatoinState extends State<Verificatoin> {
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';

  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  // here we can check if the 4 digit equal the one in firebase
  verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   setState(() {
    //     _currentIndex++;

    //     if (_currentIndex == 3) _currentIndex = 0;
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////////////
    //-------------------------------Timer----------------------------
    /////////////////////////////////////////////////////////////////////

    print(widget.status);
    Timer(Duration(seconds: 3), () {
      if (widget.status == 'emergency') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => terminationPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavScreen()),
        );
      }
    });
    /////////////////////////////////////////////////////////////////////

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /////////////////////////////////////////////////////////////////////
                  //-------------------------------PIC----------------------------
                  /////////////////////////////////////////////////////////////////////
                  Container(
                      height: 250,
                      child: FadeInDown(
                        duration: Duration(milliseconds: 500),
                        child: Image.network(
                          'https://ouch-cdn2.icons8.com/ElwUPINwMmnzk4s2_9O31AWJhH-eRHnP9z8rHUSS5JQ/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNzkw/Lzg2NDVlNDllLTcx/ZDItNDM1NC04YjM5/LWI0MjZkZWI4M2Zk/MS5zdmc.png',
                        ),
                      )),

                  // space between the pic and header
                  SizedBox(
                    height: 30,
                  ),

                  /////////////////////////////////////////////////////////////////////
                  //-------------------------------Header----------------------------
                  /////////////////////////////////////////////////////////////////////
                  FadeInDown(
                      delay: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        "PIN Verification",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),

                  // space between the header and text
                  SizedBox(
                    height: 30,
                  ),

                  /////////////////////////////////////////////////////////////////////
                  //-----------------asking user to enter the PIN----------------------
                  /////////////////////////////////////////////////////////////////////
                  FadeInDown(
                    delay: Duration(milliseconds: 600),
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      "Please enter the 4 digit code \n you specified during registration to deactivate.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                          height: 1.5),
                    ),
                  ),

                  // space between the header and text
                  SizedBox(
                    height: 30,
                  ),

                  /////////////////////////////////////////////////////////////////////
                  //-----------------Verification Code Input--------------------------
                  /////////////////////////////////////////////////////////////////////
                  FadeInDown(
                    delay: Duration(milliseconds: 700),
                    duration: Duration(milliseconds: 500),
                    child: VerificationCode(
                      length: 4,
                      textStyle: TextStyle(fontSize: 20, color: Colors.black),
                      underlineColor: Color.fromARGB(255, 0, 0, 0),
                      keyboardType: TextInputType.number,
                      underlineUnfocusedColor: Color.fromARGB(255, 0, 0, 0),
                      onCompleted: (value) {
                        setState(() {
                          _code = value;
                          // _code --> contain the entered PIN,
                          // we will compare it with the one the user regestered.
                          // print(_code);
                        });
                      },
                      onEditing: (value) {},
                    ),
                  ),

                  /////////////////////////////////////////////////////////////////////
                  /////////////////////////////////////////////////////////////////////
                  // space between the input and the button

                  SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    height: 50,
                  ),

                  /////////////////////////////////////////////////////////////////////
                  //-----------------Verification Code Button--------------------------
                  /////////////////////////////////////////////////////////////////////
                  FadeInDown(
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 500),
                    child: MaterialButton(
                      elevation: 0,
                      onPressed: _code.length < 4
                          ? () => {}
                          : () {
                              verify();
                            },
                      color: Color.fromARGB(255, 102, 102, 255),
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: _isLoading
                          ? Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 3,
                                color: Colors.black,
                              ),
                            )
                          : _isVerified
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : Text(
                                  "Verify",
                                  style: TextStyle(color: Colors.white),
                                ),
                    ),
                  )

                  /////////////////////////////////////////////////////////////////////
                  /////////////////////////////////////////////////////////////////////
                ],
              )),
        ));
  }
}
