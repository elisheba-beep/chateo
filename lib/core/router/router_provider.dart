import 'dart:async';

import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/widgets/page_not_found/page_not_found.dart';
import 'package:chateo/features/auth/presentation/screens/input_phone_number_screen.dart';
import 'package:chateo/features/auth/presentation/screens/input_verification_code_screen.dart';
import 'package:chateo/features/auth/presentation/screens/profile_registration_screen.dart';
import 'package:chateo/features/chat/presentation/screens/home_screen.dart';
import 'package:chateo/features/chat/presentation/screens/individual_chat_screen.dart';
import 'package:chateo/features/onboarding/presentation/screens/walkthrough_screen.dart';
import 'package:chateo/features/users/data/repositories/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_provider.g.dart';

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(FirebaseAuth auth, FirebaseFirestore firestore) {
    _authSub = auth.authStateChanges().listen((user) {
      _profileSub?.cancel();
      if (user != null) {
        _profileSub = firestore
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
              hasProfile = snapshot.exists;
              notifyListeners();
            });
      } else {
        hasProfile = false;
        notifyListeners();
      }
    });
  }

  late final StreamSubscription<User?> _authSub;
  StreamSubscription<DocumentSnapshot>? _profileSub;
  bool? hasProfile;

  @override
  void dispose() {
    _authSub.cancel();
    _profileSub?.cancel();
    super.dispose();
  }
}

@riverpod
GoRouter router(Ref ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firebaseFirestoreProvider);
  final repo = ref.watch(profileRepositoryProvider);

  final refresh = _AuthRefresh(auth, firestore);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/walkthrough',
    refreshListenable: refresh,
    redirect: (context, state) async {
      final user = auth.currentUser;
      final signedIn = user != null;
      final loc = state.matchedLocation;
      const authFlow = {
        '/walkthrough',
        '/phoneNumberInput',
        '/verificationCodeInput',
      };

      if (!signedIn) {
        if (loc == '/profileRegistration' ||
            loc == '/home' ||
            loc == '/individualChat') {
          return '/phoneNumberInput';
        }
        return null;
      }

      bool exists = refresh.hasProfile ?? false;
      if (refresh.hasProfile == null) {
        exists = await repo.profileExists(user.uid);
      }

      if (exists) {
        if (authFlow.contains(loc) || loc == '/profileRegistration') {
          return '/home';
        }
      } else {
        if (authFlow.contains(loc) || loc == '/home') {
          return '/profileRegistration';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/walkthrough',
        name: RouteNames.walkthrough,
        builder: (context, state) => const WalkthroughScreen(),
      ),
      GoRoute(
        path: '/phoneNumberInput',
        name: RouteNames.phoneNumberInput,
        builder: (context, state) => const InputPhoneNumberScreen(),
      ),
      GoRoute(
        path: '/verificationCodeInput',
        name: RouteNames.verificationCodeInput,
        builder: (context, state) => const InputVerificationCodeScreen(),
      ),
      GoRoute(
        path: '/profileRegistration',
        name: RouteNames.profileRegistration,
        builder: (context, state) => const ProfileRegistrationScreen(),
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/individualChat',
        name: RouteNames.individualChat,
        builder: (context, state) => const IndividualChatScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        PageNotFound(errorMessage: state.error.toString()),
  );
}
