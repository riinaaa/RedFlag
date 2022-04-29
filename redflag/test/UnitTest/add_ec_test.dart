import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:redflag/Users.dart';
import 'package:test/test.dart';

// import 'document_snapshot_matcher.dart';
// import 'query_snapshot_matcher.dart';

const uid = '001';

void main() {
  // 	----------------------Add New User (Register)----------------------
  // document => Users
  //collection => uid
  group('dump', () {
    const expectedDumpAfterset = '''{
  "users": {
    "001": {
      "firstName": "Atheer",
      "lastName": "Alaghamdi",
      "email": "a.atheer.141919@gmail.com",
      "keyword": "Flower",
      "pin": "1234"
    }
  }
}''';

    test('Add data for a document within a collection', () async {
      final instance = FakeFirebaseFirestore();
      await instance.collection('users').doc(uid).set({
        "firstName": "Atheer",
        "lastName": "Alaghamdi",
        "email": "a.atheer.141919@gmail.com",
        "keyword": "Flower",
        "pin": "1234"
      });
      expect(instance.dump(), equals(expectedDumpAfterset));
    });
  });

  // 	----------------------Add Emergency Contact----------------------
  // document => emergencyContact
  //collection => uid
  group('dump', () {
    const expectedDumpAfterset = '''{
  "emergencyContact": {
    "001": {
      "eFullName": "Rina",
      "ecEmail": "rinaAlfarsi@gmail.com"
    }
  }
}''';
    test('Adding Emergency contact Success.', () async {
      final instance = FakeFirebaseFirestore();
      await instance
          .collection('emergencyContact')
          .doc(uid)
          .set({"eFullName": "Rina", "ecEmail": "rinaAlfarsi@gmail.com"});
      expect(instance.dump(), equals(expectedDumpAfterset));
    });
  });

  // 	----------------------Add Emergency Case----------------------
  // document => emergencyCase
  //collection => uid
  group('dump', () {
    const expectedDumpAfterset = '''{
  "emergencyCase": {
    "001": {
      "audioRecording": "https://firebasestorage.googleapis.com/v0/b/redflag-3d9d6.appspot.com/o/31Po9oLU7RdHW31HlEEgg5AcxwH2%2Frecordings%2Frecording_RF1650708906046?alt=media&token=96384d7b-fc32-40f1-89cb-28c1c9742f6e",
      "caseNumber": "RF1650708906046",
      "endTime": "2022-04-23 13-15",
      "userLocation": "https://www.google.com/maps/search/?api=1&query=21.488989%2C39.246326"
    }
  }
}''';
    test('Adding Emergency Case Success.', () async {
      final instance = FakeFirebaseFirestore();
      await instance.collection('emergencyCase').doc(uid).set({
        "audioRecording":
            "https://firebasestorage.googleapis.com/v0/b/redflag-3d9d6.appspot.com/o/31Po9oLU7RdHW31HlEEgg5AcxwH2%2Frecordings%2Frecording_RF1650708906046?alt=media&token=96384d7b-fc32-40f1-89cb-28c1c9742f6e",
        "caseNumber": "RF1650708906046",
        "endTime": "2022-04-23 13-15",
        "userLocation":
            "https://www.google.com/maps/search/?api=1&query=21.488989%2C39.246326"
      });
      expect(instance.dump(), equals(expectedDumpAfterset));
    });
  });

//------------------------The doc is there but it  is empty (no data)------------------------
  test('Nonexistent document should have null data', () async {
    final instance = FakeFirebaseFirestore();

    final snapshot1 = await instance.collection('users').doc(uid).get();

    expect(snapshot1, isNotNull); // check if the Doc exists
    expect(snapshot1.data(), isNull); // check if the Doc have data exists
  });

// ------------------------Delete Emergency Contact------------------------
  test('delete', () async {
    final instance = FakeFirebaseFirestore();
    // 1) create instance
    await instance
        .collection('emergencyContact')
        .doc('003')
        .set({'eFullName': 'Rina', 'ecEmail': 'rinaAlfarsi@gmail'});

    // 2) delete instance
    await instance.collection('emergencyContact').doc('003').delete();

    // 3) get instance after delete to check it in the exception method.
    final users = await instance.collection('emergencyContact').get();

    // 4) check if the whole doc is empty or not.
    expect(users.docs.isEmpty, equals(true));
  });

  // 	----------------------Retrive PIN----------------------

// Retrive PIN + check it
  test('Success retriving the pin.', () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').doc(uid).set({
      "firstName": "Atheer",
      "lastName": "Alaghamdi",
      "email": "a.atheer.141919@gmail.com",
      "keyword": "Flower",
      "pin": "1234"
    });

    final snapshot1 = await instance.collection('users').doc(uid).get();
    expect(snapshot1.data()!['pin'], "1234");
  });

  // 	----------------------Insert Emergency case detailes then retrive it to check it existing----------------------
  test('Insert and Retrieve Emergency Case Details', () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('emergencyCase').doc(uid).set({
      "audioRecording":
          "https://firebasestorage.googleapis.com/v0/b/redflag-3d9d6.appspot.com/o/31Po9oLU7RdHW31HlEEgg5AcxwH2%2Frecordings%2Frecording_RF1650708906046?alt=media&token=96384d7b-fc32-40f1-89cb-28c1c9742f6e",
      "caseNumber": "RF1650708906046",
      "endTime": "2022-04-23 13-15",
      "userLocation":
          "https://www.google.com/maps/search/?api=1&query=21.488989%2C39.246326"
    });

    final snapshot1 = await instance.collection('emergencyCase').doc(uid).get();

    expect(snapshot1.data(), isNotNull);
  });

  // 	----------------------Retrieve Emergency case details ----------------------
  test('Retrieve Emergency case details', () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('emergencyCase').doc(uid).set({
      "audioRecording":
          "https://firebasestorage.googleapis.com/v0/b/redflag-3d9d6.appspot.com/o/31Po9oLU7RdHW31HlEEgg5AcxwH2%2Frecordings%2Frecording_RF1650708906046?alt=media&token=96384d7b-fc32-40f1-89cb-28c1c9742f6e",
      "caseNumber": "RF1650708906046",
      "endTime": "2022-04-23 13-15",
      "userLocation":
          "https://www.google.com/maps/search/?api=1&query=21.488989%2C39.246326"
    });

    final snapshot1 = await instance.collection('emergencyCase').doc(uid).get();

    expect(snapshot1.data()!['caseNumber'], "RF1650708906046");
    expect(snapshot1.data()!['audioRecording'],
        "https://firebasestorage.googleapis.com/v0/b/redflag-3d9d6.appspot.com/o/31Po9oLU7RdHW31HlEEgg5AcxwH2%2Frecordings%2Frecording_RF1650708906046?alt=media&token=96384d7b-fc32-40f1-89cb-28c1c9742f6e");
    expect(snapshot1.data()!['endTime'], "2022-04-23 13-15");
    expect(snapshot1.data()!['userLocation'],
        "https://www.google.com/maps/search/?api=1&query=21.488989%2C39.246326");
  });
}
