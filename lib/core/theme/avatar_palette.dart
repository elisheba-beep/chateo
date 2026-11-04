import 'package:material_ui/material_ui.dart';

const _palette = <Color>[
  Color(0xFF375FFF), // brand blue
  Color(0xFF5B5BD6), // indigo
  Color(0xFF7C4DFF), // violet
  Color(0xFF1C7ED6), // sky
  Color(0xFF0E9F8E), // teal
  Color(0xFF2F9E44), // green
  Color(0xFFE8590C), // amber
  Color(0xFFD6336C), // rose
];

List<Color> avatarColorsFor(String? seed) {
  var hash = 0;
  for (final unit in (seed ?? '').codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  final base = _palette[hash % _palette.length];
  return [Color.lerp(base, Colors.white, 0.22)!, base];
}
