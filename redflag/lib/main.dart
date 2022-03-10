import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import './nav_pages_UI/activatePage.dart';
import './nav_pages_UI/mapPage.dart';
import './nav_pages_UI/profilePage.dart';
import './nav_pages_UI/reportsPage.dart';

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
  List pages = [activatePage(), profilePage(), mapPage(), reportsPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // ---------------- APP BAR --------------
        appBar: AppBar(
          title: Text(
            'REDFLAG',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),

        // ---------------- NAV BAR --------------
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                icon: Icon(Icons.radio_button_checked),
                title: Text('Activate'),
                activeColor: Colors.deepPurple,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Profile'),
                activeColor: Colors.deepPurple,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.map),
                title: Text('Map'),
                activeColor: Colors.deepPurple,
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.insert_drive_file_rounded),
                title: Text('Report'),
                activeColor: Colors.deepPurple,
                inactiveColor: Colors.black)
          ],
        ),

        // ---------------- BODY --------------
        body: pages[currentIndex],
      ),
    );
  }
}
