import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'phone_auth_repository.g.dart';

@Riverpod(keepAlive: true)
PhoneAuthRepository phoneAuthRepository(Ref ref) =>
    PhoneAuthRepository(ref.watch(firebaseAuthProvider));

class PhoneAuthRepository {
  PhoneAuthRepository(this._auth);
  final FirebaseAuth _auth;

  Future<void> sendCode({
    required String phoneNumber,
    int? resendToken,
    required void Function(String id, int? token) onCodeSent,
    required void Function(PhoneAuthCredential) onAutoVerified,
    required void Function(FirebaseAuthException) onFailed,
  }) =>
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: resendToken,
        timeout: const Duration(seconds: 60),
        verificationCompleted: onAutoVerified,
        verificationFailed: onFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (_) {},
      );

  Future<void> signIn(PhoneAuthCredential c) => _auth.signInWithCredential(c);

  PhoneAuthCredential credential(String id, String code) =>
      PhoneAuthProvider.credential(verificationId: id, smsCode: code);
}