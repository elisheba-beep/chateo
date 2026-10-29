import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sending, sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime? createdAt;
  final Map<String, String> reactions;
  final ReplyRef? replyTo;
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    this.createdAt,
    this.reactions = const {},
    this.replyTo
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
      replyTo: ReplyRef.fromMap(map['replyTo']),
    );
  }
}

class ReplyRef {
  const ReplyRef({
    required this.messageId,
    required this.senderId,
    required this.text,
  });
  final String messageId;
  final String senderId;
  final String text;

  Map<String, dynamic> toMap() => {
        'messageId': messageId,
        'senderId': senderId,
        'text': text.length > 100 ? text.substring(0, 100) : text,
      };

  static ReplyRef? fromMap(Object? raw) {
    if (raw is! Map) return null;
    return ReplyRef(
      messageId: raw['messageId'] as String? ?? '',
      senderId: raw['senderId'] as String? ?? '',
      text: raw['text'] as String? ?? '',
    );
  }
}