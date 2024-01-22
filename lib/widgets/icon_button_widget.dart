import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final dynamic icon;
  final Color bgColor;
  final double width;
  final double height;
  final Function()? onPressed;
  const IconButtonWidget({super.key, required this.icon, this.height = 35, this.width = 35, this.onPressed, this.bgColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: icon,
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        onPressed: onPressed,
      ),
    );
  }
}
