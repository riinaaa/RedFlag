import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class add extends StatefulWidget {
  const add({Key? key}) : super(key: key);

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  TextEditingController controller_fullName =
      new TextEditingController(); // controll the TextField
  TextEditingController controller_phone = new TextEditingController();

  String? name;
  String? phone;

  submitData() {
    name = controller_fullName.text;
    phone = controller_fullName.text;

    setState(() {});
    print(name);
    print(phone);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Stack(
            children: [
//------------------------------------ App Bar ----------------------------------------

              Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(30)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 122, 122, 243),
                      Color(0xFF4E4EF7)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              ),

//------------------------------------ User info ----------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 120),
                child: Column(
                  children: [
                    //child 1 --> avatar
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    //child 2 --> for space between the avatar and user data
                    SizedBox(
                      height: 20,
                    ),
//----------------//child 3 --> user data
                    Column(
                      children: [
                        Text(
                          'Atheer Alghamdi',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          '055-834-2221',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

//------------------------------------ Current Emergency Contacts List ----------------------------------------

              Column(
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Align(
                    // to force it to stay in the left then will control it with th margin, if i remove it, it will go the center and the margin can't move it
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 35),
                      child: Text('Add Emergency \nContacts ',
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFF4E4EF7),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        TextField(
                          controller: controller_fullName,
                          decoration: InputDecoration(hintText: 'Full Name '),
                        ),
                        TextField(
                          controller: controller_phone,
                          decoration:
                              InputDecoration(hintText: 'Phone Number '),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // space between the buttons
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15, bottom: 15),
                            child: Text('Add',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF4E4EF7),
                          ),
                        ),
                        ElevatedButton(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15, bottom: 15),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                  color: Color(0xFF84A2AF),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: null,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
