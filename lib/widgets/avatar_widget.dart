import 'package:flutter/material.dart';
import 'package:messenger/constants/image_urls.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final double width;
  final double height;
  const AvatarWidget({super.key, this.avatarUrl = ImageUrls.avatarDefault, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: Image.network(
        avatarUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
