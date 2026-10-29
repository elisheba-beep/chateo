import 'package:chateo/features/chat/data/models/chat_message.dart';
import 'package:chateo/features/chat/data/models/chat_room.dart';
import 'package:chateo/features/chat/data/repositories/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_provider.g.dart';


@riverpod
Stream<List<ChatMessage>> messages(Ref ref, String chatId) =>ref.watch(chatRepositoryProvider).watchMessages(chatId);

@riverpod
Stream<ChatRoom?> chatRoom(Ref ref, String chatId)=>ref.watch(chatRepositoryProvider).watchChatRoom(chatId);