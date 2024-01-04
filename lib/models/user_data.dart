class UserData {
  String firstName;
  String lastName;
  String phoneNumber;
  String dateOfBirth;
  String gender;
  String college;

  UserData({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.dateOfBirth = '',
    this.gender = 'Male',
    this.college = 'BTH',
  });

  UserData.fromMap(Map<String, dynamic> map)
      : firstName = map['firstName'] ?? '',
        lastName = map['lastName'] ?? '',
        phoneNumber = map['phoneNumber'] ?? '',
        dateOfBirth = map['dateOfBirth'] ?? '',
        gender = map['gender'] ?? 'Male',
        college = map['college'] ?? 'BTH';

  get uid => null;

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'college': college,
    };
  }
}