import 'dart:convert';
import 'dart:typed_data';

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
String get fullName => '$firstName ${lastName ?? ''}'.trim();

String get initials {
  final f = firstName.trim();
  final l = (lastName ?? '').trim();
  return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}';


}

late final Uint8List? imageBytes = _decode(base64Image);

static Uint8List? _decode(String? s){
  if(s==null || s.isEmpty) return null;
  try{
    return base64Decode(s);
  }on FormatException {
    return null;
  }
}

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'base64Image': base64Image,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, {String? id}) {
    return UserProfile(
      uid: id ?? (map['uid'] as String? ?? ''),
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String?,
      base64Image: map['base64Image'] as String?,
    );
  }
}
