// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(contacts)
final contactsProvider = ContactsProvider._();

final class ContactsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserProfile>>,
          List<UserProfile>,
          Stream<List<UserProfile>>
        >
    with
        $FutureModifier<List<UserProfile>>,
        $StreamProvider<List<UserProfile>> {
  ContactsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsHash();

  @$internal
  @override
  $StreamProviderElement<List<UserProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<UserProfile>> create(Ref ref) {
    return contacts(ref);
  }
}

String _$contactsHash() => r'a51700c71daab2945e6e3022d6f2bec1be407819';

@ProviderFor(ContactSearch)
final contactSearchProvider = ContactSearchProvider._();

final class ContactSearchProvider
    extends $NotifierProvider<ContactSearch, String> {
  ContactSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactSearchHash();

  @$internal
  @override
  ContactSearch create() => ContactSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$contactSearchHash() => r'9b2fe4ed5d784ee969d138cf2f60fe7c7139b200';

abstract class _$ContactSearch extends $Notifier<String> {
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
