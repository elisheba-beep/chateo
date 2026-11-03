import 'package:chateo/core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class MessageActionMenu extends StatelessWidget {
  const MessageActionMenu({
    super.key,
    required this.onReply,
    required this.onCopy,
    this.onEdit,
    this.onDelete,
  });

  final VoidCallback onReply;
  final VoidCallback onCopy;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: .5),
      elevation: 12,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 230),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionTile(icon: Icons.reply, label: 'Reply', onTap: onReply),
            _ActionTile(icon: Icons.copy, label: 'Copy', onTap: onCopy),
            if (onEdit != null)
              _ActionTile(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: onEdit!,
              ),
            if (onDelete != null)
              _ActionTile(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: AppColors.danger,
                onTap: onDelete!,
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Icon(icon, size: 19, color: foreground),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(color: foreground, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
