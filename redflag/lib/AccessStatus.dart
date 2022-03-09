import 'package:flutter/material.dart';

class AccessStatus extends StatelessWidget {
  //const AccessStatus({ Key? key }) : super(key: key);

  //----------------------
  var camera;
  var microphone;
  var location;

  AccessStatus.empty();
  AccessStatus(this.camera, this.microphone, this.location) {
    camera = this.camera;
    microphone = this.microphone;
    location = this.location;
  }
  get getCamera => this.camera;

  set setCamera(var camera) => this.camera = camera;

  get getMicrophone => this.microphone;

  set setMicrophone(microphone) => this.microphone = microphone;

  get getLocation => this.location;

  set setLocation(location) => this.location = location;

  //----------- UI -----------
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
