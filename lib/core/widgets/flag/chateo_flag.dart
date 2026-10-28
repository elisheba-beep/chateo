import 'package:chateo/core/constants/modes/country.dart';
import 'package:material_ui/material_ui.dart';

class ChateoFlag extends StatelessWidget {
  const ChateoFlag({super.key, required this.country, this.size = 24});

  final Country country;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(country.flagEmoji, style: TextStyle(fontSize: size));
  }
}
