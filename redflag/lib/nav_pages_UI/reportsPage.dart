import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for the clipboard
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:redflag/Emergency.dart';
import 'package:redflag/EmergencyContacts.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/nav_pages_UI/reports/emergencyCasesList.dart';
import 'package:redflag/registration_pages/login_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class reportsPage extends StatefulWidget {
  final String caseNumb;
  const reportsPage({Key? key, required this.caseNumb}) : super(key: key);

  @override
  State<reportsPage> createState() => _reportsPageState();
}

class _reportsPageState extends State<reportsPage> {
  // To retrive from Firebase
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();
  // Emergency caseInfo = Emergency();
  // To play audio player
  final audioPlayer = new AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration postion = Duration.zero;
  late String _filePath;
  //
  late String locationLink;

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // // listen to states --> playing, paused, stooped
    // audioPlayer.onPlayerStateChanged.listen((state) {
    //   setState(() {
    //     isPlaying = state == PlayerState.PLAYING;
    //   });
    // });

    // listen to audio duration
    // audioPlayer.onDurationChanged.listen((newDuration) {
    //   setState(() {
    //     duration = newDuration;
    //   });
    // });

    // // listen to audio duration
    // audioPlayer.onAudioPositionChanged.listen((newPostion) {
    //   setState(() {
    //     postion = newPostion;
    //   });
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

  void _onPlayButtonPressed() {
    if (!isPlaying) {
      print('method --> $_filePath');
      isPlaying = true;
      audioPlayer.play(_filePath);

      audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          isPlaying = false;
        });
      });
    } else {
      audioPlayer.pause();
      isPlaying = false;
    }
    setState(() {});
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
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

              //------------------------------------Return to the case numbers list page------------------------------------

              Container(
                margin: EdgeInsets.only(top: 80, left: 15),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(
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

// ----------------------------------------- Retrive the case details based on the case number -----------------------------------------

              Container(
                margin: EdgeInsets.only(top: 170),
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
                      return Center(child: CircularProgressIndicator());
                      // return Text("Loading --> waiting");
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

// ----------------------------------------- dispaly Emergency case ID -----------------------------------------

                        return Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(170, 226, 223, 223)
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
// ----------------------------------------- dispaly Activation time -----------------------------------------

                                // Flexible(
                                //   fit: FlexFit.loose,
                                //   child: Container(
                                //     margin: EdgeInsets.only(left: 8, right: 8),

                                //     // margin: EdgeInsets.only(left: 25, right: 260),
                                //     // padding: EdgeInsets.only(top: 20, bottom: 20),
                                //     decoration: BoxDecoration(
                                //       color: Color.fromRGBO(255, 255, 255, 1),
                                //       borderRadius: BorderRadius.circular(10),
                                //       boxShadow: [
                                //         BoxShadow(
                                //           color:
                                //               Color.fromARGB(170, 226, 223, 223)
                                //                   .withOpacity(0.5),
                                //           spreadRadius: 5,
                                //           blurRadius: 7,
                                //         ),
                                //       ],
                                //     ),
                                //     child: ListTile(
                                //       title: Text('Start Time\n',
                                //           style: TextStyle(
                                //               fontSize: 15,
                                //               fontWeight: FontWeight.bold,
                                //               color: Color(0xFF6666FF))),
                                //       // leading: Icon(Icons.access_time_filled_sharp),
                                //       subtitle: Text(data['startTime']),
                                //     ),
                                //   ),
                                // ),
                                // ----------------------------------------- dispaly termination time -----------------------------------------
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 8, right: 8),
                                    // padding: EdgeInsets.only(top: 20, bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Color.fromARGB(170, 226, 223, 223)
                                                  .withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text('Incident Date\n',
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
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            // ----------------------------------------- dispaly location -----------------------------------------
                            // IconButton(
                            //     onPressed: () {
                            //       setState(() {
                            //         locationLink = data['userLocation'];
                            //       });

                            //       // Clipboard.setData(
                            //       //     ClipboardData(text: locationLink));

                            //       Clipboard.setData(
                            //               ClipboardData(text: locationLink))
                            //           .then((_) {
                            //         ScaffoldMessenger.of(context).showSnackBar(
                            //             SnackBar(
                            //                 content: Text(
                            //                     " Address link copied to clipboard")));
                            //       });
                            //     },
                            //     icon: Icon(Icons.copy)),

                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Text('Location\n',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6666FF))),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              locationLink =
                                                  data['userLocation'];
                                            });
                                            Clipboard.setData(ClipboardData(
                                                    text: locationLink))
                                                .then((_) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          " Address link copied to clipboard")));
                                            });
                                          },
                                          icon: Icon(Icons.copy)),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                  padding: EdgeInsets.only(bottom: 40),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    // title: Text('Location\n',
                                    //     style: TextStyle(
                                    //         fontSize: 15,
                                    //         fontWeight: FontWeight.bold,
                                    //         color: Color(0xFF6666FF))),
                                    // leading: Icon(Icons.access_time_filled_sharp),
                                    subtitle: Text(data['userLocation']),
                                  ),
                                ),
                              ],
                            ),

                            // IconButton(onPressed: onPressed, icon: icon),
                            SizedBox(
                              height: 20,
                            ),
// ----------------------------------------- dispaly audio -----------------------------------------

                            Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              padding: EdgeInsets.only(bottom: 40),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Audio \n',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6666FF))),
                                    // leading: Icon(Icons.access_time_filled_sharp),
                                    // subtitle: Text(data['userLocation']),
                                  ),
                                  // Slider(
                                  //     min: 0,
                                  //     max: duration.inSeconds.toDouble(),
                                  //     value: postion.inSeconds.toDouble(),
                                  //     onChanged: (value) async {
                                  //       final position =
                                  //           Duration(seconds: value.toInt());
                                  //       await audioPlayer.seek(position);
                                  //       await audioPlayer.resume();
                                  //     }),
                                  // Padding(
                                  //   padding:
                                  //       EdgeInsets.symmetric(horizontal: 16),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text(formatTime(postion)),
                                  //       Text(formatTime(duration - postion)),
                                  //     ],
                                  //   ),
                                  // ),
                                  Align(
                                    alignment: Alignment
                                        .centerLeft, // or AlignmentDirectional.center,

                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 8),
                                      child: ElevatedButton(
                                        child: const Text('Play'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF6666FF),
                                          padding: const EdgeInsets.only(
                                              left: 30,
                                              right: 30,
                                              top: 10,
                                              bottom: 10),
                                          textStyle: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(20))
                                        ),

                                        // radius: 35,

                                        // child: IconButton(
                                        //   icon: Icon(
                                        //     isPlaying
                                        //         ? Icons.pause
                                        //         : Icons.play_arrow,
                                        //   ),
                                        //   iconSize: 50,
                                        onPressed: () async {
                                          setState(() {
                                            _filePath = data['audioRecording'];
                                          });

                                          // await Future.delayed(
                                          //     Duration(milliseconds: 300));

                                          _onPlayButtonPressed();
                                          print(_filePath);
                                          // if (isPlaying) {
                                          //   await audioPlayer.pause();
                                          // } else {
                                          //   // await audioPlayer.resume();
                                          //   // String url = data['audioRecording'];
                                          //   await audioPlayer
                                          //       .play(data['audioRecording']);
                                          //   // print(data['audioRecording']);
                                          // }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
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
