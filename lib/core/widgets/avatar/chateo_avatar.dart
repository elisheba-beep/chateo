import 'package:chateo/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

import 'dart:convert';

class ChateoAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? base64Image;
  final String? initials;
  final double radius;
  final bool isOnline;
  final VoidCallback? onTap;

  const ChateoAvatar({
    super.key,
    this.imageUrl,
    this.base64Image,
    this.initials,
    this.radius = 48,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    ImageProvider? getAvatarImage() {
      if (imageUrl != null && imageUrl!.isNotEmpty) {
        return NetworkImage(imageUrl!);
      }
      if (base64Image != null && base64Image!.isNotEmpty) {
        return MemoryImage(base64Decode(base64Image!));
      }
      return null;
    }

    final avatarImage = getAvatarImage();

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: isLight
                ? AppColors.offWhiteLight
                : AppColors.offWhiteDark,
            backgroundImage: avatarImage,
            child: avatarImage == null
                ? (initials != null && initials!.isNotEmpty)
                      ? Text(
                          initials!.toUpperCase(),
                          style: TextStyle(
                            fontSize: radius * 0.7,
                            fontWeight: FontWeight.bold,
                            color: const Color(
                              0xFF002DE3,
                            ), // Primary Brand Color
                          ),
                        )
                      : Icon(
                          Icons.person_outline_rounded,
                          size: radius * 0.9,
                          color: const Color(0xFFADB5BD),
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
                    color: isLight
                        ? const Color(0xFFFFFFFF)
                        : const Color(
                            0xFF0F1828,
                          ), // Matches Scaffold Background
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
