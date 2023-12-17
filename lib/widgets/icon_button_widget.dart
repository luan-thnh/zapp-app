import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';

class IconButtonWidget extends StatelessWidget {
  final String icon;
  final void Function()? onPressed;
  const IconButtonWidget({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        primary: ColorsTheme.primary,
        padding: const EdgeInsets.all(6),
        minimumSize: const Size(32, 32),
      ),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Image(
          image: AssetImage(icon),
          width: 32,
        ),
      ),
    );
  }
}
