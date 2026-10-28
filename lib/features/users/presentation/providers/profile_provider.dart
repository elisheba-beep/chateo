import 'dart:convert';
import 'dart:typed_data';

import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:chateo/features/users/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileRegistration extends _$ProfileRegistration {
  ProfileRepository get _repo => ref.read(profileRepositoryProvider);

  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> registerUser({
    required String firstName,
    String? lastName,
    Uint8List? imageBytes,
  }) async {
    state = const AsyncValue.loading();
    try {
     final base64String = imageBytes == null ? null : base64Encode(imageBytes);

      await _repo.saveProfile(
        UserProfile(
          uid: _repo.currentUid,
          firstName: firstName,
          lastName: lastName,
          base64Image: base64String,
        ),
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}