import 'package:chateo/core/providers/firebase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chateo/features/chat/data/repositories/chat_repository.dart';
import 'package:chateo/features/chat/presentation/providers/chat_rooms_provider.dart';

part 'delivery_tracker_provider.g.dart';

@Riverpod(keepAlive: true)
void deliveryTracker(Ref ref) {
  if (ref.watch(authUidProvider).value == null) return;
  final repo = ref.watch(chatRepositoryProvider);
  final me = repo.currentUid;

  ref.listen(chatRoomsProvider, (_, next) {
    final rooms = next.value;
    if (rooms == null) return;
    for (final r in rooms) {
      final lastAt = r.lastMessageAt;
      if (lastAt == null || r.lastMessageSenderId == me) continue;
      final delivered = r.lastDelivered[me];
      if (delivered == null || lastAt.isAfter(delivered)) {
        repo.markDelivered(r.id, lastAt);
      }
    }
  }, fireImmediately: true);
}
