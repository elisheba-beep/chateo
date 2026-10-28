import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:chateo/features/users/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@riverpod
Stream<UserProfile?> currentUser (Ref ref) => ref.watch(profileRepositoryProvider).watchCurrentUser();