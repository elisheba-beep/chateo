// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_tracker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deliveryTracker)
final deliveryTrackerProvider = DeliveryTrackerProvider._();

final class DeliveryTrackerProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  DeliveryTrackerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliveryTrackerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliveryTrackerHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return deliveryTracker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$deliveryTrackerHash() => r'8c235b7d0b6db72c2f1e240650ef55c8b409d485';
