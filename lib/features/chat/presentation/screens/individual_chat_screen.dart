import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/utils/chat_time.dart';
import 'package:chateo/core/widgets/bubble/chateo_message_bubble.dart';
import 'package:chateo/core/widgets/divider/chateo_date_divider.dart';
import 'package:chateo/core/widgets/input/chateo_chat_input_bar.dart';
import 'package:chateo/features/chat/data/models/chat_message.dart';
import 'package:chateo/features/chat/data/models/chat_room.dart';
import 'package:chateo/features/chat/data/repositories/chat_repository.dart';
import 'package:chateo/features/chat/presentation/providers/message_provider.dart';
import 'package:chateo/features/chat/presentation/widgets/reply_preview.dart';
import 'package:chateo/features/users/data/models/presence.dart';
import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:chateo/features/users/presentation/providers/presence_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndividualChatScreen extends ConsumerStatefulWidget {
  const IndividualChatScreen({
    required this.user,
    required this.chatId,
    super.key,
  });
  final UserProfile user;
  final String chatId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndividualChatScreenState();
}

class _IndividualChatScreenState extends ConsumerState<IndividualChatScreen> {
  ChatMessage? _replyingTo;
  ChatMessage? _editing;
  final _focus = FocusNode();
  final _controller = TextEditingController();
  late final String _me;
  static const _emojis = ['👍', '❤️', '😂', '😮', '😢', '🙏'];

