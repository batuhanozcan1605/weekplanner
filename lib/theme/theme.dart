import 'package:flutter/material.dart';

ThemeMode darkMode = ThemeMode.dark;

ThemeMode lightMode = ThemeMode.light;

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color(0xFF2E3239),
    primary: Color(0xFFD0BBFF),
    onBackground: Color(0xFFF3E7E7),
    secondary: Color(0XFF383838)

  )
);

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Color(0xFFF3E7E7),
      primary: Colors.deepPurple,
      onBackground: Colors.black,
      secondary: Colors.white
    ),
);