import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final dynamic icon;
  final Color bgColor;
  final Function()? onPressed;
  final double size;
  const IconButtonWidget({super.key, required this.icon, this.onPressed, this.bgColor = Colors.transparent, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: icon,
        alignment: Alignment.center,
        onPressed: onPressed,
      ),
    );
  }
}
