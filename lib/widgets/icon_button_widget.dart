import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final dynamic icon;
  final Color bgColor;
  final Function()? onPressed;
  const IconButtonWidget({super.key, required this.icon, this.onPressed, this.bgColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
