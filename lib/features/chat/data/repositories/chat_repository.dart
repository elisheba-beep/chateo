import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/features/chat/data/models/chat_message.dart';
import 'package:chateo/features/chat/data/models/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) => ChatRepository(
  ref.watch(firebaseAuthProvider),
  ref.watch(firebaseFirestoreProvider),
);

class ChatRepository {
  ChatRepository(this._auth, this._firestore);
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  String get currentUid => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _firestore.collection('chatRooms');

  Future<String> getOrCreateChatRoom(String otherUid) async {
    final me = currentUid;
    if (me.isEmpty || otherUid.isEmpty || me == otherUid) {
      throw StateError('invalid chat participants');
    }

    final id = ChatRoom.idFor(me, otherUid);
    final ref = _rooms.doc(id);

    final snap = await ref.get();
    if (snap.exists) return id;

    await ref.set({
      'participantIds': [me, otherUid]..sort(),
      'createdAt': FieldValue.serverTimestamp(),
      'unreadCounts': {me: 0, otherUid: 0},
    });
    return id;
  }

  Stream<List<ChatRoom>> watchMyChatRooms() {
    final me = currentUid;
    if (me.isEmpty) return Stream.value(const []);
    return _rooms
        .where('participantIds', arrayContains: me)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ChatRoom.fromMap(d.data(), id: d.id))
              .toList(),
        );
  }

  Stream<ChatRoom?> watchChatRoom(String chatId) => _rooms
      .doc(chatId)
      .snapshots()
      .map((d) => d.exists ? ChatRoom.fromMap(d.data()!, id: d.id) : null);

  Stream<List<ChatMessage>> watchMessages(String chatId, {int limit = 50}) {
    return _rooms
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => ChatMessage.fromMap(d.data(), id: d.id))
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String chatId,
    required String otherUid,
    required String text,
    ReplyRef? replyTo,
  }) async {
    final me = currentUid;
    final trimmed = text.trim();
    if (me.isEmpty || trimmed.isEmpty) return;

    final roomRef = _rooms.doc(chatId);
    final msgRef = roomRef.collection('messages').doc();

    final batch = _firestore.batch();
    batch.set(msgRef, {
      'senderId': me,
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
      if (replyTo != null) 'replyTo': replyTo.toMap(),
    });
    batch.update(roomRef, {
      'lastMessage': trimmed.length > 100 ? trimmed.substring(0, 100) : trimmed,
      'lastMessageKind': 'text',
      'lastMessageSenderId': me,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unreadCounts.$otherUid': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> markRead(String chatId) async {
    final me = currentUid;
    if (me.isEmpty) return;
    await _rooms.doc(chatId).update({
      'unreadCounts.$me': 0,
      'lastRead.$me': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markDelivered(String chatId, DateTime at) async {
    final me = currentUid;
    if (me.isEmpty) return;
    await _rooms.doc(chatId).update({
      'lastDelivered.$me': Timestamp.fromDate(at),
    });
  }

   Future<void> setReaction({
    required String chatId,
    required ChatMessage message,
    String? emoji,
  }) async {
    final me = currentUid;
    final roomRef = _rooms.doc(chatId);
    final batch = _firestore.batch();

    batch.update(roomRef.collection('messages').doc(message.id), {
      'reactions.$me': emoji ?? FieldValue.delete(),
    });

    if (emoji != null && message.senderId != me) {
      batch.update(roomRef, {
        'lastMessage': emoji,
        'lastMessageKind': 'reaction',
        'lastMessageSenderId': me,
        'lastMessageTargetSenderId': message.senderId,
        'lastMessageAt': FieldValue.serverTimestamp(),
        'unreadCounts.${message.senderId}': FieldValue.increment(1),
      });
    }
    await batch.commit();
  }

    Future<void> editMessage({
    required String chatId,
    required String messageId,
    required String newText,
    required bool isLatest,
  }) async {
    final text = newText.trim();
    if (text.isEmpty) return;

    final roomRef = _rooms.doc(chatId);
    final batch = _firestore.batch();
    batch.update(roomRef.collection('messages').doc(messageId), {
      'text': text,
      'edited': true,
    });
    if (isLatest) {
      batch.update(roomRef, {
        'lastMessage': text.length > 100 ? text.substring(0, 100) : text,
      });
    }
    await batch.commit();
  }

  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
    required bool isLatest,
  }) async {
    final roomRef = _rooms.doc(chatId);
    final batch = _firestore.batch();
    batch.update(roomRef.collection('messages').doc(messageId), {
      'text': '',
      'deleted': true,
      'edited': FieldValue.delete(),
      'reactions': FieldValue.delete(),
      'replyTo': FieldValue.delete(),
    });
    if (isLatest) {
      batch.update(roomRef, {'lastMessage': '', 'lastMessageKind': 'deleted'});
    }
    await batch.commit();
  }
}
