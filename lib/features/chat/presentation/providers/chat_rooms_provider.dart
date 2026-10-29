import 'package:chateo/features/chat/data/models/chat_preview.dart';
import 'package:chateo/features/chat/data/models/chat_room.dart';
import 'package:chateo/features/chat/data/repositories/chat_repository.dart';
import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:chateo/features/users/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_rooms_provider.g.dart';


@riverpod
Stream<List<ChatRoom>> chatRooms(Ref ref) => ref.watch(chatRepositoryProvider).watchMyChatRooms();

@riverpod
Stream<List<ChatPreview>> chatPreviews(Ref ref) async*{
  final chats = ref.watch(chatRepositoryProvider);
  final profiles = ref.watch(profileRepositoryProvider);
  final me = chats.currentUid;
  final cache = <String, UserProfile>{};

  await for (final rooms in chats.watchMyChatRooms()){
    final missing = rooms.map((r)=>r.otherUid(me)).where((id)=>!cache.containsKey(id)).toSet().toList();

    if (missing.isNotEmpty){
      for (final u in await profiles.getUsersByIds(missing)){
        cache[u.uid] = u;
      }
    }

    yield [
      for (final r in rooms)
      if (cache[r.otherUid(me)] case final u?) ChatPreview(room: r, user: u),
    ];
  }
}