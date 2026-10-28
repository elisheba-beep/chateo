import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/avatar/chateo_avatar.dart';
import 'package:chateo/core/widgets/cells/chateo_chat_cell.dart';
import 'package:chateo/core/widgets/divider/chateo_divider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
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
              hintText: 'Placeholder',
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
                    subtitle: 'last message in conversation',
                    time: 'Today',
                    unreadCount: 4,
                    onTap: (){
                      context.pushNamed(RouteNames.individualChat,);
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
