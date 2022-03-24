import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';
import 'package:redflag/locations/location_service.dart';
import '/nav_pages_UI/activatePage.dart';
import '/nav_pages_UI/mapPage.dart';
import '/nav_pages_UI/profilePage.dart';
import '/nav_pages_UI/reportsPage.dart';

// we need classes to create widgets.
class NavScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavScreenState();
  }
}

class _NavScreenState extends State<NavScreen> {
  final locationService = GeoLocatorService();
  int currentIndex = 0;
  List pages = [activatePage(), profilePage(), mapPage(), reportsPage()];

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (BuildContext context) => locationService.getLocation(),
      initialData: null,
      child: Scaffold(
        // ---------------- APP BAR --------------
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
