import 'package:material_ui/material_ui.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Mulish';

  // Heading 1 (Splash screens / Accent pages)
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  // Heading 2 (Onboarding Headlines)
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  // Title / Subheading (Appbar / Active Lists)
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  // Body Text XLarge (Chat Messaging text)
  static const TextStyle bodyTextXLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  // Body Text Medium (Snippets / Unselected Labels)
  static const TextStyle bodyTextMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  // Body Text Small (Timestamps / Metatags)
  static const TextStyle bodyTextSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );
}
