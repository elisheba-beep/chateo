import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(firebaseFirestoreProvider),
    );

class ProfileRepository {
  ProfileRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String get currentUid => _auth.currentUser?.uid ?? '';

  Future<void> saveProfile(UserProfile profile) =>
      _firestore.collection('users').doc(profile.uid).set(profile.toMap());

  Future<bool> profileExists(String uid) async {
    if (uid.isEmpty) return false;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists;
  }
}
