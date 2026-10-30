import 'package:material_ui/material_ui.dart';

const storyBackgrounds = <List<Color>>[
  [Color(0xFF002DE3), Color(0xFF375FFF)], // brand blue
  [Color(0xFF0F1828), Color(0xFF1B2B48)], // deep navy
  [Color(0xFF5B2BE0), Color(0xFF8E7CFF)], // violet
  [Color(0xFF0E9F8E), Color(0xFF2DD4A7)], // teal
  [Color(0xFFE8590C), Color(0xFFFFA94D)], // amber
  [Color(0xFFD6336C), Color(0xFFFF8787)], // rose
  [Color(0xFF1C7ED6), Color(0xFF74C0FC)], // sky
  [Color(0xFF343A40), Color(0xFF868E96)], // slate
];

LinearGradient storyGradient(int index) {
  final colors = storyBackgrounds[index.clamp(0, storyBackgrounds.length - 1)];
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: colors,
  );
}