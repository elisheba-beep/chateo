import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    required this.iconPath,
    required this.onTap,
    super.key,
  });
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      dense: true,
      tileColor: Colors.transparent,
      onTap: onTap,
      leading: SvgPicture.asset(
        width: 24,
        height: 24,
        iconPath,
        colorFilter: ColorFilter.mode(
          theme.colorScheme.inverseSurface,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.inverseSurface,
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
    );
  }
}
