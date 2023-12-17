import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

class ButtonWidget extends StatelessWidget {
  final bool disable;
  final String text;
  final Color textColor, bgColor;
  final bool isUppercase;
  final Function? onPressed;
  final dynamic icon;
  const ButtonWidget(
      {super.key,
      this.disable = true,
      required this.text,
      this.textColor = ColorsTheme.white,
      this.bgColor = ColorsTheme.primary,
      this.isUppercase = true,
      this.icon,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    late Size mq = MediaQuery.of(context).size;
    return TextButton(
      onPressed: () {
        if (onPressed != null) onPressed!();
      },
      style: TextButton.styleFrom(
          primary: bgColor == ColorsTheme.primary ? ColorsTheme.black : textColor,
          backgroundColor: disable ? ColorsTheme.light : bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          minimumSize: Size(mq.width, 50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Container(
              alignment: Alignment.centerRight,
              width: mq.width * .1,
              child: icon!,
            ),
          Container(
            alignment: Alignment.center,
            width: mq.width * .5,
            child: Text(
              isUppercase ? text : text,
              style: TypographyTheme.heading5(color: disable ? ColorsTheme.lightDark : textColor),
            ),
          ),
        ],
      ),
    );
  }
}
