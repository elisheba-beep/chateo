import 'dart:async';

import 'package:chateo/features/users/data/models/presence.dart';
import 'package:chateo/features/users/data/repositories/presence_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'presence_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<Map<String, Presence>> allPresence(Ref ref) =>
    ref.watch(presenceRepositoryProvider).watchAll();

@riverpod
Stream<Presence?> userPresence(Ref ref, String uid) =>
    ref.watch(presenceRepositoryProvider).watch(uid);

@Riverpod(keepAlive: true)
Stream<DateTime> clock(Ref ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 30), (_) => DateTime.now());
}

@Riverpod(keepAlive: true)
void presenceTracker (Ref ref) {
  final tracker = _PresenceTracker(ref.watch(presenceRepositoryProvider))..start();
  ref.onDispose(tracker.dispose);
}


class _PresenceTracker with WidgetsBindingObserver{
  final PresenceRepository _repo;
  _PresenceTracker(this._repo);
  Timer? _heartbeat;


  void start(){
    WidgetsBinding.instance.addObserver(this);
    _goOnline();
  }

  void _goOnline(){
    _repo.setOnline(true);
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(
      const Duration(seconds:45),
      (_)=>_repo.setOnline(true),
    );
  }

  void _goOffline(){
    _heartbeat?.cancel();
    _repo.setOnline(false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    switch (state) {
      case AppLifecycleState.resumed:
        _goOnline();
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _goOffline();
      default:
        break;
    }
  }


  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    _heartbeat?.cancel();
  }
}