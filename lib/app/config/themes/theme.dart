import 'package:checklist_app/app/core/enums/language_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/config/themes/text_theme.dart';

class AppTheme {
  static ThemeData themeLight(LanguageEnum language) {
    final isKhmer = language == LanguageEnum.khmer;
    final textTheme = isKhmer
        ? AppTextTheme.getKhmerTextTheme(isDarkMode: false)
        : AppTextTheme.getEnglishTextTheme(isDarkMode: false);

    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.appBarColor,
        foregroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        centerTitle: true,
        titleTextStyle: AppTextTheme.getAppBarTextStyle(
          language,
        ).copyWith(color: AppColors.white, fontWeight: FontWeight.w600),
      ),
      primaryColor: AppColors.primary,
      primaryColorDark: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      canvasColor: AppColors.lightBackground,
      hintColor: AppColors.hint,
      disabledColor: AppColors.disabled.withValues(alpha: 0.5),
      dividerColor: AppColors.divider,
      iconTheme: const IconThemeData(color: AppColors.text),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        space: 0,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.dialogBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.white,
        filled: true,
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.hint),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.secondary),
      ),
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        error: AppColors.error,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        surfaceContainerHighest: AppColors.lightSurfaceVariant,
        onSurfaceVariant: AppColors.hint,
        outline: AppColors.divider,
        outlineVariant: AppColors.outlineVariantLight,
        primaryContainer: AppColors.lightPrimaryContainer,
        shadow: AppColors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData darkTheme(LanguageEnum language) {
    final isKhmer = language == LanguageEnum.khmer;
    final textTheme = isKhmer
        ? AppTextTheme.getKhmerTextTheme(isDarkMode: true)
        : AppTextTheme.getEnglishTextTheme(isDarkMode: true);

    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.darkAppBarColor,
        foregroundColor: AppColors.darkText,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.darkAppBarColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        centerTitle: true,
        titleTextStyle: AppTextTheme.getAppBarTextStyle(
          language,
        ).copyWith(color: AppColors.darkText, fontWeight: FontWeight.w600),
      ),
      primaryColor: AppColors.primary,
      primaryColorDark: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkBackground,
      hintColor: AppColors.darkHint,
      disabledColor: AppColors.darkDisabled.withValues(alpha: 0.5),
      dividerColor: AppColors.darkDivider,
      iconTheme: const IconThemeData(color: AppColors.darkIcon),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        space: 0,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.darkDialogBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.darkCardColor,
        filled: true,
        errorMaxLines: 2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkCardColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkSecondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.darkError),
        ),
        errorStyle: const TextStyle(color: AppColors.darkError, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.darkHint),
        labelStyle: const TextStyle(color: AppColors.darkText),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        floatingLabelStyle: const TextStyle(color: AppColors.darkSecondary),
      ),
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        tertiary: AppColors.darkTertiary,
        error: AppColors.darkError,
        onSecondary: AppColors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        onSurfaceVariant: AppColors.darkHint,
        outline: AppColors.darkDivider,
        outlineVariant: AppColors.outlineVariantDark,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
        shadow: AppColors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.darkPrimary),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: const BorderSide(color: AppColors.darkPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
