import 'package:flutter/material.dart';


/// Chat Bar Input Field
/// The persistent UI layout wrapper anchoring the bottom of chat thread pages.
class ChateoChatInputBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onAttachPressed;
  final VoidCallback? onSendPressed;
  final ValueChanged<String>? onTextChanged;

  const ChateoChatInputBar({
    super.key,
    this.controller,
    this.onAttachPressed,
    this.onSendPressed,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F1828), // AppColors base background
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: isLight ? const Color(0xFFADB5BD) : const Color(0xFFFFFFFF),
                size: 24,
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
                  fillColor: isLight ? const Color(0xFFF7F7FC) : const Color(0xFF10141E), // AppColors.offWhite
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              icon: Icon(
                Icons.send_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              onPressed: onSendPressed,
            ),
          ],
        ),
      ),
    );
  }
}
