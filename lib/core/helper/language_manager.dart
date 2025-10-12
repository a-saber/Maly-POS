import 'dart:ui';

import 'package:pos_app/core/cache/cache_helper.dart';
import 'package:pos_app/core/cache/cache_keys.dart';
import 'package:pos_app/core/helper/is_arabic.dart';
import 'package:pos_app/core/model/language_model.dart';

class LanguageManager {
  static Locale changeCurrentLanguage() {
    if (isArabic()) {
      _saveLangugae(languageModel: LanguageModel.english);
      return _getEnglishLocale();
    } else {
      _saveLangugae(languageModel: LanguageModel.arabic);
      return _getArabicLocale();
    }
  }

  static Locale _getArabicLocale() {
    return const Locale('ar', 'EG');
  }

  static Locale _getEnglishLocale() {
    return const Locale('en');
  }

  static void _saveLangugae({required LanguageModel languageModel}) {
    CacheHelper.saveData(key: CacheKeys.language, value: languageModel.name);
  }

  static Locale getLanguage() {
    String? data = CacheHelper.getString(key: CacheKeys.language);

    LanguageModel languageModel = LanguageModel.values.firstWhere(
      (element) => element.name == data,
      orElse: () => LanguageModel.english,
    );
    if (languageModel == LanguageModel.arabic) {
      return _getArabicLocale();
    } else {
      return _getEnglishLocale();
    }
  }
}
