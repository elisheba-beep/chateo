import 'package:material_ui/material_ui.dart';

class Settings {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const Settings({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });
}

final List<Settings> chateoSettings = [
  Settings(title: 'Appearance', iconPath: 'assets/icons/sun.svg', onTap: () {}),
  Settings(
    title: 'Notification',
    iconPath: 'assets/icons/notification.svg',
    onTap: () {},
  ),
  Settings(
    title: 'Privacy',
    iconPath: 'assets/icons/outline-privacy-tip.svg',
    onTap: () {},
  ),
  Settings(
    title: 'Data Usage',
    iconPath: 'assets/icons/folder.svg',
    onTap: () {},
  ),
];
final List<Settings> helpSettings = [
  Settings(
    title: 'Help',
    iconPath: 'assets/icons/help-circle.svg',
    onTap: () {},
  ),
  Settings(
    title: 'Invite Your Friends',
    iconPath: 'assets/icons/mail.svg',
    onTap: () {},
  ),
];
final List<Settings> accountSettings = [
  Settings(title: 'Account', iconPath: 'assets/icons/user.svg', onTap: () {}),
  Settings(
    title: 'Chats',
    iconPath: 'assets/icons/message_circle.svg',
    onTap: () {},
  ),
];
