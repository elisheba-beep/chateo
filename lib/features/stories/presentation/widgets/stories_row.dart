import 'dart:typed_data';

import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/features/stories/presentation/providers/stories_provider.dart';
import 'package:chateo/features/stories/presentation/widgets/story_avatar.dart';
import 'package:chateo/features/users/presentation/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class StoriesRow extends ConsumerWidget {
  const StoriesRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(storyFeedProvider);
    final seen = ref.watch(seenStoriesProvider);
    final me = ref.watch(currentUserProvider).value;
    final mine = feed.mine;

    final tiles = <Widget>[
      _StoryTile(
        label: 'Your Story',
        imageBytes: me?.imageBytes,
        initials: me?.initials,
        isAdd: mine == null,
        ring: mine == null
            ? _Ring.none
            : (mine.hasUnseen(seen) ? _Ring.unseen : _Ring.seen),
        showAddBadge: mine != null,
        onTap: () => mine == null
            ? context.pushNamed(RouteNames.storyComposer)
            : context.pushNamed(RouteNames.storyViewer, extra: mine),
        onAddTap: () => context.pushNamed(RouteNames.storyComposer),
      ),
      for (final group in feed.others)
        _StoryTile(
          label: group.user.firstName,
          imageBytes: group.user.imageBytes,
          initials: group.user.initials,
          ring: group.hasUnseen(seen) ? _Ring.unseen : _Ring.seen,
          onTap: () => context.pushNamed(RouteNames.storyViewer, extra: group),
        ),
    ];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => tiles[i],
      ),
    );
  }
}

enum _Ring { none, unseen, seen }

class _StoryTile extends StatelessWidget {
  const _StoryTile({
    required this.label,
    required this.ring,
    required this.onTap,
    this.imageBytes,
    this.initials,
    this.isAdd = false,
    this.showAddBadge = false,
    this.onAddTap,
  });

  final String label;
  final _Ring ring;
  final VoidCallback onTap;
  final Uint8List? imageBytes;
  final String? initials;
  final bool isAdd;
  final bool showAddBadge;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    // Every variant is 60x60 so the labels line up.
    final Widget face = isAdd
        ? Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.mutedLight, width: 1.5),
            ),
            child: const Icon(Icons.add, color: AppColors.mutedLight),
          )
        : Container(
            padding: const EdgeInsets.all(2), // the ring
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: ring == _Ring.unseen
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primaryBrand, Color(0xFF8E7CFF)],
                    )
                  : null,
              color: ring == _Ring.seen
                  ? AppColors.mutedLight.withValues(alpha: 0.4)
                  : null,
            ),
            child: Container(
              padding: const EdgeInsets.all(2), // the gap
              decoration: BoxDecoration(
                color: scaffoldBg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: StoryAvatar(
                size: 52,
                imageBytes: imageBytes,
                initials: initials,
              ),
            ),
          );

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                face,
                if (showAddBadge)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: GestureDetector(
                      onTap: onAddTap,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrand,
                          shape: BoxShape.circle,
                          border: Border.all(color: scaffoldBg, width: 2),
                        ),
                        child: const Icon(Icons.add, size: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyTextSmall,
            ),
          ],
        ),
      ),
    );
  }
}