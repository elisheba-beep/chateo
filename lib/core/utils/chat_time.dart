const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String _two(int n) => n.toString().padLeft(2, '0');

String formatClock(DateTime t) => '${_two(t.hour)}.${_two(t.minute)}';

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;


String dayLabel(DateTime t) {
  final now = DateTime.now();
  if (isSameDay(t, now)) return 'Today';
  if (isSameDay(t, now.subtract(const Duration(days: 1)))) return 'Yesterday';
  return '${_days[t.weekday - 1]}, ${_two(t.day)}/${_two(t.month)}';
}


String chatListTime(DateTime t) {
  final now = DateTime.now();
  if (isSameDay(t, now)) return formatClock(t);
  if (isSameDay(t, now.subtract(const Duration(days: 1)))) return 'Yesterday';
  return '${_two(t.day)}/${_two(t.month)}';
}