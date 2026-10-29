import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/features/users/data/models/presence.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'presence_repository.g.dart';

@Riverpod(keepAlive: true)
PresenceRepository presenceRepository(Ref ref) => PresenceRepository(
  ref.watch(firebaseAuthProvider),
  ref.watch(firebaseFirestoreProvider),
);

class PresenceRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  new(this._auth, this._firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('presence');

  Future<void> setOnline(bool online) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _col.doc(uid).set({
        'online': online,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Stream<Map<String, Presence>> watchAll() => _col
      .limit(200)
      .snapshots()
      .map((s) => {for (final d in s.docs) d.id: Presence.fromMap(d.data())});

  Stream<Presence?> watch(String uid) => _col
      .doc(uid)
      .snapshots()
      .map((d) => d.exists ? Presence.fromMap(d.data()!) : null);
}
