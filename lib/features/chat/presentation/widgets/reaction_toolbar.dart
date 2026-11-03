import 'package:material_ui/material_ui.dart';

class ReactionToolbar extends StatelessWidget {
  const ReactionToolbar({super.key, 
    required this.emojis,
    required this.selectedEmoji,
    required this.onSelected,
  });

  final List<String> emojis;
  final String? selectedEmoji;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: .5),
      elevation: 12,
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final emoji in emojis)
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => onSelected(emoji),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedEmoji == emoji
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.16)
                        : null,
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 23)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



