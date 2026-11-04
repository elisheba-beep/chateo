import 'package:chateo/core/theme/app_colors.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/utils/chat_time.dart';
import 'package:chateo/core/widgets/backgrounds/chat_doodle_background.dart';
import 'package:chateo/core/widgets/bubble/chateo_message_bubble.dart';
import 'package:chateo/core/widgets/divider/chateo_date_divider.dart';
import 'package:chateo/core/widgets/input/chateo_chat_input_bar.dart';
import 'package:chateo/features/chat/data/models/chat_message.dart';
import 'package:chateo/features/chat/data/models/chat_room.dart';
import 'package:chateo/features/chat/data/repositories/chat_repository.dart';
import 'package:chateo/features/chat/presentation/providers/message_provider.dart';
import 'package:chateo/features/chat/presentation/widgets/message_action_menu.dart';
import 'package:chateo/features/chat/presentation/widgets/reaction_toolbar.dart';
import 'package:chateo/features/chat/presentation/widgets/reply_preview.dart';
import 'package:chateo/features/users/data/models/presence.dart';
import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:chateo/features/users/presentation/providers/presence_provider.dart';
import 'package:flutter/services.dart';
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
  ChatMessage? _selectedMessage;
  final LayerLink _selectionLink = LayerLink();
  OverlayEntry? _selectionEntry;
  final GlobalKey _selectedBubbleKey = GlobalKey();

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

  void _selectMessage(ChatMessage message) {
    if (message.deleted) return;
    _focus.unfocus();
    setState(() {
      _selectedMessage = message;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedMessage?.id != message.id) return;
      _showSelectionOverlay(message);
    });
  }

  double _calculateSelectionOffset({required bool canManage}) {
    final targetContext = _selectedBubbleKey.currentContext;
    if (targetContext == null) return 0.0;
    final renderObject = targetContext.findRenderObject();

    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return 0.0;
    }

    final targetTop = renderObject.localToGlobal(Offset.zero).dy;
    final targetBottom = targetTop + renderObject.size.height;

    final mediaQuery = MediaQuery.of(context);

    const tileHeight = 41.0;
    const reactionToolbarHeight = 48.0;
    const spacing = 10.0;

    final menuHeight = canManage ? tileHeight * 4 : tileHeight * 2;
    final topLimit = mediaQuery.padding.top + 12;
    final bottomLimit = mediaQuery.size.height - mediaQuery.padding.bottom - 12;
    final selectionTop = targetTop - reactionToolbarHeight - spacing;
    final selectionBottom = targetBottom + spacing + menuHeight;
    if (selectionBottom > bottomLimit) {
      return -(selectionBottom - bottomLimit);
    }

    if (selectionTop < topLimit) {
      return topLimit - selectionTop;
    }

    return 0.0;
  }

  void _showSelectionOverlay(ChatMessage message) {
    _removeSelectionOverlay();
    final room = ref.watch(chatRoomProvider(widget.chatId)).value;
    final isMine = message.senderId == _me;
    final canManage = isMine && !message.deleted;
    final selectionOffset = _calculateSelectionOffset(canManage: canManage);
    final myReaction = message.reactions[_me];
    final at = message.createdAt ?? DateTime.now();

    _selectionEntry = OverlayEntry(
      builder: (_) {
        final isLight = Theme.of(context).brightness == Brightness.light;
        final bubble = ChateoMessageBubble(
          text: message.text,
          time: formatClock(at),
          isMine: isMine,
          status: isMine
              ? ChatRoom.statusFor(message, room, widget.user.uid)
              : null,
          reactions: message.reactions,
          reply: message.replyTo,
          replyAuthor: message.replyTo?.senderId == _me
              ? 'You'
              : widget.user.firstName,
          edited: message.edited,
          deleted: message.deleted,
          selected: true,
        );

        return Material(
          type: MaterialType.transparency,
          child: SizedBox.expand(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _dismissSelection,
                    child: ColoredBox(
                      color: Colors.black.withValues(
                        alpha: isLight ? 0.32 : 0.52,
                      ),
                    ),
                  ),
                ),
                CompositedTransformFollower(
                  link: _selectionLink,
                  showWhenUnlinked: false,
                  targetAnchor: Alignment.center,
                  followerAnchor: Alignment.center,
                  offset: isMine
                      ? Offset(-20, selectionOffset)
                      : Offset(20, selectionOffset),

                  child: bubble,
                ),
                CompositedTransformFollower(
                  link: _selectionLink,
                  showWhenUnlinked: false,
                  targetAnchor: isMine ? Alignment.topRight : Alignment.topLeft,
                  followerAnchor: isMine
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  offset: Offset(0, selectionOffset - 10),
                  child: ReactionToolbar(
                    emojis: _emojis,
                    selectedEmoji: myReaction,
                    onSelected: (emoji) async {
                      _dismissSelection();
                      try {
                        await ref
                            .read(chatRepositoryProvider)
                            .setReaction(
                              chatId: widget.chatId,
                              message: message,
                              emoji: emoji == myReaction ? null : emoji,
                            );
                      } catch (e) {
                        _snack('Couldn’t react to message: $e');
                      }
                    },
                  ),
                ),
                CompositedTransformFollower(
                  link: _selectionLink,
                  showWhenUnlinked: false,
                  targetAnchor: isMine
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  followerAnchor: isMine
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  offset: Offset(0, selectionOffset + 10),
                  child: MessageActionMenu(
                    onReply: () {
                      _dismissSelection();
                      reply(message);
                    },
                    onCopy: () async {
                      await Clipboard.setData(
                        ClipboardData(text: message.text),
                      );
                      _dismissSelection();
                      _snack('Message copied');
                    },
                    onEdit: canManage
                        ? () {
                            _dismissSelection();
                            _startEdit(message);
                          }
                        : null,
                    onDelete: canManage
                        ? () {
                            _dismissSelection();
                            _confirmDelete(message);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_selectionEntry!);
  }

  void _removeSelectionOverlay() {
    _selectionEntry?.remove();
    _selectionEntry = null;
  }

  void _dismissSelection() {
    _removeSelectionOverlay();
    if (mounted) {
      setState(() {
        _selectedMessage = null;
      });
    }
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
      body: ChatDoodleBackground(
        child: SafeArea(
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
                                    ? quoted.text
                                    : (original.deleted
                                          ? 'This message was deleted'
                                          : original.text),
                              );

                        final bubble = ChateoMessageBubble(
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
                              : () => _selectMessage(message),
                          onSwipeToReply: message.deleted
                              ? null
                              : () => reply(message),
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (showDate)
                              ChateoDateDivider(dateText: dayLabel(at)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: message.id == _selectedMessage?.id
                                  ? CompositedTransformTarget(
                                      key: _selectedBubbleKey,
                                      link: _selectionLink,
                                      child: bubble,
                                    )
                                  : bubble,
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
      ),
    );
  }
}
