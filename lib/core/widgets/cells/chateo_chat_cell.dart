import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:flutter/material.dart';

/// Chateo Messenger Chat Row Cell
/// Standard structural component for conversations list, containing status, badges, and titles.
class ChateoChatCell extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final int unreadCount;
  final String? avatarUrl;
  final bool isOnline;
  final VoidCallback? onTap;

  const ChateoChatCell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            ChateoAvatar(
              imageUrl: avatarUrl,
              radius: 26,
              isOnline: isOnline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: unreadCount > 0 
                          ? (isLight ? const Color(0xFF0F1828) : const Color(0xFFF7F7FC)) // Active message state color
                          : const Color(0xFFADB5BD), // Muted state color
                      fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFADB5BD),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedOpacity(
                  opacity: unreadCount > 0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha:0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}