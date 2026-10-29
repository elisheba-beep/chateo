import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chateo/core/utils/chat_time.dart';

class Presence {
  const Presence({required this.online, this.lastSeen});

  final bool online;
  final DateTime? lastSeen;

  factory Presence.fromMap(Map<String, dynamic> map) => Presence(
    online: map['online'] as bool? ?? false,
    lastSeen: (map['lastSeen'] as Timestamp?)?.toDate(),
  );

  bool isOnlineAt(DateTime now) =>
      online &&
      lastSeen != null &&
      now.difference(lastSeen!) < const Duration(seconds: 100);
}


extension PresenceLabel on Presence? {
  bool isOnline(DateTime now) => this?.isOnlineAt(now) ?? false;

  String label(DateTime now){
    final seen = this?.lastSeen;
    if(seen == null) return 'Offline';
    if(isOnline(now)) return 'Online';

    final diff = now.difference(seen);
    if(diff.inMinutes < 1) return 'Last seen just now';
    if(diff.inMinutes < 60){
      final m = diff.inMinutes;
      return 'Last seen $m minute${m==1?'':'s'} ago';
    }

    if(isSameDay(seen, now)){
      final h = diff.inHours;
      return 'Last seen $h hour${h==1?'':'s'} ago';
    }

    if(isSameDay(seen, now.subtract(const Duration(days:1)))){
      return 'Last seen yesterday';
    }
    final d = seen.day.toString().padLeft(2, '0');
    final mo = seen.month.toString().padLeft(2, '0');
    return 'Last seen $d/$mo';
  }
}