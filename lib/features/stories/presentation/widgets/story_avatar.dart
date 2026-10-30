import 'dart:typed_data';

import 'package:chateo/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class StoryAvatar extends StatelessWidget {
  const StoryAvatar({
    super.key,
    required this.size,
    this.imageBytes,
    this.initials,
  });

  final double size;
  final Uint8List? imageBytes;
  final String? initials;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final fill = isLight ? AppColors.primaryBrand : AppColors.primaryDark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.3),
      child: SizedBox(
        width: size,
        height: size,
        child: imageBytes != null
            ? Image.memory(imageBytes!, fit: BoxFit.cover, gaplessPlayback: true)
            : Container(
                color: fill,
                alignment: Alignment.center,
                child: Text(
                  (initials ?? '').toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: size * 0.33,
                  ),
                ),
              ),
      ),
    );
  }
}