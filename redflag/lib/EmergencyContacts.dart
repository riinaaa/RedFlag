class EmergencyContacts {
  var eFullName;
  var ecEmail;

  EmergencyContacts({this.eFullName, this.ecEmail}) {
    eFullName = this.eFullName;
    ecEmail = this.ecEmail;
  }

  String get getFullName => this.eFullName;

  set setFullName(String fullName) => this.eFullName = fullName;

  get getEcEmail => this.ecEmail;

  set setEcEmail(ecEmail) => this.ecEmail = ecEmail;

  // receiving data from server
  factory EmergencyContacts.fromMap(map) {
    return EmergencyContacts(
      ecEmail: map['ecEmail'],
      eFullName: map['eFullName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap(String uid) {
    return {
      'ecEmail': ecEmail,
      'eFullName': eFullName,
      //act as a forign key
      'user': uid,
    };
  }
}
