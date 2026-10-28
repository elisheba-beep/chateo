import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/features/chat/presentation/screens/chat_screen.dart';
import 'package:chateo/features/chat/presentation/screens/more_screen.dart';
import 'package:chateo/features/users/presentation/screens/contacts_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentScreenIndex = 0;
  List screens = [ContactsScreen(), ChatScreen(), MoreScreen()];
  List<String> titles = ['Contacts', 'Chats', 'More'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentScreenIndex], style: AppTextStyles.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/icons/plus.svg'),
          ),
        ],
      ),
      body: screens[currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        currentIndex: currentScreenIndex,
        onTap: (index) {
          setState(() {
            currentScreenIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                theme.colorScheme.inverseSurface,
                BlendMode.srcIn,
              ),
              'assets/icons/group.svg',
            ),
            activeIcon: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Contacts'),
                SvgPicture.asset(
                  width: 4,
                  height: 4,
                  isLight
                      ? 'assets/icons/dot_light.svg'
                      : 'assets/icons/dot_dark.svg',
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                theme.colorScheme.inverseSurface,
                BlendMode.srcIn,
              ),
              'assets/icons/message_circle.svg',
            ),
            activeIcon: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Chats'),
                SvgPicture.asset(
                  width: 4,
                  height: 4,
                  isLight
                      ? 'assets/icons/dot_light.svg'
                      : 'assets/icons/dot_dark.svg',
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              colorFilter: ColorFilter.mode(
                theme.colorScheme.inverseSurface,
                BlendMode.srcIn,
              ),
              'assets/icons/more_horizontal.svg',
            ),
            activeIcon: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('More'),
                SvgPicture.asset(
                  width: 4,
                  height: 4,
                  isLight
                      ? 'assets/icons/dot_light.svg'
                      : 'assets/icons/dot_dark.svg',
                ),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
