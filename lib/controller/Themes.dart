import 'package:flutter/material.dart';

class myTheme {
  static ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith();
  static ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
      appBarTheme: AppBarTheme(
          foregroundColor: Colors.white, backgroundColor: Colors.blue),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white)));
}
