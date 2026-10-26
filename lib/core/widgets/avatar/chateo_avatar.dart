import 'package:flutter/material.dart';

/// Chateo Avatar Component
/// Displays a user profile picture slot with an optional live status dot indicator.
class ChateoAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool isOnline;
  final VoidCallback? onTap;

  const ChateoAvatar({
    super.key,
    this.imageUrl,
    this.radius = 28,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: isLight ? const Color(0xFFF7F7FC) : const Color(0xFF10141E), // AppColors.offWhite
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Icon(
                    Icons.person_outline_rounded,
                    size: radius * 0.9,
                    color: const Color(0xFFADB5BD), // AppColors.muted
                  )
                : null,
          ),
          if (isOnline)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: radius * 0.45,
                height: radius * 0.45,
                decoration: BoxDecoration(
                  color: const Color(0xFF2CC069), // AppColors.success
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F1828), // Matches Scaffold Background
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}




