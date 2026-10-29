import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sending, sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime? createdAt;
  final Map<String, String> reactions;
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    this.createdAt,
    this.reactions = const {},
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, {required String id}) {
    return ChatMessage(
      id: id,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      reactions: {
        for (final e in (map['reactions'] as Map? ?? const {}).entries)
          if (e.value is String) e.key as String: e.value as String,
      },
    );
  }
}
