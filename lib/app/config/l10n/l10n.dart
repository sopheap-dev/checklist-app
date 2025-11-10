import 'package:flutter/material.dart';
import 'package:checklist_app/app/config/l10n/arb/app_localizations.dart';

enum AppLanguage { english, khmer }

extension AppLanguageExtension on AppLanguage {
  String get languageCode => switch (this) {
    AppLanguage.english => 'en',
    AppLanguage.khmer => 'km',
  };

  String get countryCode => switch (this) {
    AppLanguage.english => 'US',
    AppLanguage.khmer => 'KH',
  };

  String get languageName => switch (this) {
    AppLanguage.english => 'English',
    AppLanguage.khmer => 'Khmer',
  };
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
