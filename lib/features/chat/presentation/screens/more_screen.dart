import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:chateo/features/chat/data/mock_Settings.dart';
import 'package:chateo/features/chat/presentation/widgets/settings_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ChateoAvatar(),
                title: Text('User name', style: AppTextStyles.bodyTextMedium),
                subtitle: Text(
                  'user phone number',
                  style: AppTextStyles.bodyTextSmall,
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
                  onTap: setting.onTap,
                );
              }, childCount: chateoSettings.length),
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
