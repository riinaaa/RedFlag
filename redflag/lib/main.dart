import 'package:flutter/material.dart';
import 'package:redflag/registration_pages/landing_screen.dart';

void main() {
  runApp(MyApp());
}

// we need classes to create widgets.
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //change it in the colors class to the redflag main color
        primarySwatch: Colors.indigo,
      ),
      home: LandingScreen(),
    );
  }
}
