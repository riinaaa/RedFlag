import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:redflag/Emergency.dart';
import 'package:redflag/EmergencyContacts.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/locations/user_location.dart';
import 'package:redflag/nav_pages_UI/nav.dart';
import 'package:redflag/nav_pages_UI/termination/termenationPage.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:path_provider/path_provider.dart';

class Verificatoin extends StatefulWidget {
  final String status;
  const Verificatoin({Key? key, required this.status}) : super(key: key);

  @override
  _VerificatoinState createState() => _VerificatoinState();
}

class _VerificatoinState extends State<Verificatoin> {
  String _code = '';
  bool _pinLength = false;
  Timer? _timer;
  late FlutterSoundRecorder _myRecorder;
  final audioPlayer = AssetsAudioPlayer();
  late String filePath;
  late final emergencyId;
  static var startDate;
  late final endDate;

// UserLocation locLinl=new UserLocation();

// Retrive the registered PIN
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();
////////////////
  EmergencyContacts emergencyContactModel = EmergencyContacts();
  List<dynamic> recipients = <dynamic>[];
  String? userFirstName;
  String? userLastName;
  // String? msg;

  Emergency emergencyCase = new Emergency();
  String subject = 'There is an emergency ::🔴:: Redflag Team';
  double? lat;
  double? lng;
  String? downloadUrl;

