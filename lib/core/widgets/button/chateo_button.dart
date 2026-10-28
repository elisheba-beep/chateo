import 'package:material_ui/material_ui.dart';

enum ChateoButtonVariant {
  primary, // Solid brand fill accent color
  secondary, // Outlined border variant
}

class ChateoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ChateoButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const ChateoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ChateoButtonVariant.primary,
    this.isLoading = false,
    this.width =
        double.infinity, // Default to matching parent stretch width boundaries
    this.height = 52, // Standard design kit target tap zone hit height
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final bool isDisabled = onPressed == null || isLoading;

    // Determine custom text color styles based on component states
    Color getTextColor() {
      if (isDisabled) {
        return const Color(0xFFADB5BD); // AppColors.muted
      }
      if (variant == ChateoButtonVariant.secondary) {
        return isLight
            ? const Color(0xFF0F1828)
            : const Color(0xFFF7F7FC); // Active Text tokens
      }
      return const Color(
        0xFFFFFFFF,
      ); // Primary solid variant standard text overlay
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: variant == ChateoButtonVariant.primary
              ? const Color(
                  0xFF002DE3,
                ) // AppColors.primaryBrand solid fill color
              : Colors
                    .transparent, // Transparent for standard outlined variants
          disabledBackgroundColor: variant == ChateoButtonVariant.primary
              ? (isLight
                    ? const Color(0xFFD2D9F9)
                    : const Color(0xFF152033)) // Soft disabled states
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ), // Pill-shaped design geometry layout style
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(getTextColor()),
                ),
              )
            : Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: getTextColor(),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
