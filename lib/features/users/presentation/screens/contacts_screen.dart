import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/widgets/cells/chateo_chat_cell.dart';
import 'package:chateo/core/widgets/divider/chateo_divider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          children: [
            SearchBar(
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
              ),
              leading: SvgPicture.asset(
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.inverseSurface,
                  BlendMode.srcIn,
                ),
                'assets/icons/search.svg',
              ),
              hintText: 'Search',
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
            16.heightBox,
            Expanded(
              child: ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 6,
                separatorBuilder: (BuildContext context, int index) {
                  return ChateoDivider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return ChateoChatCell(
                    title: 'User 1 name',
                    subtitle: 'last seen',
                    time: '',
                    onTap: () {
                      context.pushNamed(RouteNames.individualChat);
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
