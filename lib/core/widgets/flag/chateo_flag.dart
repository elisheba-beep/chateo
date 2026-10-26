import 'package:chateo/core/constants/modes/country.dart';
import 'package:flutter/material.dart';


class ChateoFlagAsset extends StatelessWidget {
  final Country country;
  final double size;

  const ChateoFlagAsset({
    super.key,
    required this.country,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Image.asset(
        country.flagAssetPath, // Completely type-safe path generation!
        width: size * 1.33,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size * 1.33,
          height: size,
          color: const Color(0xFFEDEDED),
          child: const Icon(Icons.flag_outlined, size: 14, color: Color(0xFFADB5BD)),
        ),
      ),
    );
  }
}
