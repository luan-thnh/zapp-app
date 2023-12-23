import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger/constants/image_urls.dart';
import 'package:messenger/layouts/appbar_layout.dart';
import 'package:messenger/layouts/navigator_layout.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';

import '../widgets/button_widget.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No Active People',
                style: TypographyTheme.heading2(),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'You"ll see when  others are active here. You can also invite more friends  to join Messenger.',
                style: TypographyTheme.text2(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const ButtonWidget(
                text: 'INVITE PEOPLE',
                disable: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
