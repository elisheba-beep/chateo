import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/core/theme/story_backgrounds.dart';
import 'package:chateo/core/utils/chat_time.dart';
import 'package:chateo/features/stories/data/models/story.dart';
import 'package:chateo/features/stories/data/repositories/story_repository.dart';
import 'package:chateo/features/stories/presentation/providers/stories_provider.dart';
import 'package:chateo/features/stories/presentation/widgets/story_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class StoryViewerScreen extends ConsumerStatefulWidget {
  const StoryViewerScreen({required this.group, super.key});
  final StoryGroup group;

  @override
  ConsumerState<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends ConsumerState<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  static const _perStory = Duration(seconds: 5);

  late final AnimationController _progress;
  late final bool _isMine;
  int _index = 0;

  List<Story> get _stories => widget.group.stories;
  Story get _story => _stories[_index];

  @override
  void initState() {
    super.initState();
    _isMine =
        ref.read(firebaseAuthProvider).currentUser?.uid == widget.group.user.uid;

    final seen = ref.read(seenStoriesProvider);
    final firstUnseen = _stories.indexWhere((s) => !seen.contains(s.id));
    _index = firstUnseen == -1 ? 0 : firstUnseen;

    _progress = AnimationController(vsync: this, duration: _perStory)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _next();
      });
    _start();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _start() {
    final id = _story.id;
    Future.microtask(() => ref.read(seenStoriesProvider.notifier).markSeen(id));
    _progress
      ..reset()
      ..forward();
  }

  void _goTo(int index) {
    setState(() => _index = index);
    _start();
  }

  void _next() {
    if (_index < _stories.length - 1) {
      _goTo(_index + 1);
    } else {
      _close();
    }
  }

  void _prev() {
    if (_index > 0) {
      _goTo(_index - 1);
    } else {
      _start(); 
    }
  }

  void _close() {
    if (mounted && context.canPop()) context.pop();
  }

  Future<void> _delete() async {
    _progress.stop();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete story?'),
        content: const Text('It will be removed for everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (ok != true) {
      _progress.forward(); 
      return;
    }
    try {
      await ref.read(storyRepositoryProvider).delete(_story.id);
      _close();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Couldn’t delete: $e')));
      _progress.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = _story;
    final user = widget.group.user;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) {
          final third = MediaQuery.sizeOf(context).width / 3;
          d.globalPosition.dx < third ? _prev() : _next();
        },
        onLongPressStart: (_) => _progress.stop(), 
        onLongPressEnd: (_) => _progress.forward(),
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) > 300) _close(); 
        },
        child: Container(
          decoration: BoxDecoration(gradient: storyGradient(story.bg)),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: AnimatedBuilder(
                    animation: _progress,
                    builder: (_, _) => Row(
                      children: [
                        for (var i = 0; i < _stories.length; i++)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: i < _index
                                      ? 1
                                      : (i == _index ? _progress.value : 0),
                                  minHeight: 3,
                                  backgroundColor: Colors.white30,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 4, 0),
                  child: Row(
                    children: [
                      StoryAvatar(
                        size: 40,
                        imageBytes: user.imageBytes,
                        initials: user.initials,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isMine ? 'Your story' : user.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${dayLabel(story.createdAt)} ${formatClock(story.createdAt)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isMine)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          onPressed: _delete,
                        ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _close,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        story.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}