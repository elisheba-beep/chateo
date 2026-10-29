// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_rooms_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatRooms)
final chatRoomsProvider = ChatRoomsProvider._();

final class ChatRoomsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatRoom>>,
          List<ChatRoom>,
          Stream<List<ChatRoom>>
        >
    with $FutureModifier<List<ChatRoom>>, $StreamProvider<List<ChatRoom>> {
  ChatRoomsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRoomsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRoomsHash();

  @$internal
  @override
  $StreamProviderElement<List<ChatRoom>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatRoom>> create(Ref ref) {
    return chatRooms(ref);
  }
}

String _$chatRoomsHash() => r'8a856fce0970fd72d1b8fd060dead0dafb5fe712';

@ProviderFor(chatPreviews)
final chatPreviewsProvider = ChatPreviewsProvider._();

final class ChatPreviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatPreview>>,
          List<ChatPreview>,
          Stream<List<ChatPreview>>
        >
    with
        $FutureModifier<List<ChatPreview>>,
        $StreamProvider<List<ChatPreview>> {
  ChatPreviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatPreviewsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatPreviewsHash();

  @$internal
  @override
  $StreamProviderElement<List<ChatPreview>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatPreview>> create(Ref ref) {
    return chatPreviews(ref);
  }
}

String _$chatPreviewsHash() => r'fbd19a463624eaf5335cda8d2e9728c8797394af';

@ProviderFor(ChatSearch)
final chatSearchProvider = ChatSearchProvider._();

final class ChatSearchProvider extends $NotifierProvider<ChatSearch, String> {
  ChatSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSearchHash();

  @$internal
  @override
  ChatSearch create() => ChatSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$chatSearchHash() => r'd2787daf0b5eef00c8b5c6eae95a23be26906281';

abstract class _$ChatSearch extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
