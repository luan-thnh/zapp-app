import 'package:flutter/material.dart';
import 'package:messenger/theme/typography_theme.dart';

class ColorsTheme {
  static const Color primary = Color(0xFF5571FD);
  static const Color blue = Color(0xFF157CFF);
  static const Color blueDark = Color(0xFF195AB0);
  static const Color grey = Color(0xFF828387);
  static const Color greyLight = Color(0xFFB5B7BD);
  static const Color light = Color(0xFFF6F6F6);
  static const Color lightDark = Color(0xFFE1E1E1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF18181A);
  static const Color blackSecond = Color(0xFF282727);
  static const Color blackGray = Color(0xFF525357);
  static const Color red = Color(0xFFED0A34);
  static const Color green = Color(0xFF5AD439);
  static const Color purple = Color(0xFF6835F0);
  static const Color pink = Color(0xFFFF0074);

  // set theme app
  static final darkTheme = ThemeData(
    fontFamily: 'Roboto',
    useMaterial3: true,
    scaffoldBackgroundColor: ColorsTheme.black,
    primaryColor: ColorsTheme.black,
    backgroundColor: ColorsTheme.black,
    colorScheme: const ColorScheme(
      primary: ColorsTheme.black,
      brightness: Brightness.dark,
      onPrimary: ColorsTheme.black,
      secondary: ColorsTheme.blackSecond,
      onSecondary: ColorsTheme.blackSecond,
      background: ColorsTheme.black,
      onBackground: ColorsTheme.black,
      error: ColorsTheme.red,
      onError: ColorsTheme.red,
      surface: ColorsTheme.black,
      onSurface: ColorsTheme.black,
      onSecondaryContainer: ColorsTheme.black,
      inversePrimary: ColorsTheme.light,
      tertiary: ColorsTheme.white,
    ),
    iconTheme: const IconThemeData(color: ColorsTheme.light),
    textTheme: TextTheme(
      headline1: TypographyTheme.heading1(color: ColorsTheme.white),
      headline2: TypographyTheme.heading2(color: ColorsTheme.white),
      headline3: TypographyTheme.heading3(color: ColorsTheme.white),
      headline4: TypographyTheme.heading4(color: ColorsTheme.white),
      headline5: TypographyTheme.heading5(color: ColorsTheme.white),
      bodyText1: TypographyTheme.text1(color: ColorsTheme.white),
      bodyText2: TypographyTheme.text2(color: ColorsTheme.white),
      subtitle1: TypographyTheme.text3(color: ColorsTheme.white),
    ),
  );

  static final lightTheme = ThemeData(
    fontFamily: 'Roboto',
    useMaterial3: true,
    scaffoldBackgroundColor: ColorsTheme.white,
    primaryColor: ColorsTheme.white,
    backgroundColor: ColorsTheme.white,
    colorScheme: const ColorScheme(
      primary: ColorsTheme.white,
      brightness: Brightness.dark,
      onPrimary: ColorsTheme.white,
      secondary: ColorsTheme.light,
      onSecondary: ColorsTheme.light,
      background: ColorsTheme.white,
      onBackground: ColorsTheme.white,
      error: ColorsTheme.red,
      onError: ColorsTheme.red,
      surface: ColorsTheme.white,
      onSurface: ColorsTheme.white,
      onSecondaryContainer: ColorsTheme.white,
      inversePrimary: ColorsTheme.blackGray,
      tertiary: ColorsTheme.blackSecond,
    ),
    iconTheme: const IconThemeData(color: ColorsTheme.blackGray),
    textTheme: TextTheme(
      headline1: TypographyTheme.heading1(),
      headline2: TypographyTheme.heading3(),
      headline3: TypographyTheme.heading3(),
      headline4: TypographyTheme.heading4(),
      headline5: TypographyTheme.heading5(),
      bodyText1: TypographyTheme.text1(),
      bodyText2: TypographyTheme.text2(),
      subtitle1: TypographyTheme.text3(),
    ),
  );
}
