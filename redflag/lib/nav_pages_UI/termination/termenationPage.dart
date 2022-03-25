import 'package:flutter/material.dart';
// import 'package:flutter_learning/location.dart';
// import 'package:flutter_learning/main.dart';
// import 'package:flutter_learning/nav_pages/OTP_page/pin.dart';
// import 'package:flutter_learning/nav_pages/map2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:redflag/pin/pinVerficationPage.dart';

class terminationPage extends StatefulWidget {
  const terminationPage({Key? key, lat, lang}) : super(key: key);

  @override
  State<terminationPage> createState() => _terminationPageState();
}

//  onPressed: () {
//                   UserLocation().getLocation();
//                 },
class _terminationPageState extends State<terminationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 130.0, bottom: 20.0),
          padding: EdgeInsets.all(50),
          child: Column(children: [
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
                ))
          ])),
    ));
  }
}
