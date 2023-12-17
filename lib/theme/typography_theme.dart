import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';

class TypographyTheme {
  static TextStyle headingBig({
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(fontWeight: fontWeight, fontSize: 30);
  }

  static TextStyle heading1({
    Color color = ColorsTheme.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 26);
  }

  static TextStyle heading2({
    Color color = ColorsTheme.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 24);
  }

  static TextStyle heading3({
    Color color = ColorsTheme.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 20);
  }

  static TextStyle heading4({
    Color color = ColorsTheme.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 16);
  }

  static TextStyle heading5({
    Color color = ColorsTheme.black,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 14);
  }

  static TextStyle text1({
    Color color = ColorsTheme.black,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 16);
  }

  static TextStyle text2({
    Color color = ColorsTheme.black,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 14);
  }

  static TextStyle text3({
    Color color = ColorsTheme.grey,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(color: color, fontWeight: fontWeight, fontSize: 12);
  }
}
