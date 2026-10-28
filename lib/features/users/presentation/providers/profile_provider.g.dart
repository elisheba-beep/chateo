// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileRegistration)
final profileRegistrationProvider = ProfileRegistrationProvider._();

final class ProfileRegistrationProvider
    extends $NotifierProvider<ProfileRegistration, AsyncValue<void>> {
  ProfileRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRegistrationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRegistrationHash();

  @$internal
  @override
  ProfileRegistration create() => ProfileRegistration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$profileRegistrationHash() =>
    r'2d8f4dd379a68a7ec39b0c1bd28b84d551f86291';

abstract class _$ProfileRegistration extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
