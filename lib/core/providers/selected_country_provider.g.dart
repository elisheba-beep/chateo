// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_country_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCountry)
final selectedCountryProvider = SelectedCountryProvider._();

final class SelectedCountryProvider
    extends $NotifierProvider<SelectedCountry, Country> {
  SelectedCountryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCountryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCountryHash();

  @$internal
  @override
  SelectedCountry create() => SelectedCountry();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Country value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Country>(value),
    );
  }
}

String _$selectedCountryHash() => r'6d0b59942a1b4433a76224062d9f98e06ecc9967';

abstract class _$SelectedCountry extends $Notifier<Country> {
  Country build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Country, Country>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Country, Country>,
              Country,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
