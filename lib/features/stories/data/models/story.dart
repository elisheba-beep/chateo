import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  const Story({
    required this.id,
    required this.authorId,
    required this.text,
    required this.bg,
    required this.createdAt,
    required this.expiresAt,
  });

  final String id;
  final String authorId;
  final String text;
  final int bg;
  final DateTime createdAt;
  final DateTime expiresAt;

  factory Story.fromMap(Map<String, dynamic> map, {required String id}) {
    final created = (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    return Story(
      id: id,
      authorId: map['authorId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      bg: (map['bg'] as num?)?.toInt() ?? 0,
      createdAt: created,
      expiresAt: (map['expiresAt'] as Timestamp?)?.toDate() ??
          created.add(const Duration(hours: 24)),
    );
  }
}

class StoryGroup {
  const StoryGroup({required this.user, required this.stories});

  final UserProfile user;
  final List<Story> stories;

  DateTime get latestAt => stories.last.createdAt;

  bool hasUnseen(Set<String> seen) => stories.any((s) => !seen.contains(s.id));
}