import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBrand,
      scaffoldBackgroundColor: AppColors.whiteLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBrand,
        secondary: AppColors.primaryLight,
        surface: AppColors.offWhiteLight,
        error: AppColors.danger,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.activeLight),
        displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.activeLight),
        titleLarge: AppTextStyles.title.copyWith(color: AppColors.activeLight),
        bodyLarge: AppTextStyles.bodyTextXLarge.copyWith(color: AppColors.bodyLight),
        bodyMedium: AppTextStyles.bodyTextMedium.copyWith(color: AppColors.bodyLight),
        bodySmall: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.mutedLight),
      ),
      dividerColor: AppColors.lineLight,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.lineDark,
        surface: AppColors.offWhiteDark,
        error: AppColors.danger,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.activeDark),
        displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.activeDark),
        titleLarge: AppTextStyles.title.copyWith(color: AppColors.activeDark),
        bodyLarge: AppTextStyles.bodyTextXLarge.copyWith(color: AppColors.bodyDark),
        bodyMedium: AppTextStyles.bodyTextMedium.copyWith(color: AppColors.bodyDark),
        bodySmall: AppTextStyles.bodyTextSmall.copyWith(color: AppColors.mutedDark),
      ),
      dividerColor: AppColors.lineDark,
    );
  }
}
