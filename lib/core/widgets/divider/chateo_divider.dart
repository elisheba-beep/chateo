import 'package:flutter/material.dart';

/// Standard Full-Width Divider
/// Used for clean separation across settings sheets, modal sheets, and standard lists.
class ChateoDivider extends StatelessWidget {
  final double height;
  final double thickness;

  const ChateoDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Divider(
      height: height,
      thickness: thickness,
      color: isLight ? const Color(0xFFEDEDED) : const Color(0xFF152033),
    );
  }
}




