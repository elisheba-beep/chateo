import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/features/stories/data/models/story.dart';
import 'package:chateo/features/stories/data/repositories/story_repository.dart';
import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:chateo/features/users/presentation/providers/contacts_provider.dart';
import 'package:chateo/features/users/presentation/providers/current_user_provider.dart';
import 'package:chateo/features/users/presentation/providers/presence_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'stories_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<Story>> activeStories(Ref ref) {
  if (ref.watch(authUidProvider).value == null) return const Stream.empty();
  return ref.watch(storyRepositoryProvider).watchActive();
}

@Riverpod(keepAlive: true)
class SeenStories extends _$SeenStories {
  static const _key = 'seen_story_ids';

  @override
  Set<String> build() {
    _load();
    return {};
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? const [];
    state = {...saved, ...state}; 
  }

  Future<void> markSeen(String id) async {
    if (state.contains(id)) return;
    state = {...state, id};
    final prefs = await SharedPreferences.getInstance();
    final list = state.toList();
    await prefs.setStringList(
      _key,
      list.length > 300 ? list.sublist(list.length - 300) : list,
    );
  }
}

class StoryFeed {
  const StoryFeed({this.mine, this.others = const []});
  final StoryGroup? mine;
  final List<StoryGroup> others;
}

@riverpod
StoryFeed storyFeed(Ref ref) {
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  final seen = ref.watch(seenStoriesProvider);
  final me = ref.watch(authUidProvider).value;
  final myProfile = ref.watch(currentUserProvider).value;
  final profiles = {
    for (final u in ref.watch(contactsProvider).value ?? const <UserProfile>[])
      u.uid: u,
  };

 
  final stories = (ref.watch(activeStoriesProvider).value ?? const <Story>[])
      .where((s) => s.expiresAt.isAfter(now))
      .toList();

  final byAuthor = <String, List<Story>>{};
  for (final s in stories) {
    byAuthor.putIfAbsent(s.authorId, () => []).add(s);
  }

  StoryGroup? mine;
  final others = <StoryGroup>[];
  byAuthor.forEach((uid, list) {
    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (uid == me) {
      if (myProfile != null) mine = StoryGroup(user: myProfile, stories: list);
    } else {
      final user = profiles[uid];
      if (user != null) others.add(StoryGroup(user: user, stories: list));
    }
  });

 
  others.sort((a, b) {
    final aUnseen = a.hasUnseen(seen);
    final bUnseen = b.hasUnseen(seen);
    if (aUnseen != bUnseen) return aUnseen ? -1 : 1;
    return b.latestAt.compareTo(a.latestAt);
  });

  return StoryFeed(mine: mine, others: others);
}