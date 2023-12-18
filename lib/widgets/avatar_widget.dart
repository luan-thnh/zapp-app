import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final double width;
  final double height;
  const AvatarWidget({super.key, required this.avatarUrl, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: Image.asset(
        avatarUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
