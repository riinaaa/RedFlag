import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

// import 'document_snapshot_matcher.dart';
// import 'query_snapshot_matcher.dart';

const uid = 'abc';

final from = (DocumentSnapshot<Map<String, dynamic>> snapshot, _) =>
    snapshot.exists ? (Movie()..title = snapshot['title']) : null;
final to = (Movie? movie, _) =>
    movie == null ? <String, Object?>{} : {'title': movie.title};
void main() {
  group('dump', () {
    const expectedDumpAfterset = '''{
  "users": {
    "abc": {
      "name": "Bob"
    }
  }
}''';

    // Add EC
    // Add new user
    //Add Emergency case
    test('Sets data for a document within a collection', () async {
      final instance = FakeFirebaseFirestore();
      await instance.collection('users').doc(uid).set({
        'name': 'Bob',
      });
      expect(instance.dump(), equals(expectedDumpAfterset));
    });
  });

  test('Snapshots sets exists property to true if the document does exist',
      () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').doc(uid).set({
      'name': 'Bob',
    });
    instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(expectAsync1((document) {
      expect(document.exists, equals(true));
    }));
  });

  test('Snapshots sets exists property to false if the document does not exist',
      () async {
    final instance = FakeFirebaseFirestore();
    await instance.collection('users').doc(uid).set({
      'name': 'Bob',
    });
    instance
        .collection('users')
        .doc('doesnotexist')
        .snapshots()
        .listen(expectAsync1((document) {
      expect(document.exists, equals(false));
    }));
  });

// The doc is there but it it is empty (no data)
  test('Nonexistent document should have null data', () async {
    final nonExistentId = 'nonExistentId';
    final instance = FakeFirebaseFirestore();

    final snapshot1 =
        await instance.collection('users').doc(nonExistentId).get();
    expect(snapshot1, isNotNull);
    expect(snapshot1.id, nonExistentId);
    // data field should be null before the document is saved
    expect(snapshot1.data(), isNull);
  });

// Delete test
  test('delete', () async {
    final instance = FakeFirebaseFirestore();
    // 1) create instance
    await instance.collection('users').doc(uid).set({
      'username': 'Bob',
    });
    await instance.collection('users').doc('def').set({
      'username': 'atheer',
    });
    // 2) delete instance
    await instance.collection('users').doc(uid).delete();
    await instance.collection('users').doc('def').delete();

    // 3) get instance after delete to check it in the exception method.
    final users = await instance.collection('users').get();

    // 4) check if the whole doc is empty or not.
    expect(users.docs.isEmpty, equals(true));
    expect(instance.hasSavedDocument('users/abc'), false);
    expect(instance.hasSavedDocument('users/def'), false);
  });
}

class Movie {
  late String title;
}
