import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/bubble/reply_quote.dart';
import 'package:chateo/features/chat/data/models/chat_message.dart';
import 'package:material_ui/material_ui.dart';

class ChateoMessageBubble extends StatelessWidget {
  const ChateoMessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMine,
    this.status,
    this.reactions = const {},
    this.onLongPress,
    this.reply,
    this.replyAuthor = '',
    this.onSwipeToReply,
    this.edited = false,
    this.deleted = false,
    this.onEdit,
    this.onDelete,
  });

  final String text;
  final String time;
  final bool isMine;
  final MessageStatus? status;
  final Map<String, String> reactions;
  final VoidCallback? onLongPress;
  final ReplyRef? reply;
  final String replyAuthor;
  final VoidCallback? onSwipeToReply;
  final bool edited;
  final bool deleted;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final background = isMine
        ? (isLight ? AppColors.primaryBrand : AppColors.primaryDark)
        : (isLight ? AppColors.offWhiteLight : AppColors.offWhiteDark);
    final textColor = isMine
        ? Colors.white
        : (isLight ? AppColors.activeLight : AppColors.activeDark);
    final metaColor = isMine ? Colors.white70 : AppColors.mutedLight;
    final metaStyle = AppTextStyles.bodyTextSmall.copyWith(
      fontSize: 10,
      color: metaColor,
    );

    final showMenu = !deleted && (onEdit != null || onDelete != null);

    final footerMeta = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(time, style: metaStyle),
        if (status != null) ...[
          4.widthBox,
          _Tick(status!, metaColor),
          if (status == MessageStatus.read) ...[
            4.widthBox,
            Text('Read', style: metaStyle),
          ],
        ],
      ],
    );

    Widget bubbleContent = Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPress: onLongPress,
              child: IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (deleted || edited)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            deleted ? '(this message was deleted)' : '(edited)',
                            style: metaStyle.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      if (reply != null && !deleted)
                        ReplyQuote(
                          author: replyAuthor,
                          text: reply!.text,
                          isMine: isMine,
                          isLight: isLight,
                        ),
                      if (deleted)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.block,
                            size: 20,
                            color: textColor.withValues(alpha: 0.7),
                          ),
                        )
                      else
                        Text(
                          text,
                          style: AppTextStyles.bodyTextMedium.copyWith(
                            color: textColor,
                          ),
                        ),
                      6.heightBox,
                      showMenu
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: isMine
                                  ? [
                                      _MoreMenu(
                                        color: metaColor,
                                        onEdit: onEdit,
                                        onDelete: onDelete,
                                      ),
                                      footerMeta,
                                    ]
                                  : [
                                      footerMeta,
                                      _MoreMenu(
                                        color: metaColor,
                                        onEdit: onEdit,
                                        onDelete: onDelete,
                                      ),
                                    ],
                            )
                          : Align(
                              alignment: isMine
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: footerMeta,
                            ),
                    ],
                  ),
                ),
              ),
            ),
            if (reactions.isNotEmpty)
              _ReactionPill(reactions: reactions, isLight: isLight),
          ],
        ),
      ),
    );

    if (onSwipeToReply != null) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (direction) async {
          onSwipeToReply!();
          return false;
        },
        background: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.reply,
              color: isLight ? AppColors.primaryBrand : Colors.white70,
            ),
          ),
        ),
        child: bubbleContent,
      );
    }

    return bubbleContent;
  }
}

enum _BubbleAction { edit, delete }

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.color, this.onEdit, this.onDelete});
  final Color color;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_BubbleAction>(
      padding: EdgeInsets.zero,
      tooltip: 'More',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (action) {
        switch (action) {
          case _BubbleAction.edit:
            onEdit?.call();
          case _BubbleAction.delete:
            onDelete?.call();
        }
      },
      itemBuilder: (_) => [
        if (onEdit != null)
          const PopupMenuItem(
            value: _BubbleAction.edit,
            child: _MenuRow(Icons.edit_outlined, 'Edit'),
          ),
        if (onDelete != null)
          const PopupMenuItem(
            value: _BubbleAction.delete,
            child: _MenuRow(
              Icons.delete_outline,
              'Delete',
              color: AppColors.danger,
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(Icons.more_horiz, size: 18, color: color),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(this.icon, this.label, {this.color});
  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _Tick extends StatelessWidget {
  const _Tick(this.status, this.color);
  final MessageStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) => switch (status) {
    MessageStatus.sending => Icon(Icons.schedule, size: 12, color: color),
    MessageStatus.sent => Icon(Icons.done, size: 14, color: color),
    MessageStatus.delivered => Icon(Icons.done_all, size: 14, color: color),
    MessageStatus.read => const Icon(
      Icons.done_all,
      size: 14,
      color: Colors.white,
    ),
  };
}

class _ReactionPill extends StatelessWidget {
  const _ReactionPill({required this.reactions, required this.isLight});
  final Map<String, String> reactions;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final emoji in reactions.values) {
      counts[emoji] = (counts[emoji] ?? 0) + 1;
    }
    final summary = counts.entries
        .map((e) => e.value > 1 ? '${e.key} ${e.value}' : e.key)
        .join(' ');

    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isLight ? AppColors.whiteLight : AppColors.offWhiteDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight ? AppColors.lineLight : AppColors.lineDark,
        ),
      ),
      child: Text(summary, style: const TextStyle(fontSize: 12)),
    );
  }
}
