import 'package:flutter/material.dart';
import 'package:weekplanner/theme/theme.dart';

class ThemeProvider with ChangeNotifier {

  ThemeMode _themeMode = darkMode;

  ThemeMode get themeMode => _themeMode;

  ThemeData _themeData = darkTheme;

  ThemeData get themeData => _themeData;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleThemeMode() {
    if(_themeMode == lightMode) {
      themeMode = darkMode;
    }else{
      themeMode = lightMode;
    }
    notifyListeners();
  }

  void toggleTheme() {
    if(_themeData == lightTheme) {
      themeData = darkTheme;
    }else{
      themeData = lightTheme;
    }
    notifyListeners();
  }


}

