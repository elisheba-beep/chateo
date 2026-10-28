import 'package:chateo/core/constants/modes/country.dart';
import 'package:chateo/core/constants/sized_boxes.dart';
import 'package:chateo/core/widgets/input/chateo_text_field.dart';
import 'package:material_ui/material_ui.dart';

class ChateoRegistrationPhonePicker extends StatelessWidget {
  const ChateoRegistrationPhonePicker({
    super.key,
    required this.country,
    required this.controller,
    required this.onCountryTap,
  });
  final Country country;
  final TextEditingController controller;
  final VoidCallback onCountryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onCountryTap,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Text(country.flagEmoji, style: const TextStyle(fontSize: 20)),
                8.widthBox,
                Text(
                  country.dialCode,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
        8.widthBox,
        Expanded(
          child: ChateoTextField(
            controller: controller,
            hintText: 'Phone Number',
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}

Future<Country?> showCountryPicker(BuildContext context, Country selected) =>
    showModalBottomSheet<Country>(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => CountryPickerSheet(selected: selected),
    );

class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({super.key, required this.selected});
  final Country selected;
  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  String _q = '';
  @override
  Widget build(BuildContext context) {
    final q = _q.toLowerCase();
    final list = CountryData.all
        .where(
          (c) => c.name.toLowerCase().contains(q) || c.dialCode.contains(q),
        )
        .toList();

        final inset = MediaQuery.viewInsetsOf(context).bottom; // keyboard height
    final height = MediaQuery.sizeOf(context).height * 0.6;
    return Padding(
      padding:  EdgeInsets.only(bottom:inset,),
      child: SizedBox(
        height:height,
        child: Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(16),
              child: ChateoTextField(
                hintText: 'Search country or code',
                prefixIcon: Icons.search,
                onChanged: (v) => setState(() => _q = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final c = list[i];
                  return ListTile(
                    leading: Text(
                      c.flagEmoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(c.name),
                    trailing: Text(c.dialCode),
                    selected: c == widget.selected,
                    onTap: () => Navigator.pop(context, c),
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