  @override
  void initState() {
    super.initState();
    startIt(); // this only starts the session beforehand

    FirebaseFirestore.instance
        .collection('emergencyContacts')
        .where('user', isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //emergency contact
        emergencyContactModel.eFullName = doc['eFullName'];
        emergencyContactModel.ecEmail = doc['ecEmail'];

        loggedInUser.emergencyContacts.add(emergencyContactModel);
        for (var i = 0; i < 1; i++) {
          // print('i--> $i');
          // print(loggedInUser.emergencyContacts[i].eFullName);
          // print(loggedInUser.emergencyContacts[i].ecEmail);
          // print('-------------------------');

          recipients.add(loggedInUser.emergencyContacts[i].ecEmail);
        }
      });
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = Users.fromMap(value.data());
      setState(() {});
    });
  }

  // timer for the recording
  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), stopRecord);

  String pin = '';

  // here we can check if the 4 digit equal the one in firebase
  verify() {
    // setState(() {
    //   _isLoading = true;
    // });

    if (_code.length < 4) {
      _pinLength = false;

      print("> 4");

      //----------------- Display an error message when user enter less than 4 digits------------------
      final snackBar = SnackBar(
        content: const Text('Plese enter 4 digits. '),
        backgroundColor: Color.fromARGB(255, 255, 117, 107),
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
    } else {
      // String pin = '${loggedInUser.getPin}';

      if (_code == '${loggedInUser.getPin}') {
        _pinLength = true;

        print('= 4');

        if (widget.status == 'safe') {
          //generate emergencycase ID
          emergencyId = "RF" + DateTime.now().millisecondsSinceEpoch.toString();

          //end date
          DateTime nowEnd = DateTime.now();
          endDate =
              "${nowEnd.year.toString()}-${nowEnd.month.toString().padLeft(2, '0')}-${nowEnd.day.toString().padLeft(2, '0')} ${nowEnd.hour.toString().padLeft(2, '0')}-${nowEnd.minute.toString().padLeft(2, '0')}";

          // set the endTime in the emergencyCae object
          emergencyCase.endTime = endDate;

          //UPLOAD AUDIO TO FIREBASE STORAGE
          uploadRecording(emergencyId);
        }

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavScreen()),
        );
        // _timer!.cancel();
        // print('timer canceled');
      } else {
        //----------------- Display an error message when user enter pin dont equal registered pin------------------
        final snackBar = SnackBar(
          content: const Text('Incorrect, please re-enter.'),
          backgroundColor: Color.fromARGB(255, 255, 117, 107),
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
  }

  void startIt() async {
    //setting temp recording in the files
    // getTemporaryDirectory help to get a temp directory based on the device running the app
    Directory tempDir = await getTemporaryDirectory();
    filePath = tempDir.path + '/temps.aac';
    //new Flutter Sound Recorder.
    _myRecorder = FlutterSoundRecorder();

// *open* the Audio Session before using it.
    await _myRecorder.openAudioSession(
        focus: AudioFocus.requestFocusAndDuckOthers,
        category: SessionCategory.record,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);

    /// Sets the frequency at which duration updates are sent to
    /// duration listeners.
    await _myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting();
  }

  Future<void> record() async {
    _myRecorder.openAudioSession();
    await _myRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.defaultCodec,
    );

    /// The subscription provides events to the listener,
    /// and holds the callbacks used to handle the events.
    /// The subscription can also be used to unsubscribe from the events,
    /// or to temporarily pause the events from the stream.
    StreamSubscription _recorderSubscription =
        _myRecorder.onProgress!.listen((e) {});
    _recorderSubscription.cancel();
  }

  Future<String?> stopRecord() async {
    _myRecorder.closeAudioSession();
    return await _myRecorder.stopRecorder();
  }

  //upload recording file to firebase storage to get the download url to add it to firestore
  Future uploadRecording(String ecaseID) async {
    File recording = File(filePath);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    //upload to firebase storage
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${user!.uid}/recordings")
        .child("recording_$ecaseID");

    await ref.putFile(recording);
    downloadUrl = await ref.getDownloadURL();
    print("recording url...");
    print(downloadUrl);

    emergencyCase.caseNumber = ecaseID;
    emergencyCase.audioRecording = downloadUrl;

    //upload to firebase firestore
    await firebaseFirestore
        .collection("emergencyCase")
        .doc()
        .set(emergencyCase.toMap(user!.uid));
  }

  void startTimer() {
    // print('lat from Timer --> $lat');
    // print('lng from Timer--> $lng');

    Future<dynamic> loc = UserLocation().getLocation().then((value) {
      // print('loc ----> $value');
      //set the emergency location in the emergencycase object
      emergencyCase.userLocation = value;
      String msg2 =
          '<div style=" height: 300px; width: 600px; border-style: ridge; border-radius: 15px; text-align: center; font-family: verdana;">\n<h1 style="color:red;">Atheer Alghamdi in danger!</h1>\n<p>REDFLAG has been activated.</p>\n<br>\n<br>\n<br>\n<br>\n<a style="color:#6c63ff;font-weight: 900" href="$value">The Location Link</a></div>';

      // print(msg2);
      // setState(() --> Notify the framework that the internal state of this object has changed.
      // setState(() {
      userFirstName = loggedInUser.getUserFirstName;
      userLastName = loggedInUser.getUserLastName;
      // String msg =
      //     '<p><strong>$userFirstName $userLastName </strong> is in danger!.\n</p><p>the user location  ------ .</p>\n<br>\<br>\n<br>\n<br>\n<br>\n<hr>\n<p style="color:#6c63ff; font-family:Arial, Helvetica, sans-serif; font-size:18px;";><strong>Atheer Alghamdi</strong></p>\<p style="font-family:Arial, Helvetica, sans-serif; font-size:15px;"><strong>Redflag Developer | IT Department </strong></p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Email: redflagapp.8@gmail.com</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Adress: King Abdulaziz University | FCIT</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Websit: <a href="https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php">https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php</a></p>\n<br>\n<br>';
      // Future<dynamic> loc = UserLocation().getLocation();
      // print('loc ----> $loc');
      // print('-------------------');
      // print(UserLocation().getLocation());

      //------------------------When the 30 sec end without the correct PIN-----------------------------
      _timer = Timer(Duration(seconds: 30), () {
        if (_timer?.isActive == false && _pinLength == false) {
          // if it from the Emergency buttons
          //    - Activate fetaures
          if (widget.status == 'emergency') {
            print('1- Fetures Activated');

            //startdate
            DateTime now = DateTime.now();
            startDate =
                "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

            //----------------------------------------
            // Send an email to the emergency contact
            emergencyCase.sendMail(recipients, subject, msg2);

            //record for 60 seconds
            record();
            scheduleTimeout(60 * 1000); // 60 seconds.

          }

          //either from emergency button or safe button,
          //when the timer end without correct input
          //go to termenation page
          print('2- went to termination page');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const terminationPage()),
          );
        }
      });
    }); // value
    // });
  }

  @override
  Widget build(BuildContext context) {
// -------------------------- Timer 30 sec ----------------------------
    // final currentPosition = Provider.of<Position?>(context);
    // lat = currentPosition?.latitude;
    // lng = currentPosition?.longitude;

    // print('lat from pin--> $lat');
    // print('lng from pin --> $lng');

    startTimer();

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
                        // flutter_animator
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

                    // VerificationCode is from flutter_verification_code 1.1.2+1
                    // A Flutter package that help you create a verification input.
                    child: VerificationCode(
                      //-------------------------------------
                      //*********Style**********
                      //-------------------------------------
                      length: 4, //quantity of boxes
                      autofocus: true, //auto focus when screen appears
                      digitsOnly: true, //accept only digit inputs from keyboard
                      textStyle: TextStyle(fontSize: 20, color: Colors.black),
                      underlineColor: Color.fromARGB(255, 0, 0, 0),
                      underlineUnfocusedColor: Color.fromARGB(255, 0, 0, 0),

                      //-------------------------------------
                      ////*********the user input stored in _code//*********
                      //-------------------------------------
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
                      onPressed: () {
                        verify();
                      },
                      color: Color(0xFF6666FF),
                      padding: EdgeInsets.only(
                          top: 20, bottom: 20, left: 130, right: 130),
                      child: Text(
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
