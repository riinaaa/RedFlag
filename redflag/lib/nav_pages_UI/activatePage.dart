import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redflag/pin/pinVerficationPage.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mode/permission_handler.dart';

class activationPage extends StatefulWidget {
  const activationPage({Key? key, lat, lang}) : super(key: key);

  @override
  State<activationPage> createState() => _activationPageState();
}

class _activationPageState extends State<activationPage> {
  RingerModeStatus _soundMode = RingerModeStatus.unknown;

  @override
  void initState() {
    super.initState();
    permissionsInit();
  }

  //--------------------to make sure all permissions and accesses are granted----------------------
  void permissionsInit() async {
    await Permission.microphone.request(); // to access mic
    await Permission.storage
        .request(); // to mange audio recording in the temp file (delete,..etc)
    await Permission.manageExternalStorage
        .request(); // to store audio recording in a temp file
    await Permission.accessNotificationPolicy.request(); // for the mute

    //////////////////////////////////////////////////////////
    //------------------ Location access --------------------
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services(GPS) are enabled .
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    // first it's going to check the permission statues if its denied then request user permision
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //////////////////////////////////////////////////////////
    //------------------- Mute Permission -------------------
    //this checks if the user granted the do not disturb permission
    bool? isGranted = await PermissionHandler.permissionsGranted;
    if (!isGranted!) {
      //if not it will open the Do Not Disturb Access settings to grant the access
      await PermissionHandler.openDoNotDisturbSetting();
    }
  }

// ------------------------- to set the sound mode to silent -------------------------
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

// ------------------------- The activation page UI -------------------------
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
                  key: Key('ActivationButton'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onSurface: Colors.transparent,
                    shadowColor: Colors.transparent,
                    //make color or elevated button transparent
                    fixedSize: const Size(500, 300), // button size
                  ),
                  onPressed: () {
                    // on activation it will set the user's phone to silent
                    _setSilentMode();
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
