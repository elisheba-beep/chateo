import 'package:chateo/core/constants/modes/country.dart';
import 'package:chateo/features/auth/data/repositories/phone_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'phone_auth_provider.g.dart';


enum PhoneAuthStatus { idle, sending, codeSent, verifying, error }

class PhoneAuthState {
  const PhoneAuthState({
    this.status = PhoneAuthStatus.idle,
    this.phoneNumber = '',
    this.verificationId,
    this.resendToken,
    this.error,
  });
  final PhoneAuthStatus status;
  final String phoneNumber;
  final String? verificationId;
  final int? resendToken;
  final String? error;

  bool get isLoading =>
      status == PhoneAuthStatus.sending || status == PhoneAuthStatus.verifying;

  PhoneAuthState copyWith({
    PhoneAuthStatus? status,
    String? phoneNumber,
    String? verificationId,
    int? resendToken,
    String? error, 
  }) =>
      PhoneAuthState(
        status: status ?? this.status,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        verificationId: verificationId ?? this.verificationId,
        resendToken: resendToken ?? this.resendToken,
        error: error,
      );
}

@Riverpod(keepAlive: true)
class PhoneAuth extends _$PhoneAuth {
  PhoneAuthRepository get _repo => ref.read(phoneAuthRepositoryProvider);

  @override
  PhoneAuthState build() => const PhoneAuthState();

  String? _toE164(Country c, String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^0+'), '');
    if (digits.length < 6 || digits.length > 14) return null;
    return '${c.dialCode}$digits';
  }

  Future<void> sendCode(Country country, String input, {bool resend = false}) async {
    if (state.isLoading) return;
    final phone = resend ? state.phoneNumber : _toE164(country, input);
    if (phone == null || phone.isEmpty) {
      state = state.copyWith(status: PhoneAuthStatus.error, error: 'Enter a valid phone number.');
      return;
    }
    state = state.copyWith(status: PhoneAuthStatus.sending, phoneNumber: phone);
    try {
      await _repo.sendCode(
        phoneNumber: phone,
        resendToken: resend ? state.resendToken : null,
        onCodeSent: (id, token) => state = state.copyWith(
          status: PhoneAuthStatus.codeSent, verificationId: id, resendToken: token),
        onAutoVerified: _signIn,
        onFailed: (e) =>
            state = state.copyWith(status: PhoneAuthStatus.error, error: _message(e)),
      );
    } catch (e) {
      state = state.copyWith(status: PhoneAuthStatus.error, error: 'Something went wrong.');
    }
  }

  Future<void> verifyCode(String code) async {
    final id = state.verificationId;
    if (id == null || state.isLoading) return;
    await _signIn(_repo.credential(id, code));
  }

  Future<void> _signIn(PhoneAuthCredential cred) async {
    state = state.copyWith(status: PhoneAuthStatus.verifying);
    try {
      await _repo.signIn(cred);
      state = const PhoneAuthState(); 
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(status: PhoneAuthStatus.error, error: _message(e));
    }
  }

  String _message(FirebaseAuthException e) => switch (e.code) {
        'invalid-phone-number' => 'That phone number is invalid.',
        'too-many-requests' => 'Too many attempts. Try again later.',
        'invalid-verification-code' => 'Wrong code. Check the SMS and try again.',
        'session-expired' => 'Code expired. Request a new one.',
        'network-request-failed' => 'No internet connection.',
        _ => e.message ?? 'Something went wrong.',
      };
}