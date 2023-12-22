import 'package:flutter/material.dart';

enum ChooseMode { dark, light, system }

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(ChooseMode? mode) {
    switch (mode) {
      case ChooseMode.system:
        themeMode = ThemeMode.system;
        break;
      case ChooseMode.dark:
        themeMode = ThemeMode.dark;
        break;
      case ChooseMode.light:
        themeMode = ThemeMode.light;
        break;
      case null:
        themeMode = ThemeMode.system;
    }
    notifyListeners();
  }
}
