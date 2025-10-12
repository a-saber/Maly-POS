import 'dart:developer';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:pos_app/core/helper/language_manager.dart';

part 'language_control_state.dart';

class LanguageControlCubit extends Cubit<LanguageControlState> {
  LanguageControlCubit() : super(LanguageControlInitial());

  static LanguageControlCubit get(context) => BlocProvider.of(context);

  late Locale local;

  init() {
    local = LanguageManager.getLanguage();
  }

  void changeLanguage({
    required String? language,
  }) {
    if (language == null ||
        language.isEmpty ||
        language == local.languageCode) {
      log(local.languageCode);
      return;
    }
    local = LanguageManager.changeCurrentLanguage();

    emit(LanguageChange());
  }
}
