import 'dart:typed_data';

import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/theme/avatar_palette.dart';
import 'package:material_ui/material_ui.dart';

enum StoryRing { none, seen, unseen }

class ChateoAvatar extends StatelessWidget {
  const ChateoAvatar({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.initials,
    this.seed,
    this.size = 50,
    this.isOnline = false,
    this.ring = StoryRing.none,
    this.onTap,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final String? initials;
  final String? seed; 
  final double size;
  final bool isOnline;
  final StoryRing ring;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final hasRing = ring != StoryRing.none;
    final inner = hasRing ? size - 8 : size; 

    Widget face = ClipRRect(
      borderRadius: BorderRadius.circular(inner * 0.32),
      child: SizedBox(width: inner, height: inner, child: _content(inner)),
    );

    if (hasRing) {
      face = Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.36),
          gradient: ring == StoryRing.unseen
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryBrand, Color(0xFF8E7CFF)],
                )
              : null,
          color: ring == StoryRing.seen
              ? AppColors.mutedLight.withValues(alpha: 0.4)
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: scaffoldBg,
            borderRadius: BorderRadius.circular(size * 0.34),
          ),
          child: face,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            face,
            if (isOnline)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: scaffoldBg, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _content(double dimension) {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.cover, gaplessPlayback: true);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(imageUrl!, fit: BoxFit.cover);
    }

    final hasInitials = initials != null && initials!.isNotEmpty;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: avatarColorsFor(seed),
        ),
      ),
      child: Center(
        child: hasInitials
            ? Text(
                initials!.toUpperCase(),
                textHeightBehavior: const TextHeightBehavior(
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: dimension * 0.36,
                  height: 1,
                ),
              )
            : Icon(
                Icons.person_outline_rounded,
                size: dimension * 0.5,
                color: Colors.white70,
              ),
      ),
    );
  }
}