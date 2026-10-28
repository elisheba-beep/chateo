import 'package:material_ui/material_ui.dart';

/// Conversation Date Splitting Node
/// In-chat message thread timeline node used to neatly structure history blocks (e.g., "Today", "Yesterday").
class ChateoDateDivider extends StatelessWidget {
  final String dateText;

  const ChateoDateDivider({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // Muted accent color for the divider line asset
    final Color lineColor = isLight
        ? const Color(0xFFEDEDED)
        : const Color(0xFF152033);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: lineColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              dateText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                // AppColors.muted color parameters
                color: const Color(0xFFADB5BD),
              ),
            ),
          ),
          Expanded(child: Divider(thickness: 1, color: lineColor)),
        ],
      ),
    );
  }
}
