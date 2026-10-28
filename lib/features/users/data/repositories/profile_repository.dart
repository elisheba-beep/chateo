import 'dart:math';

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

  Stream<UserProfile?> watchCurrentUser(){
    final uid = currentUid;
    if(uid.isEmpty) return Stream.value(null);
    return _firestore.collection('users').doc(uid).snapshots().map((doc){
      final data = doc.data();
      return data == null ? null : UserProfile.fromMap(data, id:doc.id);
    });
  }

  Stream<List<UserProfile>> watchContacts(){
    final me = currentUid;
    return _firestore.collection('users').limit(100).snapshots().map((snap){
      return snap.docs.map((d)=>UserProfile.fromMap(d.data(), id:d.id)).where((u)=>u.uid != me && u.firstName.isNotEmpty).toList()..sort((a, b)=>a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
    });
  }


  Future<List<UserProfile>> getUsersByIds(List<String> ids)async{
    if(ids.isEmpty) return [];
    final snaps = await Future.wait([
      for(var i = 0; i < ids.length; i +=30)
      _firestore.collection('users').where(FieldPath.documentId, whereIn: ids.sublist(i, min(i+30, ids.length))).get(),
    ]);
    return [
      for(final s in snaps)
      for(final d in s.docs) UserProfile.fromMap(d.data(), id:d.id),
    ];
  }
}
