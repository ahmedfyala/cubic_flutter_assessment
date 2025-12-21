import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import '../../generated/locale_keys.g.dart';

class AppValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return LocaleKeys.field_required.tr();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return LocaleKeys.invalid_email.tr();
    return null;
  }

  
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) return LocaleKeys.field_required.tr();
    return null;
  }

  static String? validatePasswordStrict(String? value) {
    if (kDebugMode) {
      if (value == null || value.isEmpty) return LocaleKeys.field_required.tr();
      return null;
    }
    if (value == null || value.isEmpty) return LocaleKeys.field_required.tr();
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    if (!passwordRegex.hasMatch(value))
      return LocaleKeys.password_complexity_error.tr();
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return LocaleKeys.field_required.tr();
    if (value != password) return LocaleKeys.passwords_dont_match.tr();
    return null;
  }

  static bool isEmpty(String? value) => value == null || value.trim().isEmpty;

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) return LocaleKeys.invalid_name.tr();
    return null;
  }
}
