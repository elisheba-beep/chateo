// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeStories)
final activeStoriesProvider = ActiveStoriesProvider._();

final class ActiveStoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Story>>,
          List<Story>,
          Stream<List<Story>>
        >
    with $FutureModifier<List<Story>>, $StreamProvider<List<Story>> {
  ActiveStoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeStoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeStoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<Story>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Story>> create(Ref ref) {
    return activeStories(ref);
  }
}

String _$activeStoriesHash() => r'fdafdea757ab50340b7803a3be2f0eefcb855840';

@ProviderFor(SeenStories)
final seenStoriesProvider = SeenStoriesProvider._();

final class SeenStoriesProvider
    extends $NotifierProvider<SeenStories, Set<String>> {
  SeenStoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'seenStoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$seenStoriesHash();

  @$internal
  @override
  SeenStories create() => SeenStories();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$seenStoriesHash() => r'62ccb36b4782c9a672bb87f43e5a16d0479fba80';

abstract class _$SeenStories extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(storyFeed)
final storyFeedProvider = StoryFeedProvider._();

final class StoryFeedProvider
    extends $FunctionalProvider<StoryFeed, StoryFeed, StoryFeed>
    with $Provider<StoryFeed> {
  StoryFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyFeedHash();

  @$internal
  @override
  $ProviderElement<StoryFeed> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoryFeed create(Ref ref) {
    return storyFeed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryFeed value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryFeed>(value),
    );
  }
}

String _$storyFeedHash() => r'8d804ce9f745ea50502768a334ec109289531a07';
