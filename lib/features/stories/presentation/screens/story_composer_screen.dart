import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/theme/story_backgrounds.dart';
import 'package:chateo/features/stories/data/repositories/story_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class StoryComposerScreen extends ConsumerStatefulWidget {
  const StoryComposerScreen({super.key});

  @override
  ConsumerState<StoryComposerScreen> createState() =>
      _StoryComposerScreenState();
}

class _StoryComposerScreenState extends ConsumerState<StoryComposerScreen> {
  final _controller = TextEditingController();
  int _bg = 0;
  bool _posting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _posting) return;

    setState(() => _posting = true);
    try {
      await ref.read(storyRepositoryProvider).postText(text: text, bg: _bg);
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _posting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Couldn’t post story: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: storyGradient(_bg)),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      maxLines: null,
                      maxLength: 200,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        counterText: '',
                        hintText: 'Type a story',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: storyBackgrounds.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => setState(() => _bg = i),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: storyGradient(i),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: i == _bg ? Colors.white : Colors.white38,
                                  width: i == _bg ? 3 : 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _post,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: _posting
                            ? const Padding(
                                padding: EdgeInsets.all(14),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  'assets/icons/send-alt-filled.svg',
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primaryBrand,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}