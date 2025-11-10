import 'package:flutter/material.dart';

enum LanguageEnum {
  english._(
    code: 'en',
    countryCode: 'US',
    languageName: 'English',
    locale: Locale('en', 'US'),
  ),
  khmer._(
    code: 'km',
    countryCode: 'KH',
    languageName: 'Khmer',
    locale: Locale('km', 'KH'),
  );

  const LanguageEnum._({
    required this.code,
    required this.countryCode,
    required this.languageName,
    required this.locale,
  });

  final String code;
  final String countryCode;
  final String languageName;
  final Locale locale;

  static LanguageEnum from({required String? key}) {
    if (key == null) {
      return LanguageEnum.english;
    }

    for (final value in LanguageEnum.values) {
      if (value.code == key) {
        return value;
      }
    }

    return LanguageEnum.english;
  }
}
