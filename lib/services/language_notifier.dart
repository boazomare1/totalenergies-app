import 'package:flutter/material.dart';
import 'language_service.dart';

class LanguageNotifier extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', '');

  Locale get currentLocale => _currentLocale;

  Future<void> loadCurrentLocale() async {
    _currentLocale = await LanguageService.getCurrentLocale();
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    await LanguageService.setLanguage(languageCode);
    _currentLocale = Locale(languageCode, '');
    notifyListeners();
  }
}
