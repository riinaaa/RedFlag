import 'package:flutter/material.dart';
import 'package:redflag/locations/user_location.dart';

class activatePage extends StatefulWidget {
  const activatePage({Key? key}) : super(key: key);

  @override
  State<activatePage> createState() => _activatePageState();
}

class _activatePageState extends State<activatePage> {
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
                      Colors.redAccent,
                      Color.fromARGB(255, 241, 114, 114)
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
                    UserLocation().getLocation();
                  },
                  child: new Text(
                    "Emergency",
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
