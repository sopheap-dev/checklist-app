part of 'appearance_cubit.dart';

class AppearanceState extends Equatable {
  const AppearanceState({required this.language, required this.theme});

  final LanguageEnum language;
  final ThemeEnum theme;

  AppearanceState copyWith({LanguageEnum? language, ThemeEnum? theme}) {
    return AppearanceState(
      language: language ?? this.language,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [language, theme];
}
