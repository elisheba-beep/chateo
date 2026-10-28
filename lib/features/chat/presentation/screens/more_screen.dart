import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:chateo/core/widgets/divider/chateo_divider.dart';
import 'package:chateo/features/chat/data/mock_Settings.dart';
import 'package:chateo/features/chat/presentation/widgets/appearance_dialog.dart';
import 'package:chateo/features/chat/presentation/widgets/settings_tile.dart';
import 'package:chateo/features/users/presentation/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profile = ref.watch(currentUserProvider);
    final phone = ref.watch(firebaseAuthProvider).currentUser?.phoneNumber;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: profile.when(
                data: (user) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ChateoAvatar(
                    imageBytes: user?.imageBytes,
                    initials: user?.initials,
                    radius: 24,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      user?.fullName ?? '',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    phone ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFADB5BD),
                    ),
                  ),
                  trailing: SvgPicture.asset(
                    width: 24,
                    height: 24,
                    'assets/icons/chevron_right.svg',
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.inverseSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                error: (_, _) => const Text('Couldn\'t load your profile'),
                loading: () => const SizedBox(
                  height: 56,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                final setting = accountSettings[index];
                return SettingsTile(
                  title: setting.title,
                  iconPath: setting.iconPath,
                  onTap: setting.onTap,
                );
              }, childCount: accountSettings.length),
            ),
          ),
          SliverToBoxAdapter(child: 16.heightBox),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                final setting = chateoSettings[index];
                return SettingsTile(
                  title: setting.title,
                  iconPath: setting.iconPath,
                  onTap: setting.title == 'Appearance'
                      ? () => showAppearanceDialog(context, ref)
                      : setting.onTap,
                );
              }, childCount: chateoSettings.length),
            ),
          ),
           SliverToBoxAdapter(child: ChateoDivider()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                final setting = helpSettings[index];
                return SettingsTile(
                  title: setting.title,
                  iconPath: setting.iconPath,
                  onTap: setting.onTap,
                );
              }, childCount: helpSettings.length),
            ),
          ),
          SliverToBoxAdapter(child: 16.heightBox),
        ],
      ),
    );
  }
}
