import 'package:flutter_svg/svg.dart';
import 'package:material_ui/material_ui.dart';

/// Chat Bar Input Field
/// The persistent UI layout wrapper anchoring the bottom of chat thread pages.
class ChateoChatInputBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onAttachPressed;
  final VoidCallback? onSendPressed;
  final ValueChanged<String>? onTextChanged;
  final Widget? header;

  const ChateoChatInputBar({
    super.key,
    this.controller,
    this.onAttachPressed,
    this.onSendPressed,
    this.onTextChanged,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 30, left:8, right:8),
      color:
      
      isLight
                      ? const Color(0xFFF7F7FC)
                      : const Color(0xFF10141E),
      child: SafeArea(
        child: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
             ?header,
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
            
                  icon: SvgPicture.asset(
                    'assets/icons/plus.svg',
                    colorFilter: ColorFilter.mode(
                      isLight ? const Color(0xFFADB5BD) : const Color(0xFFFFFFFF),
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                  onPressed: onAttachPressed,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onTextChanged,
                    style: theme.textTheme.bodyMedium,
                    cursorColor: theme.colorScheme.primary,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: const TextStyle(
                        color: Color(0xFFADB5BD), // AppColors.muted
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor:  isLight
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF0F1828), 
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(
                    'assets/icons/send-alt-filled.svg',
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
                  onPressed: onSendPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
