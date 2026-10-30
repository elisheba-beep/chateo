// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(storyRepository)
final storyRepositoryProvider = StoryRepositoryProvider._();

final class StoryRepositoryProvider
    extends
        $FunctionalProvider<StoryRepository, StoryRepository, StoryRepository>
    with $Provider<StoryRepository> {
  StoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoryRepository create(Ref ref) {
    return storyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryRepository>(value),
    );
  }
}

String _$storyRepositoryHash() => r'6bb0e508ce683dd5a88a2f938025c08a74f7bf8a';
