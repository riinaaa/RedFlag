import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation extends StatelessWidget {
  const UserLocation({Key? key}) : super(key: key);

// ------------- Location Link to send it via email -----------------
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double latidue = position.latitude;
    double longtude = position.longitude;
    return 'https://www.google.com/maps/search/?api=1&query=$latidue%2C$longtude';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: UserLocation());
  }
}