  @override
  void initState() {
    super.initState();
    _me = ref.read(chatRepositoryProvider).currentUid;

    ref.listenManual(chatRoomProvider(widget.chatId), (_, next) {
      final room = next.value;
      if (room != null && room.unreadFor(_me) > 0) {
        ref.read(chatRepositoryProvider).markRead(widget.chatId);
      }
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isLatest(ChatMessage m) {
    final newest = ref.read(messagesProvider(widget.chatId)).value?.firstOrNull;
    final kind =
        ref.read(chatRoomProvider(widget.chatId)).value?.lastMessageKind ??
        'text';
    return newest?.id == m.id && kind == 'text';
  }

  void _startEdit(ChatMessage m) {
    setState(() {
      _editing = m;
      _replyingTo = null;
    });
    _controller.text = m.text;
    _controller.selection = TextSelection.collapsed(offset: m.text.length);
    _focus.requestFocus();
  }

  void _cancelEdit() {
    setState(() => _editing = null);
    _controller.clear();
  }

  Future<void> _confirmDelete(ChatMessage m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('It will be removed for everyone in this chat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref
          .read(chatRepositoryProvider)
          .deleteMessage(
            chatId: widget.chatId,
            messageId: m.id,
            isLatest: _isLatest(m),
          );
    } catch (e) {
      _snack('Couldn’t delete message: $e');
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final editing = _editing;
    if (editing != null) {
      _controller.clear();
      setState(() => _editing = null);
      if (text == editing.text) return;
      try {
        await ref
            .read(chatRepositoryProvider)
            .editMessage(
              chatId: widget.chatId,
              messageId: editing.id,
              newText: text,
              isLatest: _isLatest(editing),
            );
      } catch (e) {
        _snack('Couldn’t edit message: $e');
      }
      return;
    }

    _controller.clear();
    final reply = _replyingTo;
    setState(() => _replyingTo = null);


    try {
      await ref
          .read(chatRepositoryProvider)
          .sendMessage(
            chatId: widget.chatId,
            otherUid: widget.user.uid,
            text: text,
            replyTo: reply == null
                ? null
                : ReplyRef(
                    messageId: reply.id,
                    senderId: reply.senderId,
                    text: reply.text,
                  ),
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Message not sent: $e')));
    }
  }

  Future<void> _react(ChatMessage m) async {
    final mine = m.reactions[_me];
    final picked = await showDialog<String>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              for (final emoji in _emojis)
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(dialogContext).pop(emoji),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: emoji == mine
                          ? Theme.of(context).colorScheme.primary
                                .withValues(alpha: 0.2)
                          : null,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (picked == null) return;

    await ref
        .read(chatRepositoryProvider)
        .setReaction(
          chatId: widget.chatId,
          message: m,
          emoji: picked == mine ? null : picked,
        );
  }

  void reply(ChatMessage m) {
    if (_editing != null) _controller.clear();
    setState(() {
      _editing = null;
      _replyingTo = m;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = ref.watch(messagesProvider(widget.chatId));
    final room = ref.watch(chatRoomProvider(widget.chatId)).value;

    final presence = ref.watch(userPresenceProvider(widget.user.uid)).value;
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user.fullName, style: AppTextStyles.title),
            Text(
              presence.label(now),
              style: AppTextStyles.bodyTextSmall.copyWith(
                color: presence.isOnline(now)
                    ? AppColors.success
                    : AppColors.mutedLight,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          iconSize: 24,
          icon: SvgPicture.asset(
            'assets/icons/chevron_left.svg',
            colorFilter: ColorFilter.mode(
              theme.colorScheme.inverseSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.inverseSurface,
                BlendMode.srcIn,
              ),
              'assets/icons/search.svg',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.inverseSurface,
                  BlendMode.srcIn,
                ),
                'assets/icons/hamburger.svg',
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.when(
                data: (list) {
                  if (list.isEmpty) {
                    return Center(
                      child: Text('Say hi to ${widget.user.firstName}'),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = list[index];
                      final at = message.createdAt ?? DateTime.now();
                      final isMine = message.senderId == _me;

                      final hasOlder = index + 1 < list.length;
                      final showDate =
                          !hasOlder ||
                          !isSameDay(at, list[index + 1].createdAt ?? at);

                      final byId = {for (final m in list) m.id: m};
                      final quoted = message.replyTo;
                      final original = quoted == null
                          ? null
                          : byId[quoted.messageId];
                      final resolvedReply = quoted == null
                          ? null
                          : ReplyRef(
                              messageId: quoted.messageId,
                              senderId: quoted.senderId,
                              text: original == null
                                  ? quoted
                                        .text // older than the loaded window
                                  : (original.deleted
                                        ? 'This message was deleted'
                                        : original.text),
                            );
                      final canManage = isMine && !message.deleted;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showDate)
                            ChateoDateDivider(dateText: dayLabel(at)),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ChateoMessageBubble(
                              text: message.text,
                              time: formatClock(at),
                              isMine: isMine,
                              status: isMine
                                  ? ChatRoom.statusFor(
                                      message,
                                      room,
                                      widget.user.uid,
                                    )
                                  : null,
                              reactions: message.reactions,
                              reply: resolvedReply,
                              replyAuthor: message.replyTo?.senderId == _me
                                  ? 'You'
                                  : widget.user.firstName,
                              edited: message.edited,
                              deleted: message.deleted,
                              onLongPress: message.deleted
                                  ? null
                                  : () => _react(message),
                              onSwipeToReply: message.deleted
                                  ? null
                                  : () => reply(message),
                              onEdit: canManage
                                  ? () => _startEdit(message)
                                  : null,
                              onDelete: canManage
                                  ? () => _confirmDelete(message)
                                  : null,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                error: (e, _) => Center(
                  child: Text(
                    'could not load messages.\n$e',
                    textAlign: TextAlign.center,
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            ChateoChatInputBar(
              controller: _controller,
              focusNode: _focus,
              onSendPressed: _send,
              header: _editing != null
                  ? ReplyPreview(
                      author: 'Edit message',
                      text: _editing!.text,
                      onClose: _cancelEdit,
                    )
                  : (_replyingTo == null
                        ? null
                        : ReplyPreview(
                            author: _replyingTo!.senderId == _me
                                ? 'You'
                                : widget.user.firstName,
                            text: _replyingTo!.text,
                            onClose: () => setState(() => _replyingTo = null),
                          )),
            ),
          ],
        ),
      ),
    );
  }
}
