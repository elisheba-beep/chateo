// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(messages)
final messagesProvider = MessagesFamily._();

final class MessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          Stream<List<ChatMessage>>
        >
    with
        $FutureModifier<List<ChatMessage>>,
        $StreamProvider<List<ChatMessage>> {
  MessagesProvider._({
    required MessagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'messagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messagesHash();

  @override
  String toString() {
    return r'messagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatMessage>> create(Ref ref) {
    final argument = this.argument as String;
    return messages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messagesHash() => r'bc2bcc5f67affc34ab118165c6ae911690d8d428';

final class MessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatMessage>>, String> {
  MessagesFamily._()
    : super(
        retry: null,
        name: r'messagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MessagesProvider call(String chatId) =>
      MessagesProvider._(argument: chatId, from: this);

  @override
  String toString() => r'messagesProvider';
}

@ProviderFor(chatRoom)
final chatRoomProvider = ChatRoomFamily._();

final class ChatRoomProvider
    extends
        $FunctionalProvider<AsyncValue<ChatRoom?>, ChatRoom?, Stream<ChatRoom?>>
    with $FutureModifier<ChatRoom?>, $StreamProvider<ChatRoom?> {
  ChatRoomProvider._({
    required ChatRoomFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomHash();

  @override
  String toString() {
    return r'chatRoomProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ChatRoom?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<ChatRoom?> create(Ref ref) {
    final argument = this.argument as String;
    return chatRoom(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomHash() => r'343f5bd081df347100bc8244159561c46494b98b';

final class ChatRoomFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ChatRoom?>, String> {
  ChatRoomFamily._()
    : super(
        retry: null,
        name: r'chatRoomProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatRoomProvider call(String chatId) =>
      ChatRoomProvider._(argument: chatId, from: this);

  @override
  String toString() => r'chatRoomProvider';
}
