import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _localeKey = 'selected_locale';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('sw', ''), // Swahili
    Locale('fr', ''), // French
    Locale('ar', ''), // Arabic
  ];

  // Language names in their native languages
  static const Map<String, String> languageNames = {
    'en': 'English',
    'sw': 'Kiswahili',
    'fr': 'Français',
    'ar': 'العربية',
  };

  // Language flags
  static const Map<String, String> languageFlags = {
    'en': '🇺🇸',
    'sw': '🇰🇪',
    'fr': '🇫🇷',
    'ar': '🇸🇦',
  };

  // Get current language code
  static Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }

  // Set current language
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // Get current locale
  static Future<Locale> getCurrentLocale() async {
    final languageCode = await getCurrentLanguage();
    return Locale(languageCode, '');
  }

  // Set current locale
  static Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    await prefs.setString(
      _localeKey,
      '${locale.languageCode}_${locale.countryCode}',
    );
  }

  // Get language name by code
  static String getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? 'English';
  }

  // Get language flag by code
  static String getLanguageFlag(String languageCode) {
    return languageFlags[languageCode] ?? '🇺🇸';
  }

  // Check if language is RTL
  static bool isRTL(String languageCode) {
    return languageCode == 'ar';
  }

  // Get text direction
  static TextDirection getTextDirection(String languageCode) {
    return isRTL(languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }

  // Get all supported languages with their details
  static List<Map<String, String>> getAllLanguages() {
    return supportedLocales.map((locale) {
      final code = locale.languageCode;
      return {
        'code': code,
        'name': getLanguageName(code),
        'flag': getLanguageFlag(code),
        'isRTL': isRTL(code).toString(),
      };
    }).toList();
  }

  // Reset to default language
  static Future<void> resetToDefault() async {
    await setLanguage('en');
  }

  // Clear language preferences
  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
    await prefs.remove(_localeKey);
  }

  // Check if language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
  }

  // Get system locale (if supported)
  static Locale? getSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (isLanguageSupported(systemLocale.languageCode)) {
      return systemLocale;
    }
    return null;
  }

  // Initialize with system locale or default
  static Future<Locale> initializeLocale() async {
    final systemLocale = getSystemLocale();
    if (systemLocale != null) {
      await setLocale(systemLocale);
      return systemLocale;
    }

    // Default to English
    await setLanguage('en');
    return const Locale('en', '');
  }

  // Get locale for MaterialApp
  static Future<Locale> getLocaleForApp() async {
    final currentLanguage = await getCurrentLanguage();
    return Locale(currentLanguage, '');
  }

  // Get locale resolution callback
  static Locale? Function(Locale?, Iterable<Locale>)
  getLocaleResolutionCallback() {
    return (locale, supportedLocales) {
      if (locale != null) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
      }
      return supportedLocales.first;
    };
  }
}
