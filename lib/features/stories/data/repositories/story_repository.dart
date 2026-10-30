import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/features/stories/data/models/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_repository.g.dart';

@Riverpod(keepAlive: true)
StoryRepository storyRepository(Ref ref) => StoryRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(firebaseFirestoreProvider),
    );

class StoryRepository {
  StoryRepository(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const lifetime = Duration(hours: 24);

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('stories');

  Stream<List<Story>> watchActive() {
    return _col
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .limit(200)
        .snapshots()
        .map((s) => s.docs.map((d) => Story.fromMap(d.data(), id: d.id)).toList());
  }

  Future<void> postText({required String text, required int bg}) async {
    final me = _auth.currentUser?.uid;
    final trimmed = text.trim();
    if (me == null || trimmed.isEmpty) return;

    await _col.add({
      'authorId': me,
      'text': trimmed,
      'bg': bg,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(DateTime.now().add(lifetime)),
    });
  }

  Future<void> delete(String storyId) => _col.doc(storyId).delete();
}