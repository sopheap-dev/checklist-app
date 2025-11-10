import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/enums/language_enum.dart';
import 'package:flutter/material.dart';

const FontWeight regular = FontWeight.w400;
const FontWeight semiBold = FontWeight.w600;

class AppTextTheme {
  static TextTheme getKhmerTextTheme({required bool isDarkMode}) {
    final textColor = isDarkMode ? AppColors.darkText : AppColors.text;
    final bodySmallColor =
        isDarkMode ? AppColors.darkSurfaceText : AppColors.text;

    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: regular,
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: regular,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: regular,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: regular,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: regular,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: regular,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: regular,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontSize: 16,
        fontWeight: regular,
        color: textColor,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: regular,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        fontWeight: regular,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        fontWeight: regular,
        color: bodySmallColor,
      ),
    );
  }

  static TextTheme getEnglishTextTheme({required bool isDarkMode}) {
    final textColor = isDarkMode ? AppColors.darkText : AppColors.text;
    final bodySmallColor =
        isDarkMode ? AppColors.darkSurfaceText : AppColors.text;

    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: semiBold,
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: semiBold,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: semiBold,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: semiBold,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: semiBold,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: semiBold,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 12,
        fontWeight: semiBold,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontSize: 16,
        fontWeight: regular,
        color: textColor,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: regular,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        fontWeight: regular,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 10,
        fontWeight: regular,
        color: bodySmallColor,
      ),
    );
  }

  static TextStyle getAppBarTextStyle(LanguageEnum language) {
    return TextStyle(
      fontSize: 18,
      fontWeight: language == LanguageEnum.khmer ? regular : semiBold,
      color: AppColors.white,
    );
  }

  static TextTheme get lightTextTheme => getEnglishTextTheme(isDarkMode: false);
  static TextTheme get darkTextTheme => getEnglishTextTheme(isDarkMode: true);
}
