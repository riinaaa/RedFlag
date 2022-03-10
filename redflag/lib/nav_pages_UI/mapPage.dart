import 'package:flutter/material.dart';

class mapPage extends StatefulWidget {
  const mapPage({Key? key}) : super(key: key);

  @override
  State<mapPage> createState() => _mapPageState();
}

class _mapPageState extends State<mapPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(child: Text("MapPage")),
      ),
    );
  }
}
