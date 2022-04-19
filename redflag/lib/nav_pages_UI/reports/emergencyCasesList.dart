import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redflag/nav_pages_UI/reportsPage.dart';

class cemrgencyCases extends StatefulWidget {
  const cemrgencyCases({Key? key}) : super(key: key);

  @override
  State<cemrgencyCases> createState() => _cemrgencyCasesState();
}

class _cemrgencyCasesState extends State<cemrgencyCases> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 300.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('emergencyCase')
                    .where('user', isEqualTo: user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text('Case Number ' + data['caseNumber']),
                        leading: Icon(Icons.insert_drive_file_rounded),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_rounded),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => reportsPage(
                                        caseNumb: data['caseNumber'],
                                      )),
                            );
                          },
                        ),
                        // subtitle: Text(data['ecEmail']),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
