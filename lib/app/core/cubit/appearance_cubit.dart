import 'package:checklist_app/app/core/enums/language_enum.dart';
import 'package:checklist_app/app/core/enums/theme_enum.dart';
import 'package:checklist_app/app/core/services/storage_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'appearance_state.dart';

class AppearanceCubit extends Cubit<AppearanceState> {
  AppearanceCubit(StorageService storageService)
    : _storageService = storageService,
      super(
        AppearanceState(
          language: storageService.language,
          theme: storageService.theme,
        ),
      );

  final StorageService _storageService;

  void changeLanguage(LanguageEnum language) {
    _storageService.language = language;
    emit(state.copyWith(language: language));
  }

  void changeTheme(ThemeEnum theme) {
    _storageService.theme = theme;
    emit(state.copyWith(theme: theme));
  }
}
