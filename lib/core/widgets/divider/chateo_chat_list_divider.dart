import 'package:material_ui/material_ui.dart';

/// Indented Chat Item Divider
/// Perfect for message feed screens. It indents the divider line so it lines up
/// beautifully right next to user profile icons/avatars.
class ChateoChatListDivider extends StatelessWidget {
  final double avatarPadding;

  const ChateoChatListDivider({
    super.key,
    this.avatarPadding =
        76, // Standard alignment space to clear the Chateo avatar scale
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Divider(
      height: 1,
      thickness: 1,
      indent: avatarPadding,
      color: isLight ? const Color(0xFFEDEDED) : const Color(0xFF152033),
    );
  }
}
