import 'dart:typed_data';

import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:material_ui/material_ui.dart';

class StoryAvatar extends StatelessWidget {
  const StoryAvatar({
    super.key,
    required this.size,
    this.imageBytes,
    this.initials,
    this.seed,
  });

  final double size;
  final Uint8List? imageBytes;
  final String? initials;
  final String? seed;

  @override
  Widget build(BuildContext context) =>
      ChateoAvatar(size: size, imageBytes: imageBytes, initials: initials, seed: seed);
}