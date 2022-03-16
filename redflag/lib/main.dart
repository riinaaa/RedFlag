import 'package:flutter/material.dart';
import 'package:redflag/registration_pages/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
