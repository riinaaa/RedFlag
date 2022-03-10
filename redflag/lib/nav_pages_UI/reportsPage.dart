import 'package:flutter/material.dart';

class reportsPage extends StatefulWidget {
  const reportsPage({Key? key}) : super(key: key);

  @override
  State<reportsPage> createState() => _reportsPageState();
}

class _reportsPageState extends State<reportsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 139, 255, 143),
        body: Center(child: Text("reportsPage")),
      ),
    );
  }
}
