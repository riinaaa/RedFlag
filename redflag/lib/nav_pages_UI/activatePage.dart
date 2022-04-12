import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:redflag/locations/user_location.dart';
import 'package:redflag/pin/pinVerficationPage.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class activationPage extends StatefulWidget {
  const activationPage({Key? key, lat, lang}) : super(key: key);

  @override
  State<activationPage> createState() => _activationPageState();
}

// SEND A LINK
//  onPressed: () {
//                   UserLocation().getLocation();
//                 },
class _activationPageState extends State<activationPage> {
  RingerModeStatus _soundMode = RingerModeStatus.unknown;
  String? _permissionStatus;
  double? lat;
  double? lng;

  @override
  void initState() {
    super.initState();
    _getCurrentSoundMode();
    _getPermissionStatus();
  }

  Future<void> _getCurrentSoundMode() async {
    RingerModeStatus ringerStatus = RingerModeStatus.unknown;

    Future.delayed(const Duration(seconds: 1), () async {
      try {
        ringerStatus = await SoundMode.ringerModeStatus;
      } catch (err) {
        ringerStatus = RingerModeStatus.unknown;
      }

      setState(() {
        _soundMode = ringerStatus;
      });
    });
  }

  Future<void> _getPermissionStatus() async {
    bool? permissionStatus = false;
    try {
      permissionStatus = await PermissionHandler.permissionsGranted;
      print(permissionStatus);
    } catch (err) {
      print(err);
    }

    setState(() {
      _permissionStatus =
          permissionStatus! ? "Permissions Enabled" : "Permissions not granted";
    });
  }

  Future<void> _setSilentMode() async {
    RingerModeStatus status;

    try {
      status = await SoundMode.setSoundMode(RingerModeStatus.silent);

      setState(() {
        _soundMode = status;
      });
    } on PlatformException {
      print('Do Not Disturb access permissions required!');
    }
  }

  // Future<void> _setNormalMode() async {
  //   RingerModeStatus status;

  //   try {
  //     status = await SoundMode.setSoundMode(RingerModeStatus.normal);
  //     setState(() {
  //       _soundMode = status;
  //     });
  //   } on PlatformException {
  //     print('Do Not Disturb access permissions required!');
  //   }
  // }

  // Future<void> _openDoNotDisturbSettings() async {
  //   await PermissionHandler.openDoNotDisturbSetting();
  // }

  @override
  Widget build(BuildContext context) {
    // String loc = UserLocation().getLocation().toString();
    // print('loc ----> $loc');

    final currentPosition = Provider.of<Position?>(context);
    lat = currentPosition?.latitude;
    lng = currentPosition?.longitude;

    print('lat --> $lat');
    print('lng --> $lng');

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
                    _setSilentMode();
                    // UserLocation().getLocation(); // usre location link
                    // Verificatoin();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Verificatoin(
                                status: 'emergency',
                              )),
                    );
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
