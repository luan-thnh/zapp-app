import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/layouts/navigator_layout.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:messenger/widgets/button_widget.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarLayout(
        avatarUrl: ImageUrls.avatarDefault,
        iconFirst: FaIcon(
          FontAwesomeIcons.solidAddressBook,
          color: ColorsTheme.black,
          size: 20,
        ),
        title: 'People',
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share a Story',
              style: TypographyTheme.heading2(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Share photo, video, and more for 24 hours. When you and your friends  share stories, they'll show up here",
              style: TypographyTheme.text1(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            ButtonWidget(text: 'ADD STORY', disable: false),
          ],
        ),
      ),
    );
  }
}
