// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(phoneAuthRepository)
final phoneAuthRepositoryProvider = PhoneAuthRepositoryProvider._();

final class PhoneAuthRepositoryProvider
    extends
        $FunctionalProvider<
          PhoneAuthRepository,
          PhoneAuthRepository,
          PhoneAuthRepository
        >
    with $Provider<PhoneAuthRepository> {
  PhoneAuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneAuthRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneAuthRepositoryHash();

  @$internal
  @override
  $ProviderElement<PhoneAuthRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PhoneAuthRepository create(Ref ref) {
    return phoneAuthRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneAuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneAuthRepository>(value),
    );
  }
}

String _$phoneAuthRepositoryHash() =>
    r'6ef8be2164ea6815c228169c9eb7c39b860f8dd0';
