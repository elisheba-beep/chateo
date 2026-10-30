import 'dart:async';

import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/features/users/data/repositories/presence_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_repository.g.dart';

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) => AccountRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(firebaseFirestoreProvider),
      ref.watch(presenceRepositoryProvider),
    );

class AccountRepository {
  AccountRepository(this._auth, this._firestore, this._presence);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final PresenceRepository _presence;

  static const alreadyVerified = 'already-verified';

  Future<void> signOut() async {
    await _presence.setOnline(false); 
    await _auth.signOut();            
  }

 
  Future<String> sendReauthCode() async {
    final phone = _auth.currentUser?.phoneNumber;
    if (phone == null) throw StateError('This account has no phone number');

    final completer = Completer<String>();
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
    
        try {
          await _auth.currentUser?.reauthenticateWithCredential(credential);
          if (!completer.isCompleted) completer.complete(alreadyVerified);
        } catch (e) {
          if (!completer.isCompleted) completer.completeError(e);
        }
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
      codeSent: (id, _) {
        if (!completer.isCompleted) completer.complete(id);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    return completer.future.timeout(const Duration(seconds: 45));
  }

 
  Future<void> deleteAccount({
    required String verificationId,
    String? smsCode,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');

    if (verificationId != alreadyVerified) {
      await user.reauthenticateWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode ?? '',
        ),
      ); 
    }

    final uid = user.uid;
   
    await _firestore.collection('users').doc(uid).delete();
    await _firestore.collection('presence').doc(uid).delete();
    await user.delete();
  }
}