import 'package:chateo/features/chat/data/models/chat_room.dart';
import 'package:chateo/features/users/data/models/user_profile.dart';

class ChatPreview {
  final ChatRoom room;
  final UserProfile user;

  new({required this.room, required this.user});
}