import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Chateo Core Identity Brand Logo
/// Standard identity logo representation used cross-functionally on Splash & Welcome layouts.
class ChateoBrandLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const ChateoBrandLogo({super.key, this.width = 80, this.height = 80});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    // Explicitly pathing out your UI Kit vector assets
    final String assetPath = isLight
        ? 'assets/brand/logo_light.svg'
        : 'assets/brand/logo_dark.svg';

    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
      placeholderBuilder: (BuildContext context) => Container(
        width: width ?? 80,
        height: height ?? 80,
        decoration: const BoxDecoration(
          color: Color(0xFF002DE3), // AppColors.primaryBrand
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.chat_bubble_rounded,
          color: Colors.white,
          size: (width ?? 80) * 0.5,
        ),
      ),
    );
  }
}
