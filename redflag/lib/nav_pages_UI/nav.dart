import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:provider/provider.dart';
import 'package:redflag/locations/location_service.dart';
import 'package:redflag/nav_pages_UI/add_ec.dart';
import 'package:redflag/nav_pages_UI/reports/emergencyCasesList.dart';
import '/nav_pages_UI/activatePage.dart';
import '/nav_pages_UI/mapPage.dart';
import '/nav_pages_UI/profilePage.dart';

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
  List pages = [
    activationPage(),
    profilePage(),
    add(),
    mapPage(),
    cemrgencyCases()
  ];

  @override
  Widget build(BuildContext context) {
    // to pass the lat and lng to the google map
    return FutureProvider(
      create: (BuildContext context) => locationService.getLocation(),
      initialData: null,
      child: Scaffold(
        // ---------------- NAV BAR --------------
        bottomNavigationBar: BottomNavyBar(
          key: Key('bottom'),
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
                activeColor: Color(0xFF6666FF),
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Profile'),
                activeColor: Color(0xFF6666FF),
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.group_add_rounded),
                title: Text('Add'),
                activeColor: Color(0xFF6666FF),
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.map),
                title: Text('Map'),
                activeColor: Color(0xFF6666FF),
                inactiveColor: Colors.black),
            BottomNavyBarItem(
                icon: Icon(Icons.folder_rounded),
                title: Text('Repository'),
                activeColor: Color(0xFF6666FF),
                inactiveColor: Colors.black)
          ],
        ),

        // ---------------- BODY --------------
        body: pages[currentIndex],
      ),
    );
  }
}
