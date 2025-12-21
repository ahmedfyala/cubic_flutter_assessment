import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class AppLocalizations {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  static const List<Locale> supportedLocales = [
    arabic,
    english,
  ];

  static const String translationsPath = 'assets/translations';

  static bool isEnglish(BuildContext context) {
    return context.locale == english;
  }

  static bool isArabic(BuildContext context) {
    return context.locale == arabic;
  }

  static Future<void> toggleLocale(BuildContext context) async {
    Locale currentLocale = context.locale;
    if (isEnglish(context)) {
      await context.setLocale(arabic);
    } else if (isArabic(context)) {
      await context.setLocale(english);
    }
  }

  static Locale getFirstLanguage(BuildContext context) {
    if (isEnglish(context)) {
      return arabic;
    } else if (isArabic(context)) {
      return english;
    } else {
      return english;
    }
  }

  static Locale getSecondLanguage(BuildContext context) {
    if (isEnglish(context)) {
      return arabic;
    } else if (isArabic(context)) {
      return english;
    } else {
      return arabic;
    }
  }
}
