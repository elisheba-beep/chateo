import 'package:chateo/features/chat/data/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageAt,
    this.createdAt,
    this.unreadCounts = const {},
    this.lastRead = const {},
    this.lastDelivered = const {},
  });

  final String id;
  final List<String> participantIds;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;
  final Map<String, int> unreadCounts;
  final Map<String, DateTime> lastRead;
  final Map<String, DateTime> lastDelivered;

  static String idFor(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  String otherUid(String myUid) =>
      participantIds.firstWhere((id) => id != myUid, orElse: () => myUid);

  int unreadFor(String uid) => unreadCounts[uid] ?? 0;

  factory ChatRoom.fromMap(Map<String, dynamic> map, {required String id}) {
    return ChatRoom(
      id: id,
      participantIds: List<String>.from(
        map['participantIds'] as List? ?? const [],
      ),
      lastMessage: map['lastMessage'] as String?,
      lastMessageSenderId: map['lastMessageSenderId'] as String?,
      lastMessageAt: (map['lastMessageAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      unreadCounts:
          (map['unreadCounts'] as Map?)?.map(
            (k, v) => MapEntry(k as String, (v as num).toInt()),
          ) ??
          const {},
      lastRead:_times(map['lastRead']),
      lastDelivered: _times(map['lastDelivered']),
    );
  }

  static Map<String, DateTime> _times(Object? raw)=>{
     for (final e in (raw as Map? ?? const {}).entries)
          if (e.value is Timestamp)
            e.key as String: (e.value as Timestamp).toDate(),
  };

  static MessageStatus statusFor(
    ChatMessage m,
    ChatRoom? room,
    String otherUid,
  ){
    final at = m.createdAt;
    if (at == null) return MessageStatus.sending;
    final read = room?.lastRead[otherUid];
    if (read != null && !at.isAfter(read)) return MessageStatus.read;
    final delivered = room?.lastDelivered[otherUid];
    if (delivered != null && !at.isAfter(delivered)){
      return MessageStatus.delivered;
    }
    return MessageStatus.sent;
  }
}
