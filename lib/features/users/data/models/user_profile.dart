class UserProfile {
  final String uid;
  final String firstName;
  final String? lastName;
  final String? base64Image; 

  UserProfile({
    required this.uid,
    required this.firstName,
    this.lastName,
    this.base64Image,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'base64Image': base64Image,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'],
      base64Image: map['base64Image'],
    );
  }
}
