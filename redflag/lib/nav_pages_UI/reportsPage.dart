import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for the clipboard
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  //  Firebase Auth
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();

  // To play audio player
  final audioPlayer = new AudioPlayer();
  bool isPlaying = false;
  late String _filePath;
  late String locationLink;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

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

  void _onPlayButtonPressed() {
    if (!isPlaying) {
      // if the audio in not playing
      print('method --> $_filePath');
      isPlaying = true;
      audioPlayer.play(_filePath); // will paly the audio through the URL

      audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          isPlaying = false;
        });
      });
    } else {
      // if the audio is palying
      audioPlayer.pause(); // will pause the audio through the URL
      isPlaying = false;
    }
    setState(() {});
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

//------------------------------------Return to the case numbers list page------------------------------------

              Container(
                margin: EdgeInsets.only(top: 80, left: 15),
                child: IconButton(
                  key: Key('returnButton_reportPage'),
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
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(top: 170),
                // --------------- Retriving Emergency Case Detailes based on the caseNumb ---------------
                //StreamBuilder<QuerySnapshot> => we used it to retrive it as Listview
                // and to be apply to retrive multiple documents from the Firestore
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

                    // -------------- The UI of the Listview --------------
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return Column(
                          children: [
                            Row(
                              children: [
// ----------------------------------------- dispaly Emergency case ID -----------------------------------------
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 15, left: 8, right: 8),
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
                                      subtitle: Text(data['caseNumber']),
                                    ),
                                  ),
                                ),
// ----------------------------------------- dispaly Incident date -----------------------------------------
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 15, left: 8, right: 8),
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
                                          key: Key(
                                              'copyLocationLinkButton_reportPage'),
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
                                    subtitle: Text(data['userLocation']),
                                  ),
                                ),
                              ],
                            ),
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
                                  ),
                                  Align(
                                    alignment: Alignment
                                        .centerLeft, // or AlignmentDirectional.center,

                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, right: 8),
                                      child: ElevatedButton(
                                        key: Key('playAudioButton_Page'),
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
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            _filePath = data['audioRecording'];
                                          });
                                          _onPlayButtonPressed();
                                          print(_filePath);
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
