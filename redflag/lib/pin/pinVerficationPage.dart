import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
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
  final confirmPinEditingController = new TextEditingController();

  bool _pinLength = false; // flag for the timer
  Timer? _timer;
  late FlutterSoundRecorder _myRecorder;
  final audioPlayer = AssetsAudioPlayer();
  late String filePath;

  late final emergencyId;
  late final endDate;

// Retrive the registered PIN
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();
////////////////
  EmergencyContacts emergencyContactModel = EmergencyContacts();
  List<dynamic> recipients = <dynamic>[];
  String? userFirstName;
  String? userLastName;

  Emergency emergencyCase = new Emergency();
  String subject = 'There is an emergency ::🔴:: Redflag Team';
  String? downloadUrl;
  String? locLink;
  String? recoURL;

  @override
  void initState() {
    super.initState();
    // this only starts the recording session beforehand
    startIt();

    // retrive the Emergency Contacts name and emailes to send them an Emergency Email
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
          recipients.add(loggedInUser.emergencyContacts[i].ecEmail);
        }
      });
    });
// -------------- to retrive the length of emergency contact based on the UID.--------------
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = Users.fromMap(value.data());
      setState(() {});
    });
  }

  // ---------- Check if the 4 digit the user enter equal the one in Firestore ----------
  verify() {
    //----------------- Display an error message when user enter less than 4 digits------------------
    if (confirmPinEditingController.text.length < 4) {
      _pinLength = false;
      int k = confirmPinEditingController.text.length;
      print("> 4");
      // the msg
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
      //----------------- Deactivate when the user enter the correct pin------------------
      if (confirmPinEditingController.text == '${loggedInUser.getPin}') {
        _pinLength = true;
        print('= 4');

        // if the user:
        //1) entered the pin page from the Safe button
        //2) terminate the emergency
        //----> it will add new emergency case  to firestore
        if (widget.status == 'safe') {
          // 1
          //generate emergencycase ID
          emergencyId = "RF" + DateTime.now().millisecondsSinceEpoch.toString();
          // 2
          //Incedint date
          DateTime nowEnd = DateTime.now();
          endDate =
              "${nowEnd.year.toString()}-${nowEnd.month.toString().padLeft(2, '0')}-${nowEnd.day.toString().padLeft(2, '0')} ${nowEnd.hour.toString().padLeft(2, '0')}-${nowEnd.minute.toString().padLeft(2, '0')}";

          // set the Incedint date in the emergencyCae object
          emergencyCase.endTime = endDate;

          // 3
          //UPLOAD AUDIO TO FIREBASE STORAGE
          uploadRecording(emergencyId);
        }
        if (widget.status == 'emergency') {
          // Message
          final snackBar = SnackBar(
            content: const Text(
                'Deactivated Seccussfully.\n Note: NO feature has been activated.'),
            backgroundColor: Colors.teal, // Inner padding for SnackBar content.
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

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NavScreen()),
        );

        //----------------- Display an error message when user enter pin dont equal registered pin------------------
      } else {
        final snackBar = SnackBar(
          content: const Text('Incorrect, please re-enter.'),
          backgroundColor: Color.fromARGB(255, 255, 117, 107),
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

  // ---------- will open an audio session and setup before recording ----------
  //setting temp recording in the files
  void startIt() async {
    // getTemporaryDirectory => help to get a temp directory based on the device running the app
    Directory tempDir =
        await getTemporaryDirectory(); // where the recording will be stored
    filePath = tempDir.path + '/temps.aac';

    //new Flutter Sound Recorder.
    _myRecorder = FlutterSoundRecorder(); // obj

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

  // ---------- Start the recording ----------
  Future<void> record() async {
    _myRecorder.openAudioSession(); // start record
    await _myRecorder.startRecorder(
      toFile: filePath, // where to save it
      codec: Codec.defaultCodec, // audio file type
    );

    // ******** important for the recording ********
    /// The subscription provides events to the listener,
    /// and holds the callbacks used to handle the events.
    /// The subscription can also be used to unsubscribe from the events,
    /// or to temporarily pause the events from the stream.
    StreamSubscription _recorderSubscription =
        /**
     * _recordingSession.onProgress.listen then listens while the audio recording
     *  is in progress. While this happens.
     */
        _myRecorder.onProgress!.listen((e) {});
    _recorderSubscription.cancel();
  }

  // ---------- Stop the recording (Close the session) ----------
  Future<String?> stopRecord() async {
    _myRecorder.closeAudioSession();
    return await _myRecorder.stopRecorder();
  }

  //----------------------timer to stop the recording-----------------------
  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), stopRecord);

  //----------upload emergency case detailes to firebase ----------
  // to get the download url to add it to firestore
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
    setState(() {
      recoURL = emergencyCase.audioRecording;
    });

    emergencyCase.caseNumber = ecaseID;
    emergencyCase.audioRecording = downloadUrl;

    //upload to firebase firestore
    await firebaseFirestore
        .collection("emergencyCase")
        .doc()
        .set(emergencyCase.toMap(user!.uid));
  }

  void startTimer() {
    Future<dynamic> loc = UserLocation().getLocation().then((value) {
      userFirstName = loggedInUser.getUserFirstName;
      userLastName = loggedInUser.getUserLastName;

      //set the user location link in the emergency case object
      //to store the link in firestore
      emergencyCase.userLocation = value;
      setState(() {
        locLink = value;
      });

      // the email content
      String msg2 =
          '<div style=" height: 300px; width: 600px; border-style: ridge; border-radius: 15px; text-align: center; font-family: verdana;">\n<h1 style="color:red;">$userFirstName $userLastName in danger!</h1>\n<p>REDFLAG has been activated.</p>\n<br>\n<br>\n<br>\n<br>\n<a style="color:#6c63ff;font-weight: 900" href="$value">The Location Link</a></div>';

      //------------------------30 Sec Timer, will only perform the features if the user didn't enter the correct pin-----------------------------
      _timer = Timer(Duration(seconds: 30), () {
        if (_timer?.isActive == false && _pinLength == false) {
          // ----------- if the user entered the pin page from --> the Emergency button.
          if (widget.status == 'emergency') {
            // Activate fetaures
            print('1- Fetures Activated');
            // 1) Send an emergency email to the emergency contact
            emergencyCase.sendMail(recipients, subject, msg2);
            //2) record audio for 60 seconds
            record();
            scheduleTimeout(60 * 1000); // 60 seconds.
            //3) Mute
            // in the Activation page

          }

          print('2- went to termination page');
          //either from Emergency button or Safe button,
          //when the timer end without correct input
          //it will send the user to the Termenation page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const terminationPage()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // The timer will start ince the user enter the pin page
    startTimer();

    // ---------------------- PIN page UI ----------------------
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
                      "Please enter the 4 digit code \n you specified during registration to deactivate.\n You have 30 sec.",
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
                    child: TextFormField(
                        key: Key('pinTextField_pinPage'),
                        maxLength: 4,
                        autofocus: true,
                        controller: confirmPinEditingController,
                        onSaved: (value) {
                          confirmPinEditingController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "PIN",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                  ),

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
                      key: Key('verifyPinButton_pinPage'),
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
                ],
              )),
        ));
  }
}
