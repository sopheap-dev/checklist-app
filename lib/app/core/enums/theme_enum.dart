import 'package:flutter/material.dart';

enum ThemeEnum {
  light._(code: 'light', mode: ThemeMode.light),
  dark._(code: 'dark', mode: ThemeMode.dark),
  system._(code: 'system', mode: ThemeMode.system);

  const ThemeEnum._({required this.code, required this.mode});

  final String code;
  final ThemeMode mode;

  static ThemeEnum from({required String? key}) {
    if (key == null) {
      return ThemeEnum.light;
    }

    for (final value in ThemeEnum.values) {
      if (value.code == key) {
        return value;
      }
    }

    return ThemeEnum.light;
  }
}
