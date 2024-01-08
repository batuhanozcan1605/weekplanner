import 'package:flutter/material.dart';

ThemeMode darkMode = ThemeMode.dark;

ThemeMode lightMode = ThemeMode.light;

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Colors.black,
    primary: Color(0xFFD0BBFF),
    onBackground: Color(0xFFF3E7E7),

  )
);

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Color(0xFFF3E7E7),
      primary: Colors.purple,
      onBackground: Colors.black,

    ),
);