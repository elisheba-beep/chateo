import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/cells/chateo_chat_cell.dart';
import 'package:chateo/core/widgets/divider/chateo_divider.dart';
import 'package:chateo/features/chat/data/repositories/chat_repository.dart';
import 'package:chateo/features/users/data/models/presence.dart';
import 'package:chateo/features/users/presentation/providers/contacts_provider.dart';
import 'package:chateo/features/users/presentation/providers/presence_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final contacts = ref.watch(contactsProvider);
    final query = ref.watch(contactSearchProvider).trim().toLowerCase();

    final presences = ref.watch(allPresenceProvider).value ?? const {};
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          children: [
            SearchBar(
              elevation: WidgetStatePropertyAll<double>(0.0),
              onChanged: ref.read(contactSearchProvider.notifier).update,
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
              child: contacts.when(
                data: (users) {
                  final list = query.isEmpty
                      ? users
                      : users
                            .where(
                              (u) => u.fullName.toLowerCase().contains(query),
                            )
                            .toList();
                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        query.isEmpty ? 'No contacts yet' : 'No results',
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return ChateoDivider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final user = list[index];
                      final presence = presences[user.uid];
                      return ChateoChatCell(
                        title: user.fullName,
                        subtitle: presence.label(now),
                        isOnline: presence.isOnline(now),
                        time: '',
                        initials: user.initials,
                        avatarBytes: user.imageBytes,
                        onTap: () async{
                          try{
                            final chatId = await ref.read(chatRepositoryProvider).getOrCreateChatRoom(user.uid);
                            if(!context.mounted)return;

                          context.pushNamed(
                            RouteNames.individualChat,
                            extra: (chatId:chatId, user:user),
                          );
                          }catch(e){
                            if(!context.mounted)return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('could not open chat: $e'),),);
                          }
                        },
                      );
                    },
                  );
                },
                error: (e, _) => Center(
                  child: Text(
                    'Couldn\'t load contacts. \n$e',
                    textAlign: TextAlign.center,
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
