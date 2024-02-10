import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _appLocale = null; // Default locale is null

  Locale? get appLocale => _appLocale;

  void changeLocale(Locale locale) {
    _appLocale = locale;
    notifyListeners();
  }
}