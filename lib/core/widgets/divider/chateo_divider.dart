import 'package:chateo/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

/// Standard Full-Width Divider
/// Used for clean separation across settings sheets, modal sheets, and standard lists.
class ChateoDivider extends StatelessWidget {
  final double height;
  final double thickness;

  const ChateoDivider({super.key, this.height = 1, this.thickness = 1});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Divider(
      height: height,
      thickness: thickness,
      color: isLight ? AppColors.lineLight : AppColors.lineDark,
    );
  }
}
