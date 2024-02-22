import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  Locale? _appLocale = null; // Default locale is null

  Locale? get appLocale => _appLocale;

  SettingsProvider(locale) {
    locale == 'null' ? _appLocale = null : _appLocale = Locale(locale);
  }

  void changeLocale(String locale) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('locale', locale);
    _appLocale = Locale(locale);
    notifyListeners();
  }
}