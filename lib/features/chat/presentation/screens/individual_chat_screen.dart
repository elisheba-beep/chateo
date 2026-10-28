import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/theme/app_text_styles.dart';
import 'package:chateo/core/widgets/input/chateo_chat_input_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndividualChatScreen extends ConsumerStatefulWidget {
  const IndividualChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IndividualChatScreenState();
}

class _IndividualChatScreenState extends ConsumerState<IndividualChatScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('user name', style: AppTextStyles.title),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          iconSize: 24,
          icon: SvgPicture.asset(
            'assets/icons/chevron_left.svg',
            colorFilter: ColorFilter.mode(
              theme.colorScheme.inverseSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.inverseSurface,
                BlendMode.srcIn,
              ),
              'assets/icons/search.svg',
            ),
          ),
          8.widthBox,
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.inverseSurface,
                BlendMode.srcIn,
              ),
              'assets/icons/hamburger.svg',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Text('chat');
                  },
                ),
              ),
              ChateoChatInputBar(),
            ],
          ),
        ),
      ),
    );
  }
}
