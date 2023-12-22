import 'package:flutter/material.dart';

class ThemeSwitch {
  static bool isTheme(BuildContext context) {
    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    return platformBrightness == Brightness.light || platformBrightness == Brightness.dark;
  }
}
