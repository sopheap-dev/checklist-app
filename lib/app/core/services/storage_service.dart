import 'package:checklist_app/app/core/enums/language_enum.dart';
import 'package:checklist_app/app/core/enums/theme_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _languageKey = 'language:enum';
const _themeKey = 'theme:enum';

class StorageService {
  const StorageService(SharedPreferences prefs) : _prefs = prefs;

  final SharedPreferences _prefs;

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  set language(LanguageEnum language) => setString(_languageKey, language.code);
  LanguageEnum get language => LanguageEnum.from(key: getString(_languageKey));

  set theme(ThemeEnum theme) => setString(_themeKey, theme.code);
  ThemeEnum get theme => ThemeEnum.from(key: getString(_themeKey));
}
