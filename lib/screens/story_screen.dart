import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/layouts/navigator_layout.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        isIconEdit: false,
        iconFirst: FaIcon(
          FontAwesomeIcons.film,
          color: ColorsTheme.black,
          size: 20,
        ),
        title: 'Story',
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Story Screen',
              style: TypographyTheme.heading2(),
            ),
          ],
        ),
      ),
    );
  }
}
