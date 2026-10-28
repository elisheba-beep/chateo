import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/router/route_names.dart';
import 'package:chateo/core/widgets/cells/chateo_chat_cell.dart';
import 'package:chateo/core/widgets/divider/chateo_divider.dart';
import 'package:chateo/features/users/presentation/providers/contacts_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final contacts = ref.watch(contactsProvider);
    final query = ref.watch(contactSearchProvider).trim().toLowerCase();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          children: [
            SearchBar(
              onChanged: ref.read(contactSearchProvider.notifier).update,
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
              child: contacts.when(
                data: (users){
                  final list = query.isEmpty ? users : users.where((u)=>u.fullName.toLowerCase().contains(query)).toList();
                  if(list.isEmpty){
                    return Center(child:Text(query.isEmpty ? 'No contacts yet': 'No results',),);
                  }
                  return ListView.separated(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (BuildContext context, int index) {
                  return ChateoDivider();
                },
                itemBuilder: (BuildContext context, int index) {
                  final user = list[index];
                  return ChateoChatCell(
                    title: user.fullName,
                    subtitle: 'last seen recently',
                    time: '',
                    initials: user.initials,
                    avatarBytes: user.imageBytes,
                    onTap: () {
                      context.pushNamed(RouteNames.individualChat, extra: user,);
                    },
                  );
                },
              );
                },
               error: (e, _)=> Center(child:Text('Couldn\'t load contacts. \n$e',textAlign: TextAlign.center,),),
                loading: ()=>const Center(child:  CircularProgressIndicator()),
                ),
              
            ),
          ],
        ),
      ),
    );
  }
}
