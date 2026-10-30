// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allPresence)
final allPresenceProvider = AllPresenceProvider._();

final class AllPresenceProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Presence>>,
          Map<String, Presence>,
          Stream<Map<String, Presence>>
        >
    with
        $FutureModifier<Map<String, Presence>>,
        $StreamProvider<Map<String, Presence>> {
  AllPresenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPresenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPresenceHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, Presence>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Presence>> create(Ref ref) {
    return allPresence(ref);
  }
}

String _$allPresenceHash() => r'9291a3654c5dd3be82b65bc776429cf64419bc37';

@ProviderFor(userPresence)
final userPresenceProvider = UserPresenceFamily._();

final class UserPresenceProvider
    extends
        $FunctionalProvider<AsyncValue<Presence?>, Presence?, Stream<Presence?>>
    with $FutureModifier<Presence?>, $StreamProvider<Presence?> {
  UserPresenceProvider._({
    required UserPresenceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userPresenceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userPresenceHash();

  @override
  String toString() {
    return r'userPresenceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Presence?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Presence?> create(Ref ref) {
    final argument = this.argument as String;
    return userPresence(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPresenceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userPresenceHash() => r'bb23993c997b84045ecc085d239c12e91a32d991';

final class UserPresenceFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Presence?>, String> {
  UserPresenceFamily._()
    : super(
        retry: null,
        name: r'userPresenceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserPresenceProvider call(String uid) =>
      UserPresenceProvider._(argument: uid, from: this);

  @override
  String toString() => r'userPresenceProvider';
}

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return clock(ref);
  }
}

String _$clockHash() => r'259b40b559d30befad0ab56efb7023cc7a722b86';

@ProviderFor(presenceTracker)
final presenceTrackerProvider = PresenceTrackerProvider._();

final class PresenceTrackerProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  PresenceTrackerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presenceTrackerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presenceTrackerHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return presenceTracker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$presenceTrackerHash() => r'b500c171b673eeeeb7d102eb09ebf1aef0d61c4f';
