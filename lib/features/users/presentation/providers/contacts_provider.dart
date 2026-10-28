import 'package:chateo/features/users/data/models/user_profile.dart';
import 'package:chateo/features/users/data/repositories/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contacts_provider.g.dart';


@Riverpod(keepAlive: true)
Stream<List<UserProfile>> contacts(Ref ref) =>
   ref.watch(profileRepositoryProvider).watchContacts();

  @riverpod
  class ContactSearch extends _$ContactSearch {
    @override
    String build() {
     return '' ;
    }
    void update(String value)=>state=value;
  }
