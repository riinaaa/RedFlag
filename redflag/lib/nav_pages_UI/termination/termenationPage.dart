import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:redflag/pin/pinVerficationPage.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:intl/intl.dart' show DateFormat;

class terminationPage extends StatefulWidget {
  const terminationPage({Key? key}) : super(key: key);

  @override
  State<terminationPage> createState() => _terminationPageState();
}

class _terminationPageState extends State<terminationPage> {
  late FlutterSoundRecorder _myRecorder;
  final audioPlayer = AssetsAudioPlayer();
  late String filePath;
  bool _play = false;
  String _recorderTxt = '00:00:00';

  @override
  void initState() {
    super.initState();
    startIt();
    scheduleStartRecording(
        1 * 1000); // make the recording start immediately after the page load
    scheduleTimeout(60 * 1000); // make the recording stop after 60 second
  }

  // timer for the recording to start
  Timer scheduleStartRecording([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), record);

  // timer for the recording to stop
  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), stopRecord);

  void startIt() async {
    //setting temp recording in the files
    filePath = '/sdcard/Download/temps.wav';
    //new Flutter Sound Recorder.
    _myRecorder = FlutterSoundRecorder();

// *open* the Audio Session before using it.
    await _myRecorder.openAudioSession(
        focus: AudioFocus.requestFocusAndDuckOthers,
        category: SessionCategory.record,
        mode: SessionMode.modeDefault,
        device: AudioDevice.speaker);

    /// Sets the frequency at which duration updates are sent to
    /// duration listeners.
    await _myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting();

    // move this to first page alongside the location
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

//method to start the audio recording
  Future<void> record() async {
    Directory dir = Directory(path.dirname(filePath));
    if (!dir.existsSync()) {
      dir.createSync();
    }
    _myRecorder.openAudioSession();
    await _myRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
    );

    /// The subscription provides events to the listener,
    /// and holds the callbacks used to handle the events.
    /// The subscription can also be used to unsubscribe from the events,
    /// or to temporarily pause the events from the stream.
    StreamSubscription _recorderSubscription =
        _myRecorder.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

      setState(() {
        _recorderTxt = txt.substring(0, 8);
      });
    });
    _recorderSubscription.cancel();
  }

// method to stop the audio recoring
  Future<String?> stopRecord() async {
    _myRecorder.closeAudioSession();
    return await _myRecorder.stopRecorder();
  }

  Future<void> startPlaying() async {
    audioPlayer.open(
      Audio.file(filePath),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlaying() async {
    audioPlayer.stop();
  }

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
