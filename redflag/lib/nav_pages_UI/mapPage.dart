import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:location/location.dart';

class mapPage extends StatefulWidget {
  const mapPage({Key? key}) : super(key: key);

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<MarkerId> listMarkerIds = List<MarkerId>.empty(growable: true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position?>(context);
    return Scaffold(
      key: scaffoldKey,
      body: (currentPosition != null)
          ? Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    key: Key('GoogleMap_mapPage'),
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentPosition.latitude,
                            currentPosition.longitude),
                        zoom: 12),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    markers: Set<Marker>.of(markers.values),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      MarkerId markerId0 = MarkerId("0");
                      MarkerId markerId1 = MarkerId("1");
                      MarkerId markerId2 = MarkerId("2");
                      MarkerId markerId3 = MarkerId("3");
                      MarkerId markerId4 = MarkerId("4");
                      MarkerId markerId5 = MarkerId("5");
                      MarkerId markerId6 = MarkerId("6");
                      MarkerId markerId7 = MarkerId("7");
                      MarkerId markerId8 = MarkerId("8");
                      MarkerId markerId9 = MarkerId("9");
                      MarkerId markerId10 = MarkerId("10");

                      listMarkerIds.add(markerId0);
                      listMarkerIds.add(markerId1);
                      listMarkerIds.add(markerId2);
                      listMarkerIds.add(markerId3);
                      listMarkerIds.add(markerId4);
                      listMarkerIds.add(markerId5);
                      listMarkerIds.add(markerId6);
                      listMarkerIds.add(markerId7);
                      listMarkerIds.add(markerId8);
                      listMarkerIds.add(markerId9);
                      listMarkerIds.add(markerId10);

                      // MARKER 0 --> User current location
                      Marker marker0 = Marker(
                          markerId: markerId0,
                          position: LatLng(currentPosition.latitude,
                              currentPosition.longitude),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          infoWindow: InfoWindow(
                              title: "You", snippet: "Your Current Location"));

                      // MARKER 1
                      Marker marker1 = Marker(
                          markerId: markerId1,
                          position: LatLng(21.4435282, 39.2775166),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة الجنوبية"));

                      // MARKER 2
                      Marker marker2 = Marker(
                          markerId: markerId2,
                          position: LatLng(21.4738536, 39.3414817),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة الجامعة"));

// MARKER 3
                      Marker marker3 = Marker(
                          markerId: markerId3,
                          position:
                              LatLng(21.526779840093848, 39.18925363537368),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة الشرفية"));

                      // MARKER 4
                      Marker marker4 = Marker(
                          markerId: markerId4,
                          position: LatLng(21.5311332, 39.3168771),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة السامر"));

                      // MARKER 5
                      Marker marker5 = Marker(
                          markerId: markerId5,
                          position: LatLng(21.4679553, 39.2483938),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة النزلتين"));

                      // MARKER 6
                      Marker marker6 = Marker(
                          markerId: markerId6,
                          position: LatLng(21.5002445, 39.2626122),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة الشمالية"));

                      // MARKER 7
                      Marker marker7 = Marker(
                          markerId: markerId7,
                          position:
                              LatLng(21.49912901779489, 39.17423433701783),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة البلد"));

                      // MARKER 8
                      Marker marker8 = Marker(
                          markerId: markerId8,
                          position: LatLng(21.6477051, 39.1578229),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة ابحر"));

                      // MARKER 9
                      Marker marker9 = Marker(
                          markerId: markerId9,
                          position: LatLng(21.5593993, 39.1980574),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "مركز شرطة حي السلامة"));

                      // MARKER 10
                      Marker marker10 = Marker(
                          markerId: markerId10,
                          position:
                              LatLng(21.52321212008469, 39.23755295316467),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueViolet),
                          infoWindow: InfoWindow(
                              title: "Police Sattion",
                              snippet: "شرطة محافظة جدة"));

                      setState(() {
                        markers[markerId0] = marker0;
                        markers[markerId1] = marker1;
                        markers[markerId2] = marker2;
                        markers[markerId3] = marker3;
                        markers[markerId4] = marker4;
                        markers[markerId5] = marker5;
                        markers[markerId6] = marker6;
                        markers[markerId7] = marker7;
                        markers[markerId8] = marker8;
                        markers[markerId9] = marker9;
                        markers[markerId10] = marker10;
                      });
                    },
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
