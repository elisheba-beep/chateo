// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PhoneAuth)
final phoneAuthProvider = PhoneAuthProvider._();

final class PhoneAuthProvider
    extends $NotifierProvider<PhoneAuth, PhoneAuthState> {
  PhoneAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneAuthHash();

  @$internal
  @override
  PhoneAuth create() => PhoneAuth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneAuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneAuthState>(value),
    );
  }
}

String _$phoneAuthHash() => r'2a078a9bdb361a863166786e0571efd7e93c2e9f';

abstract class _$PhoneAuth extends $Notifier<PhoneAuthState> {
  PhoneAuthState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PhoneAuthState, PhoneAuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhoneAuthState, PhoneAuthState>,
              PhoneAuthState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
