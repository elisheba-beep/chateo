import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/features/chat/presentation/providers/delivery_tracker_provider.dart';
import 'package:chateo/features/chat/presentation/screens/chat_screen.dart';
import 'package:chateo/features/chat/presentation/screens/more_screen.dart';
import 'package:chateo/features/users/presentation/providers/presence_provider.dart';
import 'package:chateo/features/users/presentation/screens/contacts_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentScreenIndex = 0;
  List screens = [ContactsScreen(), ChatScreen(), MoreScreen()];
  List<String> titles = ['Contacts', 'Chats', 'More'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    ref.watch(presenceTrackerProvider);
    ref.watch(deliveryTrackerProvider);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            titles[currentScreenIndex],
            style: AppTextStyles.title.copyWith(letterSpacing: 1.01),
          ),
        ),
        actions: [
          currentScreenIndex == 0
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.inverseSurface,
                        BlendMode.srcIn,
                      ),
                      'assets/icons/plus.svg',
                    ),
                  ),
                )
              : currentScreenIndex == 1
              ? IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.inverseSurface,
                      BlendMode.srcIn,
                    ),
                    'assets/icons/message_plus_alt.svg',
                  ),
                )
              : SizedBox.shrink(),
          currentScreenIndex == 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),

                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.inverseSurface,
                        BlendMode.srcIn,
                      ),
                      'assets/icons/list_check.svg',
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
      body: screens[currentScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        fixedColor: Colors.transparent,
        elevation: 0,
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
                4.heightBox,
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
                4.heightBox,
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
                4.heightBox,
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
