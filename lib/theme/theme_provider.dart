import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekplanner/theme/theme.dart';

class ThemeProvider with ChangeNotifier {

  /*ThemeMode _themeMode = darkMode;

  ThemeMode get themeMode => _themeMode;*/

  ThemeData _themeData = darkTheme;

  ThemeData get themeData => _themeData;

  ThemeProvider(bool isDark) {
    if (isDark) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
  }

  /*set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }*/

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  /*void toggleThemeMode() {
    if(_themeMode == lightMode) {
      themeMode = darkMode;
    }else{
      themeMode = lightMode;
    }
    notifyListeners();
  }*/

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(_themeData == lightTheme) {
      themeData = darkTheme;
      sharedPreferences.setBool('isDark', true);
    }else{
      themeData = lightTheme;
      sharedPreferences.setBool('isDark', false);
    }
    notifyListeners();
  }


}

