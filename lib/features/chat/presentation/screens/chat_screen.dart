import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/utils/chat_time.dart';
import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:chateo/core/widgets/cells/chateo_chat_cell.dart';
import 'package:chateo/core/widgets/divider/chateo_divider.dart';
import 'package:chateo/features/chat/data/repositories/chat_repository.dart';
import 'package:chateo/features/chat/presentation/providers/chat_rooms_provider.dart';
import 'package:chateo/features/users/data/models/presence.dart';
import 'package:chateo/features/users/presentation/providers/presence_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final chatPreviews = ref.watch(chatPreviewsProvider);
    final query = ref.watch(chatSearchProvider).trim().toLowerCase();

    final presences = ref.watch(allPresenceProvider).value ?? const {};
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          children: [
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (BuildContext context, int index) {
                  return 16.widthBox;
                },
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ChateoAvatar(),
                      4.heightBox,
                      Text('Your story', style: AppTextStyles.bodyTextSmall),
                    ],
                  );
                },
              ),
            ),
            16.heightBox,
            ChateoDivider(),
            16.heightBox,
            SearchBar(
              elevation: WidgetStatePropertyAll<double>(0.0),
              onChanged: ref.read(chatSearchProvider.notifier).update,

              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
              ),
              leading: SvgPicture.asset(
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.inverseSurface.withValues(alpha: 0.3),

                  BlendMode.srcIn,
                ),
                'assets/icons/search.svg',
              ),
              hintText: 'Search',
              hintStyle: WidgetStatePropertyAll<TextStyle?>(
                AppTextStyles.bodyTextMedium.copyWith(
                  color: theme.colorScheme.inverseSurface.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
            16.heightBox,
            Expanded(
              child: chatPreviews.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Could not load chats. \n$e',
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (items) {
                  final list = query.isEmpty
                      ? items
                      : items
                            .where(
                              (u) =>
                                  u.user.fullName.toLowerCase().contains(query),
                            )
                            .toList();
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        textAlign: TextAlign.center,

                        query.isEmpty
                            ? 'No chats yet.\nStart a new one from contacts'
                            : 'No results',
                      ),
                    );
                  }

                  final me = ref.read(chatRepositoryProvider).currentUid;
                  return ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return ChateoDivider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final person = list[index];
                      final room = person.room;
                      return ChateoChatCell(
                        title: person.user.fullName,
                       subtitle: room.previewFor(me, person.user.firstName),
                        time: room.lastMessageAt == null
                            ? ''
                            : chatListTime(room.lastMessageAt!),
                        unreadCount: room.unreadFor(me),
                        initials: person.user.initials,
                        avatarBytes: person.user.imageBytes,
                        isOnline: presences[person.user.uid].isOnline(now),
                        onTap: () {
                          context.pushNamed(
                            RouteNames.individualChat,
                            extra: (chatId: room.id, user: person.user),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
