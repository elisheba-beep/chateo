import 'package:chateo/core/providers/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showAppearanceDialog(BuildContext context, WidgetRef ref) {

  final theme = Theme.of(context);
  final current = ref.read(themeModeControllerProvider);
  const options = [
    (ThemeMode.system, 'System default'),
    (ThemeMode.light, 'Light'),
    (ThemeMode.dark, 'Dark'),
  ];

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title:  Text('Appearance',
        style: theme.textTheme.bodyLarge,
      ),
      children: [
        for (final (mode, label) in options)
          ListTile(
            title: Text(label, 
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                   
                  ),
            ),
            trailing: current == mode ?  Icon(Icons.check,   color: theme.primaryColor,) : null,
            onTap: () {
              ref.read(themeModeControllerProvider.notifier).set(mode);
              Navigator.of(dialogContext).pop();
            },
          ),
      ],
    ),
  );
}
