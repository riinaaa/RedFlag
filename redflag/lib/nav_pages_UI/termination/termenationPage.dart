import 'package:flutter/material.dart';
import 'package:redflag/pin/pinVerficationPage.dart';

class terminationPage extends StatefulWidget {
  const terminationPage({Key? key}) : super(key: key);

  @override
  State<terminationPage> createState() => _terminationPageState();
}

class _terminationPageState extends State<terminationPage> {
  @override
  void initState() {
    super.initState();
  }

  // Future<void> startPlaying() async {
  //   audioPlayer.open(
  //     Audio.file(filePath),
  //     autoStart: true,
  //     showNotification: true,
  //   );
  // }

  // Future<void> stopPlaying() async {
  //   audioPlayer.stop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 130.0, bottom: 20.0),
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(255, 82, 255, 125),
                        Color.fromARGB(255, 114, 241, 182)
                        //add more colors
                      ]),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color.fromARGB(
                                145, 63, 63, 63), //shadow for button
                            blurRadius: 10 //blur radius of shadow
                            )
                      ]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //make color or elevated button transparent
                      fixedSize: const Size(500, 300), // button size
                    ),
                    onPressed: () {
                      // UserLocation().getLocation(); // usre location link
                      // Verificatoin();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Verificatoin(
                                  status: 'safe',
                                )),
                      );
                    },
                    child: new Text(
                      "I'm Safe",
                      style: new TextStyle(
                        fontSize: 25.0,
                        color: Color.fromARGB(255, 241, 226, 226),
                      ),
                    ),
                  )),

// DELETE JUST FOR TESTINGGGG
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     primary: Color.fromARGB(255, 165, 60, 60),
              //     shadowColor: Color.fromARGB(0, 210, 118, 118),
              //     //make color or elevated button transparent
              //     fixedSize: const Size(50, 50), // button size
              //   ),
              //   onPressed: () {
              //     startPlaying();
              //   },
              //   child: new Text(
              //     "play",
              //     style: new TextStyle(
              //       fontSize: 10.0,
              //       color: Color.fromARGB(255, 255, 255, 255),
              //     ),
              //   ),
              // ),
            ],
          )),
    ));
  }
}
